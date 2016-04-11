//
//  PSPaymentProcessViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSPaymentProcessViewController.h"
#import "PSManager.h"

@interface PSPaymentProcessViewController()

@property (weak, nonatomic) IBOutlet UILabel *paylevenCopyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *paymentProgressLabel;

@end

@implementation PSPaymentProcessViewController

#pragma mark - Life cyle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureNavigationController];
    [self configureViewController];
}

#pragma mark - ConfigureView

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - ConfigureViewController

- (void)configureViewController {
    self.paylevenCopyrightLabel.text = [NSString stringWithFormat:@"payleven® %@", self.manager.currentYear.stringValue];
}

#pragma mark - PSPaymentProcessDelegate

- (void)paymentViewControllerDidFinish:(void (^ __nullable)())completion {
    [self dismissViewControllerAnimated:NO completion:completion];
}

- (void)presentSignatureViewControllerWithNavigatorController:(nonnull UINavigationController *)navController {
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)presentSignViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

-(void)paymentStateChangedToDesciption:(NSString *)description{
    self.paymentProgressLabel.text = description;
}

@end
