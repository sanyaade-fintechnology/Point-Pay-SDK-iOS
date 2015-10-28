//
//  PSSystemDevice.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSSystemDevice.h"

@implementation PSSystemDevice

+ (PSDeviceType)currentDeviceType {
    CGFloat SCREEN_WIDTH = [UIScreen mainScreen].bounds.size.width;
    CGFloat SCREEN_HEIGHT = [UIScreen mainScreen].bounds.size.height;
    CGFloat SCREEN_MAX_LENGTH = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH < 568.0) {
        return PSDeviceType_IS_IPHONE_4_OR_LESS;
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 568.0) {
        return PSDeviceType_IS_IPHONE_5;
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 667.0) {
        return PSDeviceType_IS_IPHONE_6;
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 736.0) {
        return PSDeviceType_IS_IPHONE_6P;
    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && SCREEN_MAX_LENGTH == 1024.0) {
        return PSDeviceType_IS_IPAD;
    } else {
        return PSDeviceTypeUnknown;
    }
}

@end
