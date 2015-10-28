//
//  PSPriceDecimal.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;

@interface PSPriceDecimal : NSObject

+ (NSDecimalNumber *)decimalForIntWithMantissa:(int)price;
+ (NSDecimalNumber *)decimalNumberWithString:(NSString *)string locale:(NSLocale *)locale;

@end
