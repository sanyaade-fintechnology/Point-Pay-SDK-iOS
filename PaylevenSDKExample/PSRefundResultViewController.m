//
//  PSRefundResultViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Obi on 9/23/15.
//  Copyright © 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSRefundResultViewController.h"
#import "PSReceiptViewController.h"
#import "PSManager.h"
#import "PSIdentifiers.h"
#import <PaylevenSDK/PLVReceiptGenerator.h>
#import <PaylevenSDK/PLVRefundResult.h>

@interface PSRefundResultViewController ()

@property(nullable, nonatomic) IBOutlet UIImage *receiptImage;

@end

@implementation PSRefundResultViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureViewForRefund:self.refundResult];
}

#pragma mark  - ConfigureViewForPaymentState

- (void)configureViewForRefund:(PLVRefundResult *)refund {
    if(refund){
        self.paymentResultImageView.image = [UIImage imageNamed:PaylevenSuccess];
        self.paymentResultLabel.textColor = self.manager.paylevenSuccessGreenColor;
    } else {
        self.paymentResultImageView.image = [UIImage imageNamed:PaylevenCanceled];
        self.paymentResultLabel.textColor = self.manager.paylevenCancelRedColor;
        self.showReceiptButton.userInteractionEnabled = NO;
        self.showReceiptButton.enabled = NO;
        [self.showReceiptButton setTitle:nil forState:UIControlStateDisabled];
        [self.showReceiptButton setTitle:nil forState:UIControlStateNormal];
    }
    
    self.paymentResultLabel.text = self.refundMessage;
}

- (IBAction)showReceipt:(id)sender {
    CGFloat scale = [UIScreen mainScreen].scale;
    __weak typeof(self)weakSelf = self;
    [self.refundResult.receiptGenerator generateReceiptWithWidth:(384.0 * scale)
                                                              fontSize:(16.0 * scale)
                                                           lineSpacing:(8.0 * scale)
                                                               padding:(20.0 * scale)
                                                     completionHandler:
     ^(CGImageRef receipt) {
         __strong typeof(weakSelf)strongSelf = weakSelf;
         strongSelf.receiptImage = [UIImage imageWithCGImage:receipt scale:scale orientation:UIImageOrientationUp];
         [strongSelf performSegueWithIdentifier:ReceiptSegue sender:strongSelf];
     }];
}

- (IBAction)close:(id)sender {
    [self performSegueWithIdentifier:UnwindRefundResultViewSegue sender:self];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ReceiptSegue]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        PSReceiptViewController *receiptViewController = (PSReceiptViewController *)navController.topViewController;
        receiptViewController.image = self.receiptImage;
    }
}

@end
