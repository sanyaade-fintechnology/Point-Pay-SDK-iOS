//
//  PSRefundViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSRefundViewController.h"
#import "PSRefundResultViewController.h"
#import "PSIdentifiers.h"
#import "PSLatestPaymentsViewController.h"
#import "PSLatestPaymentsTableViewDataSource.h"
#import "PSManager.h"
#import "PSManagerDelegate.h"
#import "PSFormatter.h"
#import "PSIdentifiers.h"
#import "PSPayment.h"
#import "PSPriceDecimal.h"
#import "PSCoreDataManager.h"
#import "PSRefundProcessDelegate.h"
#import "PSRefundProcessViewController.h"
#import <PaylevenSDK/PLVRefundTask.h>
#import <PaylevenSDK/PLVRefundRequest.h>
#import <PaylevenSDK/PLVPayleven.h>
#import <PaylevenSDK/PLVRefundResult.h>
#import <PaylevenSDK/PLVRefund.h>

@interface PSRefundViewController ()< UITextFieldDelegate,
                                      UIActionSheetDelegate >

@property (nonatomic, weak) IBOutlet UITextField *currentAmountTextField;
@property (nonatomic, weak) IBOutlet UIView *externalIdView;
@property (nonatomic, weak) IBOutlet UIButton *refreshBtn;
@property (nonatomic, weak) IBOutlet UIButton *btnZero;
@property (nonatomic, weak) IBOutlet UIButton *btnDoubleZero;
@property (nonatomic, weak) IBOutlet UIButton *btnOne;
@property (nonatomic, weak) IBOutlet UIButton *btnTwo;
@property (nonatomic, weak) IBOutlet UIButton *btnThree;
@property (nonatomic, weak) IBOutlet UIButton *btnFour;
@property (nonatomic, weak) IBOutlet UIButton *btnFive;
@property (nonatomic, weak) IBOutlet UIButton *btnSix;
@property (nonatomic, weak) IBOutlet UIButton *btnSeven;
@property (nonatomic, weak) IBOutlet UIButton *btnEight;
@property (nonatomic, weak) IBOutlet UIButton *btnNine;
@property (nonatomic, weak) IBOutlet UIButton *btnRefund;
@property (weak, nonatomic) IBOutlet UIImageView *eraseImage;
@property (nonnull, nonatomic) NSNumber *currentAmount;
@property (nonnull, nonatomic) PSFormatter *formatter;
@property (nonatomic) PLVRefundTask *refundTask;
@property (nonatomic) PLVRefundResult *refundResult;
@property (nonatomic) NSString *refundMessage;
@property (nonatomic) id <PSRefundProcessDelegate> delegate;

@end

@implementation PSRefundViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self){
        _currentAmount = [NSNumber numberWithInt:0];
    }
    return self;
}

- (PSFormatter *)formatter {
    if (_formatter){
        return _formatter;
    }
    
    _formatter = [[PSFormatter alloc]init];
    return _formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureNavigationController];
    if(self.payment){
        NSString *localeIdentifier = [self localIdentifierForCurrency:self.payment.currency];
        [self.managerDelegate updateCurrencyWithString:self.payment.currency];
        [self.managerDelegate updateLocalIdentifierWithString:localeIdentifier];
        [self configureViewWithPayment:self.payment];
        self.externalIdTextField.enabled = NO;
        self.externalIdTextField.userInteractionEnabled = NO;
    } else {
        self.externalIdTextField.enabled = YES;
        self.externalIdTextField.userInteractionEnabled = YES;
    }
    [self configureRefundButton];
}

#pragma mark - ConfigureView

- (void)configureView {
//    [self configureExternalIdView];
    [self configureRefundButton];
    self.currentAmountTextField.delegate = self;
    self.externalIdTextField.delegate = self;
    self.externalIdTextField.text = @"";
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.manager.localeIdentifier];
    self.eraseImage.layer.zPosition = -1;
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)configureViewWithPayment:(PSPayment *)payment {
    self.externalIdTextField.text = payment.paymentId;
    /**
     * Objective-c un precise conversion from a NSDecimalNumber Double to 
     * Int. Here you have to use a floatValue
     */
    self.currentAmount = [NSNumber numberWithInt:(payment.remainingAmount.floatValue*100)];
    [self.managerDelegate updateCurrencyWithString:payment.currency];
    [self.managerDelegate updateLocalIdentifierWithString:[self localIdentifierForCurrency:payment.currency]];
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:[self localIdentifierForCurrency:payment.currency]];
}

- (void)configureRefundButton {
    /**
     * Note the minimum refundable amount is 2 cents
     */
    if (self.currentAmount && [[NSDecimalNumber numberWithDouble:0.02] compare:[PSPriceDecimal decimalForIntWithMantissa:self.currentAmount.intValue]] != NSOrderedDescending && self.externalIdTextField.text.length > 0) {
        [self enableRefundButton];
    } else {
        [self disableRefundButton];
    }
}

- (void)enableRefundButton {
    self.btnRefund.enabled = YES;
    self.btnRefund.userInteractionEnabled = YES;
    self.btnRefund.backgroundColor = self.manager.paylevenBlueColor;
    [self.btnRefund addTarget:self action:@selector(methodTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btnRefund addTarget:self action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRefund addTarget:self action:@selector(methodTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)disableRefundButton {
    self.btnRefund.enabled = NO;
    self.btnRefund.userInteractionEnabled = NO;
    self.btnRefund.backgroundColor = self.manager.paylevenGrayColor;
}

- (void)methodTouchDown:(id)sender {
    self.btnRefund.alpha = 0.5;
}

- (void)methodTouchUpInside:(id)sender {
    self.btnRefund.alpha = 1.0;
}


- (void)methodTouchUpOutside:(id)sender {
    self.btnRefund.alpha = 1.0;
}

- (void)configureExternalIdView {
    CALayer *topBorderLayer = [CALayer layer];
    topBorderLayer.frame = CGRectMake(0.00, 10.00, self.externalIdView.frame.size.width, 0.60);
    topBorderLayer.backgroundColor = self.manager.paylevenGrayColor.CGColor;
    CALayer *bottomBorderLayer = [CALayer layer];
    bottomBorderLayer.frame = CGRectMake(0.00, self.externalIdView.frame.size.height - 10.00, self.externalIdView.frame.size.width, 0.60);
    bottomBorderLayer.backgroundColor = self.manager.paylevenGrayColor.CGColor;
    [self.externalIdView.layer addSublayer:topBorderLayer];
    [self.externalIdView.layer addSublayer:bottomBorderLayer];
}

- (void)updateViewController {
    self.payment = nil;
    self.refundResult = nil;
    self.refundTask = nil;
    self.refundMessage = nil;
    self.externalIdTextField.enabled = YES;
    self.externalIdTextField.userInteractionEnabled = YES;
    self.externalIdTextField.text = @"";
    self.currentAmount = [NSNumber numberWithInt:0];
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.manager.localeIdentifier];
}

#pragma mark - Error message

- (void)presentAlertViewWithMessage:(NSString *)aMessage title:(NSString *)title {
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:aMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:aMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)formatCurrencyWithAmount:(NSNumber *)amount localeIdentifier:(NSString *)localIdentifier {
    self.formatter.currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:localIdentifier];
    NSDecimalNumber *decimal = [PSPriceDecimal decimalForIntWithMantissa:self.currentAmount.intValue];
    self.currentAmountTextField.text = @"";
    self.currentAmountTextField.text = [self.formatter.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:decimal.doubleValue]];
}

- (NSString *)localIdentifierForCurrency:(NSString *)currency {
    if ([currency isEqualToString:@"EUR"]) {
        return @"de_DE";
    } else if ([currency isEqualToString:@"GBP"]) {
        return @"en_GB";
    } else if ([currency isEqualToString:@"PLN"]) {
        return @"pl_PL";
    }
    return nil;
}

- (IBAction)latestPayments:(id)sender {
    [self performSegueWithIdentifier:LatestPaymentSegue sender:self];
}

- (IBAction)enterDigit:(id)sender {
    UIButton *button = (UIButton *)sender;
    int intValue = button.titleLabel.text.intValue;
    if ((self.currentAmount.intValue * 10 + intValue) < MAX_AMOUNT) {
        if (button == self.btnDoubleZero) {
            self.currentAmount = [NSNumber numberWithInt:self.currentAmount.intValue * 100 + intValue];
        } else {
            self.currentAmount = [NSNumber numberWithInt:self.currentAmount.intValue * 10 + intValue];
        }
        [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.manager.localeIdentifier];
    } else {
        [self presentAlertViewWithMessage:@"Amount out of range" title:@"Refund error"];
    }
    [self configureRefundButton];
}

- (IBAction)erase:(id)sender {
    if (self.currentAmount.intValue != 0) {
        self.currentAmount = [NSNumber numberWithInt:self.currentAmount.intValue/10];
        [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:self.manager.localeIdentifier];
    }
    [self configureRefundButton];
    self.eraseImage.alpha = 1.0;
}

- (IBAction)buttonPressed:(id)sender {
    self.eraseImage.alpha = 0.5;
}

- (IBAction)buttonReleased:(id)sender {
    self.eraseImage.alpha = 1.0;
}

#pragma mark - selectCurrency

- (IBAction)selectCurrency:(id)sender {
    UIBarButtonItem *currencyBarButtonItem = (UIBarButtonItem *)sender;
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"Select Currency" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"€ EUR", @"£ GBP", @"zł PLN", nil];
    [actionSheet showFromBarButtonItem:currencyBarButtonItem animated:YES];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    /**
     * API error in Objc they start from Zero and in
     * Swift they start from 1. so what out for changes
     */
    NSString *localeIdentifier;
    NSString *currency;
    
    switch (buttonIndex) {
        case 0:
            localeIdentifier = @"de_DE";
            currency = @"EUR";
            break;
        case 1:
            localeIdentifier = @"en_GB";
            currency = @"GBP";
            break;
        case 2:
            localeIdentifier = @"pl_PL";
            currency = @"PLN";
            break;
        default:
            localeIdentifier = self.manager.localeIdentifier;
            break;
    }
    
    if(self.payment.currency && [self.payment.currency isEqualToString:currency]){
        [self.managerDelegate updateLocalIdentifierWithString:localeIdentifier];
        [self.managerDelegate updateCurrencyWithString:currency];
        [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:localeIdentifier];
    } else if (currency && self.payment.currency && ![self.payment.currency isEqualToString:currency]){
        [self presentAlertViewWithMessage:@"Payment cannot be refunded with the selected curency" title:@"Currency error"];
    } else {
        [self.managerDelegate updateLocalIdentifierWithString:localeIdentifier];
        [self.managerDelegate updateCurrencyWithString:currency];
        [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:localeIdentifier];
    }
    [self configureRefundButton];
    
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
                button.titleLabel.textColor = self.manager.paylevenBlueTranslucentColor;
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

#pragma mark - Refund Task

- (IBAction)refund:(id)sender {
    [self performRefundTask];
}

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

- (void)updatePayment:(PLVRefund *)refund merchantId:(NSString *)merchantId {
    [self.coreDataManager updatePaymentWithRefund:refund merchantId:merchantId completion:^(BOOL result) {
        if(!result){
            NSLog(@"handle errors");
        }
    }];
}

- (void)deletePayment:(NSString *)paymentId merchanctId:(NSString *)merchantId {
    [self.coreDataManager deletePaymentWithIdentifier:paymentId merchantId:merchantId completion:^(BOOL result) {
        if(!result){
            NSLog(@"handle errors");
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string  isEqual:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
    [self configureRefundButton];
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

- (void)observeTextField:(UITextField *)textField {
    __weak typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:NSOperationQueuePriorityNormal usingBlock: ^(NSNotification *note) {
        UITextField *notificationTextField = note.object;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (notificationTextField.text.length <= 0) {
            [strongSelf disableRefundButton];
        }
    }];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:LatestPaymentSegue]){
        PSLatestPaymentsViewController *latestPaymentViewController = (PSLatestPaymentsViewController *)segue.destinationViewController;
        latestPaymentViewController.manager = self.manager;
        latestPaymentViewController.coreDataManager = self.coreDataManager;
        latestPaymentViewController.dataSource.selectedPayment = self.payment;
    } else if ([segue.identifier isEqualToString:RefundProcessSegue]) {
        PSRefundProcessViewController *refundProcessViewController = (PSRefundProcessViewController *)segue.destinationViewController;
        refundProcessViewController.manager = self.manager;
        self.delegate = refundProcessViewController;
    } else if([segue.identifier isEqualToString:RefundResultViewSegue]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        PSRefundResultViewController *refundResultViewController = (PSRefundResultViewController *)navController.topViewController;
        refundResultViewController.manager = self.manager;
        refundResultViewController.refundResult = self.refundResult;
        refundResultViewController.refundMessage = self.refundMessage;
    }
}

#pragma mark - UnwindSegue

- (IBAction)unwindFromLatestPaymentTableViewController:(UIStoryboardSegue *)sender {
    PSLatestPaymentsViewController *latestPaymentTableViewController = (PSLatestPaymentsViewController *)sender.sourceViewController;
    self.payment = latestPaymentTableViewController.dataSource.selectedPayment;
    self.externalIdTextField.text = self.payment.paymentId;
    self.currentAmount = [NSNumber numberWithInt:(self.payment.amount.doubleValue*100)];
    [self.managerDelegate updateCurrencyWithString:self.payment.currency];
    [self.managerDelegate updateLocalIdentifierWithString:[self localIdentifierForCurrency:self.payment.currency]];
    [self formatCurrencyWithAmount:self.currentAmount localeIdentifier:[self localIdentifierForCurrency:self.payment.currency]];
    [latestPaymentTableViewController dismissViewControllerAnimated:YES completion:nil];
    [self configureRefundButton];
}

- (IBAction)unwindFromRefundResultViewController:(UIStoryboardSegue *)sender {
    PSRefundResultViewController *refundResultViewController = (PSRefundResultViewController *)sender.sourceViewController;
    [refundResultViewController dismissViewControllerAnimated:YES completion:nil];
    if(self.refundResult){
        [self updateViewController];
    }
}


@end
