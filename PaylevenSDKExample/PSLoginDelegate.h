//
//  PSLoginDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//
@import Foundation;
@class PSLoginViewController;

@protocol PSLoginDelegate <NSObject>

/**
 * Called after the user has succefully logged into the system.
 */

- (void)loginViewControllerDidFinish:(PSLoginViewController *)loginViewController;

/**
 * highlights errors arising from the login process.
 */

- (void)loginDidFailWithError:(NSError *)error;

@end
