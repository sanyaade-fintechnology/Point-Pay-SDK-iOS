//
//  PSManager.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreLocation;
@class PSFormatter;
@class PSPayment;
#import "PSManagerDelegate.h"
#import <PaylevenSDK/PLVPayleven.h>

@interface PSManager : NSObject <PSManagerDelegate>

@property (nonnull, readonly, nonatomic) PLVPayleven *payleven;
@property (nonnull, readonly, nonatomic) NSString *merchantId;
@property (nonnull, readonly, nonatomic) NSNumber *currentYear;
@property (nonnull, readonly, nonatomic) NSString *APIKey;
@property (nonnull, readonly, nonatomic) NSString *buildNumber;
@property (nonnull, readonly, nonatomic) NSString *versionNumber;
@property (nonnull, readonly, nonatomic) UIColor *paylevenBlueColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenBlueTranslucentColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenGrayColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenCancelRedColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenSuccessGreenColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenBlueBackgoundColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenDarkBlueColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenPetrolGreenColor;
@property (nonnull, readonly, nonatomic) UIColor *paylevenGrayBackgoundColor;
@property (nonnull, readonly, nonatomic) dispatch_queue_t concurrentQueue;
@property (nonnull, readonly, nonatomic) dispatch_queue_t serialQueue;
@property (readonly, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonnull, readonly, nonatomic) NSString *localeIdentifier;
@property (nonnull, readonly, nonatomic) NSString *currency;
@property (nonnull, readonly, nonatomic) PSFormatter *formatter;
@property (nonnull, readonly, nonatomic) NSString *randomString;
@property (nonnull, readonly, nonatomic) PLVDevice *selectedDevice;
@property (nullable, nonatomic) PSPayment *selectedPayment;

@end
