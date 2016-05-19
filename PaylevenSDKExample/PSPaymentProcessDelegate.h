//
//  PSPaymentProcessDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;
#import <PaylevenSDK/PLVPaymentTask.h>

@protocol PSPaymentProcessDelegate <NSObject>
/**
 * Called after the payment process finishes
 */
- (void)paymentViewControllerDidFinish:(void (^__nullable)())completion;
/**
 * Presents the signatureViewController
 */
- (void)presentSignatureViewControllerWithNavigatorController:(nonnull UINavigationController *)navController;

/**
 * Presents the signViewController
 */
- (void)presentSignViewController:(nonnull UIViewController *)viewController;

/**
 * Called when payment progress state changed
 */
- (void)paymentProgressStateChangedToState:(PLVPaymentProgressState) progressState;

@end
