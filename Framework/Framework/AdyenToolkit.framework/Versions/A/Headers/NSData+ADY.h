//
//  NSData+ADY
//
//  Created by Taras Kalapun

#import <Foundation/Foundation.h>

@interface NSData (ADY)

+(NSData*)ady_dataWithByte:(unsigned char)byte;
+(NSData*)ady_dataWithByte:(unsigned char)byte1 andByte:(unsigned char)byte2;
+(NSData*)ady_dataWithByte:(unsigned char)byte1 andByte:(unsigned char)byte2 andByte:(unsigned char)byte3;

- (unsigned char)ady_crc8;
- (NSData *)ady_md5;
- (NSData *)ady_sha1;

- (NSString *)ady_asUtf8String;

+ (NSData*)ady_dataWithHexString:(NSString*)hexString;
- (NSString *)ady_toHexString;


@end

@interface NSMutableData (ADY)

-(void)ady_deleteHead:(NSUInteger)length;
-(NSData*)ady_takeHead:(NSUInteger)length;

@end