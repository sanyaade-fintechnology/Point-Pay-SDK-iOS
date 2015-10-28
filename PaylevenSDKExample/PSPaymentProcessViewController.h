//
//  PSPaymentProcessViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
#import "PSPaymentProcessDelegate.h"
@class PSManager;

@interface PSPaymentProcessViewController : UIViewController<PSPaymentProcessDelegate>

@property (weak, nonatomic) PSManager *manager;

@end
