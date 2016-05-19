//
//  PLVPaymentRequest.h
//  PaylevenSDK
//
//  Created by Alexei Kuznetsov on 21/10/14.
//  Copyright (c) 2014 payleven Holding GmbH. All rights reserved.
//
@import CoreLocation;
@import Foundation;
/** 
 @brief PLVPaymentRequest is payment request instance that requires the identifier,
 amount, coordinate and currency.
 */
@interface PLVPaymentRequest : NSObject
/**
 @brief Mandatory unique identifier (e.g order number) of the payment request.
 The ID can be any set of alphanumeric characters [A-Z, a-z, 0-9].
 This payment identifier must be included in receipts and will be reflected on payleven's receipt images. Please retain this identifier for your records and for further reference (e.g Refund).
 */
@property(nonatomic, readonly, copy) NSString *paymentIdentifier;
@property(nonatomic, readonly, copy) NSString *identifier DEPRECATED_MSG_ATTRIBUTE("use paymentIdentifier");

/**
 @brief Amount to be charged in a decimal format, which must be at least one major currency unit (e.g 1.00 Euro) and cannot be negative or zero.
 
 @discussion The value can be fractional, maximum two fraction digits are allowed.
 When creating `NSDecimalNumber` from `NSString`, don't forget to take the current locale and the decimal separator into account.
 */
@property(nonatomic, readonly, copy) NSDecimalNumber *paymentAmount;
@property(nonatomic, readonly, copy) NSString *amount DEPRECATED_MSG_ATTRIBUTE("use paymentAmount");

/** 
 @brief Three-letter alphabetic code according to ISO 4217 representing the payment's currency that must match the merchant country's local currency. Supported currencies are EUR, GBP and PLN.
 */
@property(nonatomic, readonly, copy) NSString *paymentCurrency;
@property(nonatomic, readonly, copy) NSString *currency DEPRECATED_MSG_ATTRIBUTE("use paymentCurrency");

/** 
 @brief Current device coordinate at the time of the payment attempt.
 */
@property(nonatomic, readonly, assign) CLLocationCoordinate2D paymentCoordinate;
@property(nonatomic, readonly, assign) CLLocationCoordinate2D coordinate DEPRECATED_MSG_ATTRIBUTE("use paymentCoordinate");

/**
 @brief Initializes the receiver with the specified identifier, amount, currency, and coordinate.
 
 @param identifier Payment identifier.
 
 @param amount Payment amount. The value can be fractional, maximum two fraction digits are allowed. When creating
                `NSDecimalNumber` from `NSString`, don't forget to take the current locale and the decimal separator
                into account.

 @param currency Three-letter ISO 4217 currency code. For example, EUR.
 
 @param coordinate Current device coordinate.
 */
- (instancetype)initWithIdentifier:(NSString *)identifier
                            amount:(NSDecimalNumber *)amount
                          currency:(NSString *)currency
                        coordinate:(CLLocationCoordinate2D)coordinate;

@end
