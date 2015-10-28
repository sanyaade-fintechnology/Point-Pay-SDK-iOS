//
//  PSPaymentResultViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSPaymentResultViewController.h"
#import "PSReceiptViewController.h"
#import "PSManager.h"
#import "PSIdentifiers.h"
#import <PaylevenSDK/PLVPaymentTask.h>
#import <PaylevenSDK/PLVReceiptGenerator.h>
#import <PaylevenSDK/PLVPaymentResult.h>
#import <PaylevenSDK/PLVDevice.h>


@interface PSPaymentResultViewController ()

@property(nullable, nonatomic) IBOutlet UIImage *receiptImage;

@end

@implementation PSPaymentResultViewController

#pragma  mark - Life cycle

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
    [self configureViewForPaymentState:self.paymentTask.result.state];
}

#pragma mark  - ConfigureViewForPaymentState

- (void)configureViewForPaymentState:(PLVPaymentResultState)state {
    
    switch (state) {
        case PLVPaymentResultStateApproved:
            self.paymentResultImageView.image = [UIImage imageNamed:PaylevenSuccess];
            self.paymentResultLabel.text = @"Payment successful";
            self.paymentResultLabel.textColor = self.manager.paylevenSuccessGreenColor;
            break;
        case PLVPaymentResultStateCancelled:
            self.paymentResultImageView.image = [UIImage imageNamed:PaylevenCanceled];
            self.paymentResultLabel.text = @"Payment canceled";
            self.paymentResultLabel.textColor = self.manager.paylevenCancelRedColor;
            break;
        case PLVPaymentResultStateDeclined:
            self.paymentResultImageView.image = [UIImage imageNamed:PaylevenCanceled];
            self.paymentResultLabel.text = @"Payment declined";
            self.paymentResultLabel.textColor = self.manager.paylevenCancelRedColor;
            break;
        default:break;
    }
    
    [self.showReceiptButton setTintColor:self.manager.paylevenBlueTranslucentColor];
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ReceiptSegue]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        PSReceiptViewController *receiptViewController = (PSReceiptViewController *)navController.topViewController;
        receiptViewController.image = self.receiptImage;
    }
}

- (IBAction)showReceipt:(id)sender {
    CGFloat scale = [UIScreen mainScreen].scale;
    __weak typeof(self)weakSelf = self;
    [self.paymentTask.result.receiptGenerator generateReceiptWithWidth:(384.0 * scale)
                                           fontSize:(16.0 * scale)
                                        lineSpacing:(8.0 * scale)
                                            padding:(10.0 * scale)
                                  completionHandler:
     ^(CGImageRef receipt) {
         __strong typeof(weakSelf)strongSelf = weakSelf;
         strongSelf.receiptImage = [UIImage imageWithCGImage:receipt scale:scale orientation:UIImageOrientationUp];
         [strongSelf performSegueWithIdentifier:ReceiptSegue sender:strongSelf];
     }];
    
}

- (IBAction)close:(id)sender {
    [self performSegueWithIdentifier:UnwindPaymentResultViewSegue sender:self];
}

@end
