//
//  PSRefundProcessDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/26/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;

@protocol PSRefundProcessDelegate <NSObject>
/**
 * Called after the refund process finishes
 */
- (void)refundViewControllerDidFinish:(void (^)(void))completion;

@end
