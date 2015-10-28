//
//  PSPayment.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSPayment.h"

@implementation PSPayment

@dynamic amount;
@dynamic currency;
@dynamic date;
@dynamic index;
@dynamic merchantId;
@dynamic paymentId;
@dynamic paymentState;
@dynamic signature;
@dynamic refundedAmount;
@dynamic remainingAmount;

- (NSURL *)signatureURL {
    return [NSURL URLWithString:self.signature];
}

- (NSNumber *)totatRefundedAmount {
    if ([[NSDecimalNumber numberWithDouble:0.01] compare:self.remainingAmount] != NSOrderedDescending) {
        return [NSNumber numberWithDouble:(self.amount.doubleValue - self.remainingAmount.doubleValue)];
    }
    return nil;
}

@end
