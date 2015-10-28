//
//  PSManager.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//
#import "PSManager.h"
#import "PSIdentifiers.h"
#import "PSFormatter.h"

@interface PSManager()

@property NSDictionary *configurationPlist;
@property NSDictionary *infoPlist;
@property (nonnull, readwrite, nonatomic) PLVPayleven *payleven;
@property (nonnull, readwrite, nonatomic) NSString *merchantId;
@property (nonnull, readwrite, nonatomic) NSNumber *currentYear;
@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonnull, readwrite, nonatomic) NSString *localeIdentifier;
@property (nonnull, readwrite, nonatomic) NSString *currency;
@property (nonnull, readwrite, nonatomic) PSFormatter *formatter;
@property (nonnull, readwrite, nonatomic) NSString *randomString;
@property (nonnull, readwrite, nonatomic) PLVDevice *selectedDevice;
@property (nonnull, readwrite, nonatomic) NSString *versioneNumber;
@property (nonnull, readwrite, nonatomic) NSString *buildNumber;
@property (nonnull, readonly) NSString *target;

@end

NSString *const kConfigFile = @"Config";
NSString *const kInfoFile = @"Info";
NSString *const kType = @"plist";

@implementation PSManager

- (instancetype)init {
    self = [super init];
    if(self){
        _currency = @"EUR";             //Default Currency
        _localeIdentifier = @"de_DE";   //Default LocalIdentifier
        _formatter = [[PSFormatter alloc]init];
        _paylevenBlueColor = [UIColor colorWithRed:0 green:0.568627451 blue:0.7254901961 alpha:1];
        _paylevenGrayColor = [UIColor colorWithRed:0.6862745098 green:0.6862745098 blue:0.6862745098 alpha:1];
        _paylevenCancelRedColor = [UIColor colorWithRed:0.8705882353 green:0.1960784314 blue:0.4352941176 alpha: 1];
        _paylevenSuccessGreenColor = [UIColor colorWithRed:0.5490196078 green:0.7607843137 blue:0.1333333333 alpha: 1];
        _paylevenDarkBlueColor = [UIColor colorWithRed:0.1568627451 green:0.2196078431 blue:0.2980392157 alpha:1];
        _paylevenPetrolGreenColor = [UIColor colorWithRed:0.8705882353 green:0.1960784314 blue:0.4352941176 alpha:1];
        _paylevenBlueTranslucentColor = [UIColor colorWithRed:0 green:0.5411764706 blue:0.6941176471 alpha:1];
        _paylevenBlueBackgoundColor =  [UIColor colorWithRed:0.06666666667 green:0.5764705882 blue:0.7215686275 alpha:1.0];
        _paylevenGrayBackgoundColor = [UIColor colorWithRed:0.7333333333 green:0.7333333333 blue:0.7333333333 alpha: 1.0];
        _configurationPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kConfigFile ofType:kType]];
        _infoPlist = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:kInfoFile ofType:kType]];

    }
    return self;
}

- (NSString *)APIKey {
    return self.configurationPlist[PalevenAPIKey];
}

- (NSString *)buildNumber {
    return self.infoPlist[@"CFBundleVersion"];
}

- (NSString *)versionNumber {
    return self.infoPlist[@"CFBundleShortVersionString"];
}

#pragma mark - Lazy initializations

- (NSNumber *)currentYear {
    if (_currentYear) {
        return _currentYear;
    }
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[NSDate date]];
    _currentYear = [NSNumber numberWithInteger:components.year];
    return _currentYear;
}

- (PLVPayleven *)payleven {
    if (_payleven){
        return _payleven;
    }
    _payleven = [[PLVPayleven alloc]init];
    return _payleven;
}

- (dispatch_queue_t)concurrentQueue
{
    const char *queueAddress = "com.PaylevenSDKInternal.concurrent";
    static dispatch_once_t __dispatchToken = 0;
    static id queue;
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT, QOS_CLASS_USER_INITIATED, 2);
    dispatch_once(&__dispatchToken, ^{
        queue = dispatch_queue_create(queueAddress, attr);
    });
    return queue;
}

- (dispatch_queue_t)serialQueue
{
    const char *queueAddress = "com.PaylevenSDKInternal.serial";
    static dispatch_once_t __dispatchToken = 0;
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, 2);
    static id queue;
    dispatch_once(&__dispatchToken, ^{
        queue = dispatch_queue_create(queueAddress, attr);
    });
    
    return queue;
}

#pragma mark - PSManagerDelegate

- (void)updateMerchantIdWithString:(NSString *)aMerchantId{
    self.merchantId = aMerchantId;
}

- (void)updateCoordinate:(CLLocationCoordinate2D)aCoordinate {
    self.coordinate = aCoordinate;
}

- (void)updateLocalIdentifierWithString:(NSString *)aLocalIdentifier{
    self.localeIdentifier = aLocalIdentifier;
}

- (void)updateCurrencyWithString:(NSString *)aCurrency {
    self.currency = aCurrency;
}

- (void)updateSelectedDevice:(PLVDevice *)aDevice {
    self.selectedDevice = aDevice;
}

- (NSString *)randomString {
    static NSString * const alphabet = @"abcdefghijklmnopqrstuvwxyz1234567890";
    NSUInteger alphabetLength = alphabet.length;
    const NSUInteger stringLength = 20;
    NSMutableString *string = [NSMutableString stringWithCapacity:stringLength];
    for (NSUInteger i = 0; i < stringLength; i++) {
        u_int32_t randomIndex = arc4random() % alphabetLength;
        unichar c = [alphabet characterAtIndex:randomIndex];
        [string appendFormat:@"%C", c];
    }
    
    return string;
}

@end
