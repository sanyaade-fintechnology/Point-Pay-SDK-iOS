//
//  PSSignatureDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;

@protocol PSSignatureDelegate <NSObject>
/**
 * Enables the cancel BarButtonItem.
 */
- (void)enableCancelBarButtonItemWithBool:(BOOL)fingerDidMove;
/**
 * Saves the captured image.
 */
- (void)saveCaputuredSignatureImage:(CGImageRef)image;
/**
 * Clears the captured image.
 */
- (void)clearCapturedSignatureImage;
/**
 * Presents the PaymentError.
 */
- (void)presentAlertViewWithError:(NSError *)error;
/**
 * Dismiss the viewController
 */
- (void)dismissViewController;
/**
 * Called after the user has succefully signed
 */
- (void)didFinishSigning;

@end