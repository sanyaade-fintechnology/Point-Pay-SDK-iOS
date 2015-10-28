//
//  PSOptions.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSOption.h"

@implementation PSOption

- (instancetype)initWithDescription:(NSString *)aDescription
                              image:(UIImage *)image {
    self = [super init];
    if (self) {
        _aDescription = [aDescription copy];
        _image = [image copy];
    }
    
    return self;
}

- (instancetype)copyWithZone:(__unused NSZone *)zone {
    return self;
}

@end
