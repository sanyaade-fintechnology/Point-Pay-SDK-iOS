//
//  PSPriceDecimal.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSPriceDecimal.h"

@implementation PSPriceDecimal

+ (NSDecimalNumber *)decimalForIntWithMantissa:(int)price {
    return  [NSDecimalNumber decimalNumberWithMantissa:price exponent:-2 isNegative:NO];
}

+(NSDecimalNumber *)decimalNumberWithString:(NSString *)string locale:(NSLocale *)locale {
    return [NSDecimalNumber decimalNumberWithString:string locale:locale];
}

@end
