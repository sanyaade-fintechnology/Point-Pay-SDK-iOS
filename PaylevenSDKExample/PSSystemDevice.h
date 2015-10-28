//
//  PSSystemDevice.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;

typedef NS_ENUM (NSInteger, PSDeviceType) {
    PSDeviceTypeUnknown,
    PSDeviceType_IS_IPHONE_4_OR_LESS,
    PSDeviceType_IS_IPHONE_5,
    PSDeviceType_IS_IPHONE_6,
    PSDeviceType_IS_IPHONE_6P,
    PSDeviceType_IS_IPAD
};

@interface PSSystemDevice : NSObject

+ (PSDeviceType)currentDeviceType;

@end
