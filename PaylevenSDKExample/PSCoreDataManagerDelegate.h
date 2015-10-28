//
//  PSCoreDataManagerDelegate.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//
@import Foundation;
@import CoreData;

@protocol PSCoreDataManagerDelegate <NSObject>

/**
 * Called when context merging fails
 */
- (void)coreDataManagerDidFailMergingContextChangesError:(NSError *__nonnull)error;
/**
 * Called when context fails to save data
 */
- (void)coreDataManagerDidFailSavingContextError:(NSError *__nonnull)error;
/**
 * Called if context failed to initialize
 */
- (void)coreDataManagerDidFailInitializingContextError:(NSError *__nonnull)error;
/**
 * Called on persistantStoreCoordinator error
 */
- (void)coreDataManagerDidFailSettingPersistantStoreCoordinatorError:(NSError *__nonnull)error;
/**
 * Notify the delegate when mergeChangesFromContextDidSaveNotification
 */
- (void)coreDataManagerDidMergeChangesFromContext;

@end
