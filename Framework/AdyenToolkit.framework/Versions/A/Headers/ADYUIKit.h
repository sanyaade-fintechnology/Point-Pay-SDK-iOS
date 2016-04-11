//
//  ADYUIKit.h
//  Pods
//
//  Created by Taras Kalapun on 1/7/16.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define ADYImageClassName UIImage
#else
#define ADYImageClassName NSImage
#endif

@interface ADYUIKit : NSObject

+ (NSData *)pngRepresentationFromImage:(ADYImageClassName *)image;

/**
 * @param maxSize maximum resulting data-size, in kilobytes.
 */
+ (NSData *)signatureDataFromImage:(ADYImageClassName *)image withMaxSize:(NSUInteger)maxSize;

@end
