# payleven mPOS SDK

[![CocoaPods](https://img.shields.io/badge/Licence-MIT-brightgreen.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Platform-iOS-yellow.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Requires-iOS%207+-blue.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/github/tag/Payleven/mPOS-SDK-iOS.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Made%20in-Berlin-red.svg?style=flat-square)]()

This project provides an iOS API to communicate with the payleven Classic (Chip & PIN) and Plus (NFC) card reader in order to accept debit and credit card payments. Learn more on one of payleven's regional [websites](https://payleven.com/).
The Payleven mPOS SDK provides an API to process refund payments starting from version 1.1.0. Additionally, the SDK issues a receipt image of sale and refund payments that contains the bare minimum of receipt details. Please keep in mind to extend the image with the merchants name, address and a respective receipt ID. In case you wish to create your own receipt by using a set of raw payment data, please contact <a href="mailto:developer@payleven.com">developer@payleven.com</a>.

The SDK is a static library which supports other platforms like Xamarin and is fully compatible with the i386, x86_64, armv7, arm64 architectures.

### Prerequisites
1. Register on one of payleven's regional [websites](https://payleven.com/) in order to get personal merchant account and a card reader.
2. Request an API key by registering at the [payleven developer page](https://service.payleven.com/uk/developer) for the mPOS SDK.

### Table of Contents
* [Installation](#installation)
    * [CocoaPods](#cocoapods)
    * [Manual Set-Up](#manual-set-up)
    * [MFi Program Authorization](#mfi-program-authorization)
    * [Bluetooth pairing](#bluetooth-pairing)
* [Getting started](#getting-started)
  * [Authenticate your app](#authenticate-your-app)
  * [The manager Objective-C](#the-manager-objective-c)
  * [Lazy initialization Objective-C](#lazy-initialization-objective-c)
  * [Handling login in Objective-C](#handling-login-in-objective-c)
  * [Select the card reader](#select-the-card-reader)
    * [Selecting a device in Objective-C](#selecting-a-device-in-objective-c)
    * [Boarding the device for payment in Objective-C](#boarding-the-device-for-payment-in-objective-c)
* [Start payment](#start-payment)
  * [Handle payment](#handle-payment)
  * [Example of a card reader chip payment](#example-of-a-card-reader-chip-payment)
  * [Example of a card reader swipe payment](#example-of-a-card-reader-swipe-payment)
* [Refunds](#refunds)
  * [Refund Prerequisites](#refund-prerequisites)
  * [Handling refunds in Objective-C](#handling-refunds-in-objective-c)
* [Documentation](#documentation)
* [mPOS SDK Sample App](#mpos-sdk-sample-app)

### Installation

##### CocoaPods

	pod 'Payleven-mPos', '~> 1.0'

##### Manual Set Up

1. Drag *PaylevenSDK.framework*, *AdyenToolkit.framework*, and *AdyenToolkit.bundle* into your Xcode project.

2. Open the *Build Phases* of your target and add the following frameworks to the *Link Binary With Libraries* section:

        CoreData.framework  
        CoreLocation.framework
        ExternalAccessory.framework
        SystemConfiguration.framework
        libsqlite3.0.dylib
		AVFoundation.framework
		AudioToolbox.framework

3. Open the *Build Settings* of your target and 
  * add `-ObjC` flag to Other Linker Flags

4. Import PaylevenSDK into your files:

        #import <PaylevenSDK/PaylevenSDK.h>

5. Open the *Info.plist* and add the following entries:

  * `CFBundleDisplayName` with the display name for your app.
  * `UISupportedExternalAccessoryProtocols` with an array of just one value `com.adyen.bt1`.
  * For iOS 8: `NSLocationWhenInUseUsageDescription` or `NSLocationAlwaysUsageDescription`, for iOS 7: `NSLocationUsageDescription` with the location usage description message for the users.
  * App Transport Security as follows:
```	<key>NSAppTransportSecurity</key>
	    <dict>
	        <key>NSExceptionDomains</key>
	        <dict>
	            <key>payleven.de</key>
	            <dict>
	                <key>NSExceptionRequiresForwardSecrecy</key>
	                <false/>
	                <key>NSIncludesSubdomains</key>
	                <true/>
	            </dict>
	        </dict>
	    </dict>
```

##### MFi Program Authorization
Before submitting your iOS app to iTunes, Apple requires registration of all iOS apps that communicate with approved MFi devices. This registration process officially associates your app with the card reader and can be performed by payleven. Once your app (bundle ID) has been registered, future app versions do not require additional registrations. Please contact developer@payleven.com for help with your submission.

##### Bluetooth pairing
Before proceeding with the integration and testing make sure you have paired the card reader in the bluetooth settings on your iOS device.
 1. Make sure the device is charged and turned on.
 2. Press '0' key on the card reader for 5 sec and make sure the card reader has entered the pairing mode (there will be a corresponding sign on the screen).
 3. Go to the bluetooth settings of your iOS device and turn on bluetooth.
 4. Select the discovered payleven card reader and follow the instructions on both devices to finish the pairing process.

### Getting started    
#### Authenticate your app
Use API key received from payleven together with your payleven merchant account to authenticate your app. 
Hint: Check out our Sample Demo to see how you can easily observe the Login State using KVO.

#### The manager Objective-C
The object manager in our sample app provides a unified interface to a set of interfaces in a subsystem. It is a semi-facade system interface that makes easier to use. It contains many objects as well as our PLVPayleven object which is allocated on the first time a message is sent to self.manager.payleven.

#### Lazy initialization Objective-C
```objective-c
- (PLVPayleven *)payleven {
    if (_payleven){
        return _payleven;
    }
    _payleven = [[PLVPayleven alloc]init];
    return _payleven;
}
```
#### Handling login in Objective-C
 ```objective-c

- (void)loginWithUserName:(NSString *)username password:(NSString *)password {
    __weak typeof(self) weakSelf = self;
    [self.manager.payleven loginWithUsername:username password:password APIKey:self.manager.APIKey completionHandler:^(NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if([strongSelf.delegate conformsToProtocol:@protocol(PSLoginDelegate)]) {
            if(error) {
                [strongSelf.delegate loginDidFailWithError:error];
            } else {
                [strongSelf.delegate loginViewControllerDidFinish:(PSLoginViewController *)strongSelf.delegate];
            }
        }
    }];
}
```

#### Select the card reader
Once a `PLVPayleven` instance is created you need to select the card reader for your future payments.


#### Selecting a device in Objective-C
 ```objective-c
 //You probably want to visualize the devices in a UITableView
 NSArray * pairedDevices = self.manager.payleven.devices;
 
 //Get the selected device from the list
  PLVDevice *device = self.sortedDevices[indexPath.row];
  NSString * deviceName = device.name;
 ```

##### Boarding the device for payment in Objective-C
 ```objective-c
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.00 * NSEC_PER_SEC));
    __weak typeof(self)weakSelf = self;
    
    dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        [device prepareWithCompletionHandler:^(NSError *error) {
            if (device.ready) {
                [strongSelf didSuccessfullyPrepareDevice:device controller:strongSelf];
            } else {
                [strongSelf didFailConfiguringDeviceWithError:error controller:strongSelf];
            }
        }];
    });
 ```
  
#### Start payment
Initialize the actual payment request. For security purposes you must provide the user's current location in the PaymentReuest.

 ```objective-c
 //Here we are using an arbitrary location. In your app you must provide the user's current location
 CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(52.5243700, 13.4105300);
 
 NSLocale* locale = [NSLocale currentLocale];
 NSDecimalNumber* amount = [NSDecimalNumber decimalNumberWithString:@"1.00" locale:locale];
 
 PLVPaymentRequest* request = [[PLVPaymentRequest alloc] initWithIdentifier:@"anArbitraryUniqueIdentifier"
                                                                     amount:amount
                                                                   currency:@"EUR"
                                                                 coordinate:coordinate];
                                                                 
 //Hint: the corresponding delegate is PLVPaymentTaskDelegate                                                                
 self.paymentTask = [self.manager.payleven paymentTaskWithRequest:request device:self.device delegate:self]
 if (self.paymentTask == nil) {
    //Could not create Payment  
 } else {
    [self.paymentTask start];
 }

 ```
 
#### Handle payment
Implement PLVPaymentTaskDelegate's methods to respond to payment events such as the request of a payer's signature, its final approval or any errors.

 ```objective-c
 - (void)paymentTask:(PLVPaymentTask *)paymentTask
        needsSignatureWithCompletionHandler:(void (^)(BOOL, CGImageRef))completionHandler {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController
        = [storyboard instantiateViewControllerWithIdentifier:@"SignatureConfirmationNavigationController"];
    SignatureConfirmationViewController *signatureConfirmationViewController
        = (SignatureConfirmationViewController *)navigationController.topViewController;
    

	//Get Payer's signature and return using completionBlock (See our Sample App for full implementation)
	UIImage * signature = ...
    completionHandler(true, signature.CGImage);

 }

 - (void)paymentTaskDidFinish:(PLVPaymentTask *)paymentTask { 
	   
    self.receiptGenerator = paymentTask.result.receiptGenerator;
    CGFloat scale = [UIScreen mainScreen].scale;
    [self.receiptGenerator generateReceiptWithWidth:(384.0 * scale)
                                           fontSize:(16.0 * scale)
                                        lineSpacing:(8.0 * scale)
                                            padding:(20.0 * scale)
                                  completionHandler:
     ^(CGImageRef receipt) {
         CGFloat scale = [UIScreen mainScreen].scale;
         UIImage *image = [UIImage imageWithCGImage:receipt scale:scale orientation:UIImageOrientationUp];
         self.receiptGenerator = nil;
     }];
    
    self.paymentTask = nil;
 }

 - (void)paymentTask:(PLVPaymentTask *)paymentTask didFailWithError:(NSError *)error {
   	//Error handling
    self.paymentTask = nil;
 }
```

Optionally, you can offer a more meaningful user experience by implementing progressDidChange method as shown below. 

```objective-c
-(void)paymentTask:(PLVPaymentTask *)paymentTask progressDidChange:(PLVPaymentProgressState)progressState
{
    NSString *progressStateDescriptor;
    
    switch (progressState) {
        case PLVPaymentProgressStateNone:
            progressStateDescriptor = @"None";
            break;
        case PLVPaymentProgressStateStarted:
            progressStateDescriptor = @"Started";
            break;
        case PLVPaymentProgressStateRequestInsertCard:
            progressStateDescriptor = @"Please insert card";
            break;
        case PLVPaymentProgressStateRequestPresentCard:
            progressStateDescriptor = @"Please present card";
            break;
        case PLVPaymentProgressStateCardInserted:
            progressStateDescriptor = @"Card inserted";
            break;
        case PLVPaymentProgressStateRequestEnterPin:
            progressStateDescriptor = @"Please enter Pin";
            break;
        case PLVPaymentProgressStatePinEntered:
            progressStateDescriptor = @"Pin entered";
            break;
        case PLVPaymentProgressStateContactlessBeepFailed:
            progressStateDescriptor = @"Contactless Tap failed";
            break;
        case PLVPaymentProgressStateContactlessBeepOk:
            progressStateDescriptor = @"Contactless Tap Ok";
            break;
        case PLVPaymentProgressStateRequestSwipeCard:
            progressStateDescriptor = @"Please swipe card";
            break;
        default:
            break;
    }
    
	//Display progressStateDescriptor to your user
}
```


##### Example of a card reader Chip payment
```
Pan = 7445
PanMaximumLength = 16
PanSequence = 00
PosEntryMode = ICC
CardBrandId = mastercard_mastercard
CardBrandName = MasterCard
Cvm = SIGNATURE
Aid = A0000000041020
AuthCode = 030720
ExpiryYear = 2017
ExpiryMonth = 3
```

##### Example of a card reader SWIPE payment
```
Pan = 7445
PanMaximumLength = 16
PosEntryMode = MAGNETIC_READER
CardBrandId = mastercard_mastercard
CardBrandName = MasterCard
AuthCode = 010150
ExpiryYear = 2017
ExpiryMonth = 3
```

#### Refunds
PLVRefundRequest is used to create or generate the request for refunds that will later be executed by the PLVRefundTask instance. The SDK comes with a custom method that can be directly accessed from in the PLVPayleven.h file via the following method below:

```objective-c
- (PLVRefundTask *)refundTaskWithRequest:(PLVRefundRequest *)request
                       completionHandler:( void (^)(PLVRefundResult *result, NSError *error))completionHandler;
```

The aforementioned method comes with a completionHandler block which returns two objects. The first is the PLVRefundResult which contains the server reponse and the later is NSError. This will be nil if the refund go through successfully. On the other hand if there is an execption the PLVRefundResult will be nil and the NSError will be populated.

#### Refund Prerequisites

```c
//Create a method that requires the necessary parameters 
1. Identifier //A String type to identify the refund or better known as the refundId 
2. Amount //An NSDecimalNumber indicating the amount to be refunded
3. PaymentIdentifier //A String type. Basically original paymentId reference from which the refund will deducted.
4. Currency //A 3 letter ISO character which is also the same referenced in the original payment. e.g EUR 
```

#### Handling refunds in Objective-C

This follows a similar design to the above mentioned swift workflow. The only difference is the change in the programming syntax.

```objective-c

//Create an internal refundTask object to store the task. 
//We used internal but this is based on what you want to do
//and how your app is designed. You can also add it in the header file.
    @property (nonatomic) PLVRefundTask *refundTask;
//Same applies here for the result so create a refundResult object to hold the response
    @property (nonatomic) PLVRefundResult *refundResult;

```
The method below could be triggered as soon as it conforms to the prerequisites required for the refund.

```objective-c

- (void)performRefundTask {
    NSDecimalNumber *amount = [PSPriceDecimal decimalForIntWithMantissa:self.currentAmount.intValue];
    NSString *refundIdentifier = self.manager.randomString;
    PLVRefundRequest *request = [[PLVRefundRequest alloc]initWithIdentifier:refundIdentifier
                                                          paymentIdentifier:self.externalIdTextField.text
                                                                     amount:amount
                                                                   currency:self.manager.currency
                                                          refundDescription:nil];
    __weak typeof(self)weakSelf = self;
    __strong typeof(weakSelf)strongSelf = weakSelf;
    self.refundTask = [self.manager.payleven refundTaskWithRequest:request completionHandler:^(PLVRefundResult *result, NSError *error) {
        if(error){
            [strongSelf.delegate refundViewControllerDidFinish:^{
                strongSelf.refundMessage = error.localizedDescription;
                [strongSelf performSegueWithIdentifier:RefundResultViewSegue sender:self];
            }];
        } else {
            [strongSelf updatePayment:result.refund merchantId:strongSelf.manager.merchantId];
            [strongSelf.delegate refundViewControllerDidFinish:^{
                strongSelf.refundResult = result;
                strongSelf.refundMessage = @"Refund successful";
                [strongSelf performSegueWithIdentifier:RefundResultViewSegue sender:self];
            }];
        }
    }];
    
    [self performSegueWithIdentifier:RefundProcessSegue sender:self];
    [self.refundTask start];
}

```


### Documentation
[API Reference](http://payleven.github.io/mPOS-SDK-iOS/AppleDoc/)

### mPOS SDK Sample App
The mPOS SDK includes a sample app that shows how the SDK can be integrated. Within this sample app is possible to choose a card reader, make payments and refund them. It contains a Signature View as well where the user can sign in case the payment requires a signature.
Note that the location is hardcoded and needs to be changed depending on the country the user is conducting the payment.
