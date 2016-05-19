//
//  PSPaymentProcessViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSPaymentProcessViewController.h"
#import "PSManager.h"
#import <PaylevenSDK/PLVPaymentProgressViewController.h>

@interface PSPaymentProcessViewController()

@property (weak, nonatomic) IBOutlet UILabel *paylevenCopyrightLabel;

@property (weak, nonatomic) IBOutlet UIView *paymentProgressContainerView;
@property (strong, nonatomic) PLVPaymentProgressViewController *paymentProgressViewController;
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
    
    //Clean up, just to be sure
    if(self.paymentProgressViewController){
        [self.paymentProgressViewController removeFromParentViewController];
        self.paymentProgressViewController = nil;
    }
    
    //Init
    self.paymentProgressViewController = [[PLVPaymentProgressViewController alloc]init];
    [self addChildViewController:self.paymentProgressViewController];
    
    //Set size
    self.paymentProgressViewController.view.frame = self.paymentProgressContainerView.bounds;
    
    //Add
    [self.paymentProgressContainerView addSubview:self.paymentProgressViewController.view];
    [self.paymentProgressViewController didMoveToParentViewController:self];


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

-(void)paymentProgressStateChangedToState:(PLVPaymentProgressState)progressState{
    if (self.paymentProgressViewController) {
        [self.paymentProgressViewController animateWithPaymentProgressState:progressState];
    }
    
    self.paymentProgressLabel.text = [self stringForState:progressState];
}

-(NSString*)stringForState:(PLVPaymentProgressState)progressState{
    
    switch (progressState) {
        case PLVPaymentProgressStateNone:
            return nil;
            break;
        case PLVPaymentProgressStateStarted:
            return @"Payment started";
            break;
        case PLVPaymentProgressStateRequestPresentCard:
            return @"Present card";
            break;
        case PLVPaymentProgressStateRequestInsertCard:
            return @"Insert card";
            break;
        case PLVPaymentProgressStateCardInserted:
            return @"Card inserted";
            break;
        case PLVPaymentProgressStateRequestEnterPin:
            return @"Enter PIN";
            break;
        case PLVPaymentProgressStatePinEntered:
            return @"PIN entered";
            break;
        case PLVPaymentProgressStateContactlessBeepFailed:
            return @"Tap failed";
            break;
        case PLVPaymentProgressStateContactlessBeepOk:
            return @"Tap ok";
            break;
        case PLVPaymentProgressStateRequestSwipeCard:
            return @"Swipe card";
            break;
        default:
            return nil;
            break;
    }
}

@end
