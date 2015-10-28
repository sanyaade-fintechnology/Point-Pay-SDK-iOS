//
//  PSLoginViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
#import "PSLoginDelegate.h"

@interface PSLoginViewController : UIViewController<PSLoginDelegate>

@property (nonatomic, weak) IBOutlet id <PSLoginDelegate> delegate;

@end
