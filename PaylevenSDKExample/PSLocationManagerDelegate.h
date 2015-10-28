//
//  PSLocationManagerDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@protocol PSLocationManagerDelegate <NSObject>
/**
 *  Called when the coordinate is found to update the Location
 */
- (void)locationDidFindCurrentCoordinate:(CLLocationCoordinate2D)coordinate;
/**
 *  Called when the coordinate is not found with LocationError.
 */
- (void)locationDidFailFindingCurrentLocalityWithError:(NSError *)error;
/**
 *  Called when the authorization status is changed.
 */
- (void)locationDidChangeAuthorizationStatus:(CLAuthorizationStatus)authorizationStatus;

@end
