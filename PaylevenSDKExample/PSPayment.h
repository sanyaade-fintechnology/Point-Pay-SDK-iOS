//
//  PSPayment.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface PSPayment : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * currency;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSString * merchantId;
@property (nonatomic, retain) NSString * paymentId;
@property (nonatomic, retain) NSNumber * paymentState;
@property (nonatomic, retain) NSString * signature;
@property (nonatomic, retain) NSNumber * refundedAmount;
@property (nonatomic, retain) NSNumber * remainingAmount;
- (NSURL *)signatureURL;
- (NSNumber *)totatRefundedAmount;

@end
