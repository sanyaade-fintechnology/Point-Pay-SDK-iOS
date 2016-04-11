#import <CoreLocation/CoreLocation.h>

@interface ADYLocationManager : NSObject <CLLocationManagerDelegate>

@property(nonatomic, readonly) CLLocation *currentLocation;

+ (ADYLocationManager *)sharedInstance;
+ (BOOL)isEnabled;
+ (BOOL)isAuthorized;

- (void)determineLocation;
- (void)stopDeterminingLocation;
- (BOOL)locationKnown;

@end
