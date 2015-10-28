//
//  PSCoreDataManager.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;
@import CoreData;
@protocol PSCoreDataManagerDelegate;
@class PLVPaymentResult;
@class PLVRefund;

typedef NS_ENUM(NSInteger, PSCoreDataManagerError){
    PSCoreDataManagerUnknownError = 0,
    PSCoreDataManagerSavingContextError,
    PSCoreDataManagerInitializingContextError,
    PSCoreDataManagerPersistantStoreError
};

FOUNDATION_EXPORT NSString *__nonnull const PSCoreDataManagerErrorDomain;

@interface PSCoreDataManager : NSObject
/**
 * Initializes the coredata manager with a delegate
 */
- (nonnull instancetype)initWithDelegate:(__nullable id <PSCoreDataManagerDelegate>)aDelegate NS_DESIGNATED_INITIALIZER;
/**
 * Returns NSFetchedResultsController with Payments
 */
- (nonnull NSFetchedResultsController *)paymentsWithPredicate:(nullable NSPredicate *)aPredicate sortDescriptior:(nullable NSSortDescriptor *)aSortDescriptor;
/**
 * Saves payments with the given PLVPaymentResult
 */
- (void)savePaymentResult:(nonnull PLVPaymentResult *)paymentResult merchantId:(nonnull NSString *)merchanId completion:(void (^__nonnull)(BOOL result))completion;
/**
 * Updates the payment with the partial/full - PLVRefund
 */
- (void)updatePaymentWithRefund:(nonnull PLVRefund *)refund merchantId:(nonnull NSString *)merchantId completion:(void (^__nonnull)(BOOL result))completion;

    //FIXME: Method for payment update locally

- (void)deletePaymentWithIdentifier:(nonnull NSString *)paymentIdentifier merchantId:(nonnull NSString *)merchantId completion:(void (^__nonnull)(BOOL result))completion;
/**
 * Mock Payments
 * saves list of payments for testing.
 */
- (void)mockPaymentsResults;

@end
