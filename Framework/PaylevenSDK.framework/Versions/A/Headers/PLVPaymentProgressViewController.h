//
//  PLVPaymentProgressViewController.h
//  PaylevenSDK
//
//  Created by Johannes Rupieper on 04/03/16.
//  Copyright © 2016 payleven Holding GmbH. All rights reserved.
//

@import UIKit;
#import <PaylevenSDK/PLVPaymentTask.h>

/**
 @brief PLVPaymentProgressViewController enables you to implement optional animations to your user interface in your app. You can also customize the View’s appearance and provide a primary and/or secondary colour to align with your branding.
 */
@interface PLVPaymentProgressViewController : UIViewController

/**
 @brief init object of PLVPaymentProgressViewController using custom colors
 
 @param primaryColor    color of the payment device used in animations.
 
 @param secondaryColor  color of cards and PIN indicators used in animations.
 
 */
-(instancetype)initWithPrimaryColor:(UIColor*) primaryColor
                     secondaryColor:(UIColor*) secondaryColor;

/**
 @brief Call this method on PLVPaymentTaskDelegate's paymentTask:progressDidChange: and forward the received PLVPaymentProgressState
 
 @param progressState   PLVPaymentProgressState to animate current state.
 
 */
-(void) animateWithPaymentProgressState:(PLVPaymentProgressState)progressState;


@end
