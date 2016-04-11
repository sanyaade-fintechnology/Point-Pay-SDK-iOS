//
//  ADYAppData.h
//  AdyenToolkit
//
//  Created by Jeroen Koops on 4/10/13.
//

#import <Foundation/Foundation.h>

/** Class containing data about the app.
 */
@interface ADYAppData : NSObject

@property (nonatomic, strong, readonly) NSString *devicePlatform;
@property (nonatomic, strong, readonly) NSString *deviceName;
@property (nonatomic, strong, readonly) NSString *deviceVersion;
@property (nonatomic, strong, readonly) NSString *applicationName;
@property (nonatomic, strong, readonly) NSString *AdyenLibraryVersion;
@property (nonatomic, strong, readonly) NSString *integratorName;

+ (ADYAppData *)shared;

- (NSDictionary *)dictionaryRepresentation;

@end
