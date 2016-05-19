//
//  PLVRefundResult.h
//  PaylevenSDK
//
//  Created by Bob Obi on 7/23/15.
//  Copyright (c) 2015 payleven Holding GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PLVRefund, PLVReceiptGenerator;

/**
 @brief PLVRefundResult represents the result form obtained from the 
 PLVRefundRequest that was triggered with the PLVRefundTask.
 It contains a PLVRefund class and PLVReceiptGenerator class which
 generates the image receipt for every refund that was made.
 */
@interface PLVRefundResult : NSObject<NSCopying>

/**
 * PLVRefund the refund object containing details for receipts.
 */
@property(nonatomic, readonly)PLVRefund *refund;

/** 
 * Returns an instance of PLVReceiptGenerator, which generates a receipt image for the refund.
 NOTE: Receipt image must be extended with the merchant's name, address and respective receipt ID.
 */
@property(nonatomic, readonly) PLVReceiptGenerator *receiptGenerator;

@end
