//
//  PSLoginProcessViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager;
@protocol PSLoginDelegate;

@interface PSLoginProcessViewController : UIViewController

@property (weak, nonatomic) PSManager *manager;
@property (weak, nonatomic) id <PSLoginDelegate> delegate;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end
