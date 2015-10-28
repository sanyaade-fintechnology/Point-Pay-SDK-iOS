//
//  PSMissingPaymentsViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 9/16/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager;
#import "PSManagerDelegate.h"

@interface PSMissingPaymentsViewController : UIViewController

@property (nonatomic, weak) PSManager *manager;
@property (nonatomic, weak) id <PSManagerDelegate> managerDelegate;

@end
