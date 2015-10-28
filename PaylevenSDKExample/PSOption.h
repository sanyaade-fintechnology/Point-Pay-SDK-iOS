//
//  PSOptions.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface PSOption : NSObject<NSCopying>

@property (readonly, nonatomic) NSString *aDescription;
@property (readonly, nonatomic) UIImage *image;

- (instancetype)initWithDescription:(NSString *)aDescription
                              image:(UIImage *)image;

@end
