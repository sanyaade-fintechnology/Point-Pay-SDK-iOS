//
//  PSLocationManager.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreLocation;
@protocol PSLocationManagerDelegate;

typedef NS_ENUM(NSInteger, PSLocationManagerError){
    PSLocationManagerUnknownError = 0,
    PSLocationManagerFailFindingLocalityError = 1,
    PSLocationManagerAuthorizationError = 2
};

FOUNDATION_EXPORT NSString *__nonnull const PSLocationManagerErrorDomain;

@interface PSLocationManager : NSObject <CLLocationManagerDelegate>

- (nonnull instancetype)initWithDelegate:(__nullable id <PSLocationManagerDelegate>)aDelegate NS_DESIGNATED_INITIALIZER;
- (void)requestCurrentLocation;

@end
