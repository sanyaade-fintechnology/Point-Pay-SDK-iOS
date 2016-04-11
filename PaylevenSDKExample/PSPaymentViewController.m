//
//  PSPaymentViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSPaymentViewController.h"
#import "PSSignViewController.h"
#import "PSPaymentResultViewController.h"
#import "PSPaymentProcessDelegate.h"
#import "PSTerminalTableViewController.h"
#import "PSPaymentProcessViewController.h"
#import "PSPaymentProcessDelegate.h"
#import "PSLocationManagerDelegate.h"
#import "PSCoreDataManagerDelegate.h"
#import "PSLocationManager.h"
#import "PSCoreDataManager.h"
#import "PSPriceDecimal.h"
#import "PSIdentifiers.h"
#import "PSFormatter.h"
#import "PSManager.h"
#import <PaylevenSDK/PLVDevice.h>
#import <PaylevenSDK/PLVPaymentTask.h>
#import <PaylevenSDK/PLVPaymentRequest.h>
#import <PaylevenSDK/PLVPaymentResult.h>

@import CoreBluetooth;
@import CoreLocation;

@interface PSPaymentViewController ()<  CBCentralManagerDelegate,
                                        UIActionSheetDelegate,
                                        UITextFieldDelegate,
                                        PLVPaymentTaskDelegate,
                                        PSLocationManagerDelegate >

@property (weak, nonatomic) IBOutlet UITextField *currentAmountTextField;
@property (weak, nonatomic) IBOutlet UIView *externalIdView;
@property (weak, nonatomic) IBOutlet UITextField *externalIdTextField;
@property (weak, nonatomic) IBOutlet UIButton *refreshBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnZero;
@property (weak, nonatomic) IBOutlet UIButton *btnDoubleZero;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (weak, nonatomic) IBOutlet UIButton *btnFour;
@property (weak, nonatomic) IBOutlet UIButton *btnFive;
@property (weak, nonatomic) IBOutlet UIButton *btnSix;
@property (weak, nonatomic) IBOutlet UIButton *btnSeven;
@property (weak, nonatomic) IBOutlet UIButton *btnEight;
@property (weak, nonatomic) IBOutlet UIButton *btnNine;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UIImageView *eraseImage;
@property (nonnull, readonly, nonatomic) PSFormatter *formatter;
@property (nonnull, nonatomic) NSNumber *currentAmount;
@property (nullable, nonatomic) PLVPaymentTask *paymentTask;
@property (weak) id <PSPaymentProcessDelegate> paymentProcessDelegate;
@property (weak) id <PSSignatureDelegate> signatureDelegate;
@property (nonnull, nonatomic) NSString *localeIdentifier;
@property (nonnull, nonatomic) NSString *currency;
@property (nonnull, nonatomic) PSLocationManager *locationManager;
@property (nonnull, nonatomic) CBCentralManager *bluetoothManager;
@property (nonnull, nonatomic) NSDecimalNumber *maximumAmount;
@property (nonatomic) CBCentralManagerState bluetoothState;

@end

@implementation PSPaymentViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentAmount = [NSNumber numberWithInt:0];
        _locationManager = [[PSLocationManager alloc]initWithDelegate:self];
        _bluetoothManager = [[CBCentralManager alloc]initWithDelegate:self
                                                                queue:self.manager.concurrentQueue
                                                              options:@{
                                                                        CBCentralManagerOptionShowPowerAlertKey:@YES
                                                                        }];
        _bluetoothState = CBCentralManagerStateUnknown;
        _maximumAmount = [NSDecimalNumber decimalNumberWithMantissa:MAX_AMOUNT exponent:-2 isNegative:NO];
    }
    return self;
}

- (PSFormatter *)formatter {
    return self.manager.formatter;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self.locationManager requestCurrentLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.localeIdentifier = self.manager.localeIdentifier;
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.localeIdentifier];
    self.currency = self.manager.currency;
    [self configureNavigationController];
}

#pragma mark - ConfigureView

- (void)configureView {
    [self configurePayButton];
    self.currentAmountTextField.delegate = self;
    self.externalIdTextField.delegate = self;
    self.externalIdTextField.text = @"";
    self.eraseImage.layer.zPosition = -1;
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)configurePayButton {
    if (self.currentAmount && [[NSDecimalNumber numberWithDouble:1.00] compare:[PSPriceDecimal decimalForIntWithMantissa:self.currentAmount.intValue]] != NSOrderedDescending && self.externalIdTextField.text.length > 0) {
        [self enablePayButton];
    } else {
        [self disablePayButton];
    }
}

- (void)enablePayButton {
    self.btnPay.enabled = YES;
    self.btnPay.userInteractionEnabled = YES;
    self.btnPay.backgroundColor = self.manager.paylevenBlueColor;
    [self.btnPay addTarget:self action:@selector(methodTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btnPay addTarget:self action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnPay addTarget:self action:@selector(methodTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)disablePayButton {
    self.btnPay.enabled = NO;
    self.btnPay.userInteractionEnabled = NO;
    self.btnPay.backgroundColor = self.manager.paylevenGrayColor;
}

- (void)methodTouchDown:(id)sender {
    self.btnPay.alpha = 0.5;
}

- (void)methodTouchUpInside:(id)sender {
    self.btnPay.alpha = 1.0;
}

- (void)methodTouchUpOutside:(id)sender {
    self.btnPay.alpha = 1.0;
}

#pragma mark - Format current amount

- (void)formatCurrencyWithAmount:(NSNumber *)amount localeIdentifier:(NSString *)localIdentifier {
    self.formatter.currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:self.localeIdentifier];
    NSDecimalNumber *decimal = [PSPriceDecimal decimalForIntWithMantissa:self.currentAmount.intValue];
    self.currentAmountTextField.text = @"";
    self.currentAmountTextField.text = [self.formatter.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:decimal.doubleValue]];
}

#pragma mark - selectCurrency

- (IBAction)selectCurrency:(id)sender {
    UIBarButtonItem *currencyBarButtonItem = (UIBarButtonItem *)sender;
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Currency" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"€ EUR", @"£ GBP", @"zł PLN", nil];
    [actionSheet showFromBarButtonItem:currencyBarButtonItem animated:YES];
}

#pragma mark - RefreshExternalId

- (IBAction)refreshExternalId:(id)sender {
    self.externalIdTextField.text = self.manager.randomString;
    [self configurePayButton];
}

#pragma mark - Erase

- (IBAction)erase:(id)sender {
    if (self.currentAmount.intValue != 0) {
        self.currentAmount = [NSNumber numberWithInt:self.currentAmount.intValue/10];
        [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.localeIdentifier];
    }
    [self configurePayButton];
    self.eraseImage.alpha = 1.0;
}

- (IBAction)buttonPressed:(id)sender {
    self.eraseImage.alpha = 0.5;
    
    ((UIButton*)sender).alpha = 0.5;
}

- (IBAction)buttonReleased:(id)sender {
    self.eraseImage.alpha = 1.0;
}

#pragma mark - EnterDigit

- (IBAction)enterDigit:(id)sender {
    [self.externalIdTextField resignFirstResponder];
    
    UIButton *button = (UIButton *)sender;
    int intValue = button.titleLabel.text.intValue;
    
    int amount = (self.currentAmount.intValue * 10 + intValue);
    NSDecimalNumber *decimalAmount = [NSDecimalNumber decimalNumberWithMantissa:amount exponent:-2 isNegative:NO];
    
    if ([decimalAmount compare:self.maximumAmount] != NSOrderedDescending){
        if (button == self.btnDoubleZero) {
            self.currentAmount = [NSNumber numberWithInt:self.currentAmount.intValue * 100 + intValue];
        } else {
           self.currentAmount = [NSNumber numberWithInt:self.currentAmount.intValue * 10 + intValue];
        }
        [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.localeIdentifier];
    } else {
        [self presentAlertViewWithErrorMessage:@"Amount out of range" title:@"Payment error"];
    }
    [self configurePayButton];
}

#pragma mark - Pay

- (IBAction)pay:(id)sender {
    
    if (self.manager.selectedDevice.ready) {
        [self performPaymentTask];
    } else {
        switch (self.bluetoothState) {
            case CBCentralManagerStatePoweredOff :
                [self presentAlertViewWithErrorMessage:@"Please turn on the bluetooth" title:@"Bluetooth error"];
                break;
            case CBCentralManagerStatePoweredOn:
                [self presentTerminalViewController];
                break;
            default:break;
        }
    }
}

- (void)presentTerminalViewController{
    if  (self.manager.payleven.devices.count > 0) {
        [self performSegueWithIdentifier:PaymentTerminalSegue sender:self];
    } else {
        [self performSegueWithIdentifier:PaymentTerminalMissingSegue sender:self];
    }
}

- (void)performPaymentTask {
    [self performSegueWithIdentifier:PaymentProcessSegue sender:self];
    self.formatter.currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:self.localeIdentifier];
    NSDecimalNumber *decimalAmount = [PSPriceDecimal decimalForIntWithMantissa:self.currentAmount.intValue];
    NSString *externalID = self.externalIdTextField.text;
    CLLocationCoordinate2D coordinate = self.manager.coordinate;
    PLVDevice *device = self.manager.selectedDevice;
    PLVPaymentRequest *paymentRequest = [[PLVPaymentRequest alloc]initWithIdentifier:externalID amount:decimalAmount currency:self.currency coordinate:coordinate];
    self.paymentTask = [self.manager.payleven paymentTaskWithRequest:paymentRequest device:device delegate:self];
    if (self.paymentTask) {
        [self.paymentTask start];
    } else {
        [self presentAlertViewWithErrorMessage:@"Error creating payment task.\n Make sure you’re logged in and the payment device is ready" title:@"Payment error"];
    }
}

#pragma mark - Error message

- (void)presentAlertViewWithErrorMessage:(NSString *)aMessage title:(NSString *)title {
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:aMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:aMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertViewController addAction:okAction];

        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:PaymentProcessSegue]) {
        PSPaymentProcessViewController *paymentProcessViewController = (PSPaymentProcessViewController *)segue.destinationViewController;
        paymentProcessViewController.manager = self.manager;
        self.paymentProcessDelegate = paymentProcessViewController;
    } else if ([segue.identifier isEqualToString:PaymentTerminalSegue]){
        PSTerminalTableViewController *terminalTableViewController = (PSTerminalTableViewController *)segue.destinationViewController;
        terminalTableViewController.manager = self.manager;
        terminalTableViewController.managerDelegate = self.managerDelegate;
    }else if ([segue.identifier isEqualToString:PaymentResultViewSegue]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        PSPaymentResultViewController *paymentResultViewController = (PSPaymentResultViewController *)navController.topViewController;
        paymentResultViewController.paymentTask = self.paymentTask;
        paymentResultViewController.manager = self.manager;
    }
}

- (IBAction)unwindFromPaymentResultViewController:(UIStoryboardSegue *)sender {
    PSPaymentResultViewController *paymentResultViewController = (PSPaymentResultViewController *)sender.sourceViewController;
    [paymentResultViewController dismissViewControllerAnimated:NO completion:nil];
    self.paymentTask = nil;
    self.currentAmount = [NSNumber numberWithInt:0];
    self.externalIdTextField.text = nil;
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.localeIdentifier];
    [self configurePayButton];
}

#pragma mark - UIActionSheetDelegate

/**
 @brief API error in Objc they start from Zero and in Swift they start from 1. so what out for changes
 */
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            self.localeIdentifier = @"de_DE";
            self.currency = @"EUR";
            break;
        case 1:
            self.localeIdentifier = @"en_GB";
            self.currency = @"GBP";
            break;
        case 2:
            self.localeIdentifier = @"pl_PL";
            self.currency = @"PLN";
            break;
        default:
            break;
    }
    
    [self.managerDelegate updateLocalIdentifierWithString:self.localeIdentifier];
    [self.managerDelegate updateCurrencyWithString:self.currency];
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.localeIdentifier];
}

/**
 @brief Officially you cannot change the actionSheet but this is a Proxy leak which is not going to work always.
 updateTitleColorForActionSheet method is disabled until futher communication.
 */
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    
    //[self updateTitleColorForActionSheet:actionSheet];
}

- (void)updateTitleColorForActionSheet:(UIActionSheet *)actionSheet {
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        for (UIView *subview in actionSheet.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                [button setTitleColor:self.manager.paylevenBlueTranslucentColor forState:UIControlStateNormal];
                [button setTitleColor:self.manager.paylevenBlueTranslucentColor forState:UIControlStateSelected];
                [button setTitleColor:self.manager.paylevenBlueTranslucentColor forState:UIControlStateHighlighted];
            }
        }
    } else {
        SEL selector = NSSelectorFromString(@"_alertController");
        if ([actionSheet respondsToSelector:selector]){
            UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
            if ([alertController isKindOfClass:[UIAlertController class]]){
                alertController.view.tintColor = self.manager.paylevenBlueTranslucentColor;
                
            }
        }
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.bluetoothState = central.state;
    });
}

#pragma mark - PSLocationManagerDelegate

- (void)locationDidChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus {
    NSString *errorMessage;
    switch (authorizationStatus) {
        case kCLAuthorizationStatusNotDetermined:
            errorMessage = @"Can't determine authorization status";
            break;
        case kCLAuthorizationStatusRestricted:
            errorMessage = @"Authorization restricted";
            break;
        case kCLAuthorizationStatusDenied:
            errorMessage = @"Authorization denied";
            break;
        default:break;
    }
    
    if (errorMessage) {
        [self presentAlertViewWithErrorMessage:errorMessage title:@"Location error"];
    }
}

- (void)locationDidFailFindingCurrentLocalityWithError:(NSError *)error {
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"Location error"];
}

- (void)locationDidFindCurrentCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.managerDelegate updateCoordinate:coordinate];
}

#pragma mark - PLVPaymentTaskDelegate

- (void)paymentTask:(PLVPaymentTask *)paymentTask needsSignatureWithCompletionHandler:(void (^)(BOOL, CGImageRef))completionHandler {
    PSSignViewController *signViewController = [self.storyboard instantiateViewControllerWithIdentifier:SignViewController];
    self.signatureDelegate = signViewController;
    signViewController.manager = self.manager;
    signViewController.amountString = [NSString stringWithFormat:@"Amount %@", self.currentAmountTextField.text];
    __weak typeof(self)weakSelf = self;
    signViewController.completionBlock = ^(BOOL confirm, CGImageRef caputuredSignatureImage){
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (caputuredSignatureImage && confirm){
            completionHandler(confirm, caputuredSignatureImage);
            [strongSelf.signatureDelegate dismissViewController];
        } else {
            [strongSelf.paymentTask cancel];
            [strongSelf.paymentProcessDelegate paymentViewControllerDidFinish:^{
                [strongSelf performSegueWithIdentifier:PaymentResultViewSegue sender:strongSelf];
            }];
        }
    };
    [self.paymentProcessDelegate presentSignViewController:signViewController];
}

- (void)paymentTask:(PLVPaymentTask *)paymentTask didFailWithError:(NSError *)error {
    __weak typeof(self)weakSelf = self;
    [self.paymentProcessDelegate paymentViewControllerDidFinish:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (paymentTask.result){
            [strongSelf performSegueWithIdentifier:PaymentResultViewSegue sender:strongSelf];
        } else {
            [strongSelf presentAlertViewWithErrorMessage:error.localizedDescription title:@"Payment error"];
        }
    }];
}

- (void)paymentTaskDidFinish:(PLVPaymentTask *)paymentTask {
    if (paymentTask.result.state == PLVPaymentResultStateApproved) {
        [self registerPaymentWithTask:paymentTask];
    }
    
    if(self.signatureDelegate){
        [self.signatureDelegate dismissViewController];
    }

    [self.paymentProcessDelegate paymentViewControllerDidFinish:nil];
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf performSegueWithIdentifier:PaymentResultViewSegue sender:strongSelf];
    });
}

- (void)registerPaymentWithTask:(PLVPaymentTask *)paymentTask {
    __weak typeof(self)weakSelf = self;
    [self.coreDataManager savePaymentResult:paymentTask.result merchantId:self.manager.merchantId completion:^(BOOL result) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!result) {
            [strongSelf presentAlertViewWithErrorMessage:@"Error saving payment" title:@"Systrm error"];
        }
    }];
}

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
    
    [self.paymentProcessDelegate paymentStateChangedToDesciption:progressStateDescriptor];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string  isEqual:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self observeTextField:textField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [textField resignFirstResponder];
}

#pragma mark - observeTextField

- (void)observeTextField:(UITextField *)textField
{
    __weak typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:NSOperationQueuePriorityNormal usingBlock: ^(NSNotification *note) {
        UITextField *notificationTextField = note.object;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (notificationTextField.text.length <= 0) {
            [strongSelf disablePayButton];
        } else {
            [strongSelf enablePayButton];
        }
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.externalIdTextField resignFirstResponder];
}

@end
