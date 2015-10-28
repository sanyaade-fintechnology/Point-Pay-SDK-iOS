//
//  PSLogoutDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@class PSLogoutViewController;

@protocol PSLogoutDelegate <NSObject>

/**
 * Called after the user has succefully logged out of the system.
 */

- (void)logoutViewControllerDidFinish:(PSLogoutViewController *)logoutViewController;

/**
 * highlights errors arising from the logout process.
 */

- (void)logoutDidFailWithError:(NSError *)error;

@end