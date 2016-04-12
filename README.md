# payleven mPOS SDK

[![CocoaPods](https://img.shields.io/badge/Licence-MIT-brightgreen.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Platform-iOS-yellow.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Requires-iOS%207+-blue.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/github/tag/Payleven/mPOS-SDK-iOS.svg?style=flat-square)]()
[![CocoaPods](https://img.shields.io/badge/Made%20in-Berlin-red.svg?style=flat-square)]()

This project provides an iOS API to communicate with the payleven Classic (Chip & PIN) and Plus (NFC) card reader to accept debit and credit card payments. Learn more on one of payleven's country [websites](https://payleven.com/).
The payleven mPOS SDK also provides an API to process refund payments (from version 1.1.0). Additionally, the SDK issues a receipt image of sale and refund payments that contains the bare minimum of receipt details. Please remember to extend the image with the merchants name, address and a respective receipt ID. If you wish to create your own receipt by using a set of raw payment data, please contact <a href="mailto:developer@payleven.com">developer@payleven.com</a>.

The SDK is a static library, which supports other platforms like Xamarin and is fully compatible with the i386, x86_64, armv7, arm64 architectures.

### Prerequisites
1. Register on one of payleven's country [websites](https://payleven.com/) to get a merchant account and a card reader.
2. Request an API key by registering for the mPOS SDK on the [payleven developer page](https://service.payleven.com/uk/developer).
3. System requirements: iOS 7 or later for both, the mPOS SDK and the mPOS SDK Sample App
4. A payleven card reader, Classic or Plus

### Table of Contents
* [Installation](#installation)
    * [CocoaPods](#cocoapods)
    * [Manual Set-Up](#manual-set-up)
    * [MFi Program Authorization](#mfi-program-authorization)
    * [Bluetooth pairing](#bluetooth-pairing)
* [Getting started](#getting-started)
  * [Login](#login)
  * [Select a device](#select-a-device)
  * [Prepare device for payment](#prepare-device-for-payment)
* [Payment](#payment)
  * [Start payment](#start-payment)
  * [Handle payment](#handle-payment)
  * [Finish payment](#finish-payment)
* [Refund](#refund)
  * [Start refund](#start-refund)
  * [Handle refunds](#handle-refund)
* [Documentation](#documentation)
* [mPOS SDK Sample App](#mpos-sdk-sample-app)

### Installation

##### CocoaPods

	pod 'Payleven-mPos', '~> 1.1.0'

##### Manual Set Up

1. Drag the following files into your Xcode project.

        PaylevenSDK.framework
        AdyenToolkit.framework
        AdyenToolkit.bundle

2. Open the *Build Phases* of your target and add the following frameworks to the *Link Binary With Libraries* section:

        CoreData.framework  
        CoreLocation.framework
        ExternalAccessory.framework
        SystemConfiguration.framework
        libsqlite3.0.dylib
		AVFoundation.framework
		AudioToolbox.framework

3. Open the *Build Settings* of your target and add `-ObjC` flag to Other Linker Flags

4. Import PaylevenSDK into your files:

        #import <PaylevenSDK/PaylevenSDK.h>

5. Open the *Info.plist* and add the following entries:

  * `CFBundleDisplayName` with the display name for your app.
  * `UISupportedExternalAccessoryProtocols` with an array of just one value `com.adyen.bt1`.
  * For iOS 8+: `NSLocationWhenInUseUsageDescription` or `NSLocationAlwaysUsageDescription`, 
	for iOS 7: `NSLocationUsageDescription` with the location usage description message for the users.
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
Before submitting your iOS app to iTunes, Apple requires registration of all iOS apps that communicate with approved MFi devices. This registration process officially associates your app with the payleven card reader and can be performed by payleven. Once your app (bundle ID) has been registered, future app versions will not require additional registrations. Please contact developer@payleven.com for help with your submission.

##### Bluetooth pairing
Before proceeding with the integration and testing, make sure you have paired the card reader in the bluetooth settings on your iOS device.
 1. Make sure the device is charged and turned on.
 2. Press '0' key on the card reader for 5 sec and make sure the card reader has entered the pairing mode (there will be a corresponding sign on the screen).
 3. Go to the bluetooth settings of your iOS device and turn on bluetooth.
 4. Select the "discovered" payleven card reader and follow the instructions on both devices to finish the pairing process.

### Getting started    
#### Login
To fetch connected devices, start or refund a payment you must be logged into payleven SDK. 
Use the API key received from payleven, together with your payleven merchant account (email address & password) to authenticate your app. 
Hint: Check out our Sample Demo to see how you can easily observe the Login State using [Key-Value Observing](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html).

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
#### Select a device
Once a `PLVPayleven` instance is created you need to select the card reader for future payments. Please remember to select a device every time you start a new session.

 ```objective-c
 //You probably want to visualize the devices in a UITableView
 NSArray * pairedDevices = self.manager.payleven.devices;
 
 //Get the selected device from the list
  PLVDevice *device = self.sortedDevices[indexPath.row];
  NSString * deviceName = device.name;
 ```

#### Prepare device for payment

After a device is selected it needs to be prepared to accept payments. We will run all required preparations and security checks for you. All you have to do is outlined below. Also, before triggering a new payment you should always check that your PLVDevice object returns ready == true.

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
### Payment    
#### Start payment
Initialize the actual payment request. For security purposes, you must provide the user's current location in the PaymentReuest. The identifier parameter allows you to reference this particular payment for a potential refund in the future. We strongly encourage you to save this value in your Backend. 

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
Implement PLVPaymentTaskDelegate's methods to respond to payment events such as the request of a payer's signature.

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

#### Finish payment

The delegate's paymentTaskDidFinish: and paymentTask:didFailWithError: are called when the payment task finishes. You shall implement both and present the outcome of the payment to the user.

 ```objective-c
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


### Refund
You can refund the payment partially meaning you do not have to refund the full amount. First, you create a PLVRefundRequest. 
It is used to create or generate the request for refunds that will later be executed by the PLVRefundTask instance. 
For a refund you need

1. Identifier 			//String to uniquely specify the refund
2. Amount 				//NSDecimalNumber indicating the amount to be refunded, cannot be higher than original payment's amount
3. PaymentIdentifier 	//String specifying the original sale payment's ID that is supposed to be refunded
4. Currency 			//3 letter ISO character (e.g EUR) that is identical with the original sale payment's currency  


```objective-c

PLVRefundRequest *request = [[PLVRefundRequest alloc]initWithIdentifier:refundIdentifier 
                                                      paymentIdentifier:originalPaymentId
                                                                 amount:amount
                                                               currency:@"EUR"
                                                      refundDescription:@"Customer request"];
```


#### Start refund

```objective-c
- (PLVRefundTask *)refundTaskWithRequest:(PLVRefundRequest *)request
                       completionHandler:(void (^)(PLVRefundResult *result, NSError *error))completionHandler;
```

#### Handle refund

Once you have initialised PLVRefundRequest sucessfully you can trigger the refund as outlined below.

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
           //Inform user about error
        } else {
           //Inform user about success
        }
    }];
     [self.refundTask start];
}

```


### Documentation
[API Reference](http://payleven.github.io/mPOS-SDK-iOS/AppleDoc/)

### mPOS SDK Sample App
The mPOS SDK includes a sample app illustrating how the SDK can be integrated. Within this sample app it is possible to select a card reader, make payments and refund them. It also contains a Signature View, where the user can sign in case the payment requires a signature.
Please note that the location is hardcoded and needs to be changed depending on the country that the user is conducting the payment.
