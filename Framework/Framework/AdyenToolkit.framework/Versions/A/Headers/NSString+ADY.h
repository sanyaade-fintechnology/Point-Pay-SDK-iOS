//
//  NSString+ADY.h

#import <Foundation/Foundation.h>

@interface NSString (ADY)

- (BOOL)ady_matchesRegex:(NSString *)regex;

- (NSString *)ady_urlencode;

- (BOOL)ady_containsString:(NSString *)aString;

+ (NSString *)ady_stringWithTimeFromDate:(NSDate *)date;

+ (NSString *)ady_stringWithCurrencyAmount:(NSInteger)minorUnits numFractionalDigits:(NSUInteger)decimals;


@end
