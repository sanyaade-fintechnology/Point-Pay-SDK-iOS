//
//  PSRefundProcessViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/26/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
#import "PSRefundProcessDelegate.h"
@class PSManager;

@interface PSRefundProcessViewController : UIViewController<PSRefundProcessDelegate>

@property (weak, nonatomic) PSManager *manager;

@end
