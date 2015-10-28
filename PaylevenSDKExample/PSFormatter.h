//
//  PSFormatter.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;

@interface PSFormatter : NSObject

@property (nonnull, nonatomic, readonly) NSNumberFormatter *currencyFormatter;
@property (nonnull, nonatomic, readonly) NSDateFormatter *dateFormatter;

@end
