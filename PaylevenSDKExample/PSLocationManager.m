//
//  PSLocationManager.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLocationManager.h"
#import "PSLocationManagerDelegate.h"


@interface PSLocationManager()

@property (nonatomic, weak) id <PSLocationManagerDelegate> delegate;
@property (nonnull,  nonatomic) CLLocationManager *locationManager;

@end

NSString *const PSLocationManagerErrorDomain = @"PSLocationManagerErrorDomain";

@implementation PSLocationManager

#pragma mark - Convenience init

- (instancetype)init {
    return [self initWithDelegate:nil];
}

#pragma mark - Designated init 

- (nonnull instancetype)initWithDelegate:(id<PSLocationManagerDelegate> __nullable)aDelegate {
    self = [super init];
    if (self) {
        _delegate = aDelegate;
    }
    return self;
}

#pragma mark - Lazy initialization

- (CLLocationManager *)locationManager
{
    if(_locationManager){
        return _locationManager;
    }
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    return _locationManager;
}

#pragma mark - RequestCurrentLocation

- (void)requestCurrentLocation
{
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - FindCoordinateWithLocation

- (void)findCoordinateWithLocation:(CLLocation *)location
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    __weak typeof(self)weakSelf = self;
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        CLPlacemark *nearestPlaceMark = [placemarks firstObject];
        if([strongSelf.delegate respondsToSelector:@selector(locationDidFindCurrentCoordinate:)]){
            [strongSelf.delegate locationDidFindCurrentCoordinate:nearestPlaceMark.location.coordinate];
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    [self findCoordinateWithLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(locationDidFailFindingCurrentLocalityWithError:)]){
        
        NSError *theError = [NSError errorWithDomain:PSLocationManagerErrorDomain
                                                code:PSLocationManagerFailFindingLocalityError
                                            userInfo:@{
                                                       NSUnderlyingErrorKey:error
                                                       }];
        
        [self.delegate locationDidFailFindingCurrentLocalityWithError:theError];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if([self.delegate respondsToSelector:@selector(locationDidChangeAuthorizationStatus:)]){
        [self.delegate locationDidChangeAuthorizationStatus:status];
    }
}

@end
