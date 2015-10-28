//
//  PSPaymentViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//
@import UIKit;
@class PSManager;
@class PSCoreDataManager;
@protocol PSManagerDelegate;

#import "PSLocationManagerDelegate.h"


@interface PSPaymentViewController : UIViewController

@property (nonatomic, weak) PSManager *manager;
@property (nonatomic, weak) id <PSManagerDelegate> managerDelegate;
@property (nonatomic, weak) PSCoreDataManager *coreDataManager;

@end
