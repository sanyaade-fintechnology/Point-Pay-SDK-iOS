//
//  PSFormatter.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSFormatter.h"


@interface PSFormatter ()

@property (nonnull, readwrite, nonatomic) NSNumberFormatter *currencyFormatter;
@property (nonnull, readwrite, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation PSFormatter

- (NSNumberFormatter *)currencyFormatter {
    static NSNumberFormatter *currencyFormatter = nil;
    static dispatch_once_t __dispatchToken = 0;
    dispatch_once(&__dispatchToken, ^{
        currencyFormatter = [[NSNumberFormatter alloc] init];
        [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [currencyFormatter setMaximum:[NSNumber numberWithInt:INT32_MAX]];
        [currencyFormatter setMaximumFractionDigits:2];
        [currencyFormatter setMinimumFractionDigits:2];
        [currencyFormatter setRoundingMode:NSNumberFormatterRoundHalfEven];
        /**
         * Taking the current local default.
         */
        [currencyFormatter setLocale:[NSLocale currentLocale]];
        
    });
    return currencyFormatter;
}

- ( NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t __dispatchToken = 0;
    dispatch_once(&__dispatchToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        /**
         * Taking the current local default.
         */
        [dateFormatter setLocale:[NSLocale currentLocale]];
        
    });
    return dateFormatter;
}

@end
