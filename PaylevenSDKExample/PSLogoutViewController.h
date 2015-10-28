//
//  PSLogoutViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager;
@protocol PSLogoutDelegate;

@interface PSLogoutViewController : UIViewController

@property (weak, nonatomic) PSManager *manager;
@property (weak, nonatomic) id <PSLogoutDelegate> delegate;

@end
