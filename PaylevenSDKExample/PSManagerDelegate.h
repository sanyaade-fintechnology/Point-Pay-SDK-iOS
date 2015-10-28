//
//  PSManagerDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import CoreLocation;
@class PLVDevice;

@protocol PSManagerDelegate <NSObject>


@optional
/**
 * Called after the user has succefully logged into the system.
 * To store the MerchantId String.
 */
- (void)updateMerchantIdWithString:(NSString *)aMerchantId;
/**
 * updates the currency
 */
- (void)updateCurrencyWithString:(NSString *)aCurrency;
/**
 * updates the localIdentifier
 */
- (void)updateLocalIdentifierWithString:(NSString *)aLocalIdentifier;
/**
 * updates the coordinate
 */
- (void)updateCoordinate:(CLLocationCoordinate2D)aCoordinate;
/**
 *  updates the selected device
 */
- (void)updateSelectedDevice:(PLVDevice *)aDevice;

@end