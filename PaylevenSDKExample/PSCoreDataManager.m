//
//  PSCoreDataManager.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/13/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSCoreDataManager.h"
#import "PSCoreDataManagerDelegate.h"
#import "PSPayment.h"
#import <PLVPaymentResult.h>
#import <PLVRefund.h>

NSString *const kPaylevenSDKExample = @"PaylevenSDKExample";
NSString *const kMomd = @"momd";
NSString *const kMom = @"mom";
NSString *const kDefaultKey = @"index";
NSString *const kPaymentEntity = @"PSPayment";
NSString *const PSCoreDataManagerErrorDomain = @"PSCoreDataManagerErrorDomain";

@interface PSCoreDataManager ()

@property (nonatomic, weak) id <PSCoreDataManagerDelegate> delegate;

@property (nonatomic) NSManagedObjectModel *managedObjectModel;
@property (nonatomic) NSManagedObjectContext *mainManagedObjectContext;
@property (nonatomic) NSManagedObjectContext *taskManagedObjectContext;
@property (nonatomic) NSPersistentStoreCoordinator  *persistentStoreCoordinator;

@end

@implementation PSCoreDataManager

@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize taskManagedObjectContext = _taskManagedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Convenience init

- (instancetype)init {
    return [self initWithDelegate:nil];
}

#pragma mark - Designated init 

- (nonnull instancetype)initWithDelegate:(id<PSCoreDataManagerDelegate> __nullable)aDelegate {
    self = [super init];
    if (self) {
        _delegate = aDelegate;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveWithNotification:) name:NSManagedObjectContextDidSaveNotification object:self.taskManagedObjectContext];
    }
    return self;
}

- (void)lockManagedObjectsInNotification:(NSNotification *)notification
{
    NSArray *objects = [notification.userInfo valueForKey:NSUpdatedObjectsKey];
    
    for(NSManagedObject *obj in objects){
        NSManagedObject *mainQueueObject = [self.mainManagedObjectContext objectWithID:obj.objectID];
        [mainQueueObject willAccessValueForKey:nil];
    }
}

- (void)managedObjectContextDidSaveWithNotification:(NSNotification *)notification
{
    __weak typeof(self)weakSelf = self;
    [self lockManagedObjectsInNotification:notification];
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.mainManagedObjectContext mergeChangesFromContextDidSaveNotification:notification];
        [strongSelf.delegate coreDataManagerDidMergeChangesFromContext];
    });
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel){
        return _managedObjectModel;
    }
    
    
    NSURL *modelContainerUrl = [[NSBundle mainBundle] URLForResource:kPaylevenSDKExample withExtension:kMomd];
    
    NSURL *modelVersionUrl = [[NSBundle mainBundle] URLForResource:kPaylevenSDKExample withExtension:kMom];
    
    if (modelContainerUrl) {
        _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelContainerUrl];
    } else {
        _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelVersionUrl];
    }
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator){
        return _persistentStoreCoordinator;
    }
    
    NSError *error;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PaylevenSDKInternalApp.sqlite"];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption:@YES,
                              NSInferMappingModelAutomaticallyOption:@YES,
                              NSSQLitePragmasOption:@{@"journal_mode":@"DELETE"}
                              };
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL
                                                        options:options error:&error]){
        NSError *persistentStoreError = [NSError errorWithDomain:PSCoreDataManagerErrorDomain
                                                            code:PSCoreDataManagerPersistantStoreError
                                                        userInfo:@{
                                                                   NSUnderlyingErrorKey:error
                                                                   }];
        if([self.delegate respondsToSelector:@selector(coreDataManagerDidFailSettingPersistantStoreCoordinatorError:)]){
            [self.delegate coreDataManagerDidFailSettingPersistantStoreCoordinatorError:persistentStoreError];
            return nil;
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)mainManagedObjectContext
{
    if(_mainManagedObjectContext){
        return _mainManagedObjectContext;
    }
    _mainManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSMainQueueConcurrencyType];
    _mainManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)taskManagedObjectContext
{
    if(_taskManagedObjectContext){
        return _taskManagedObjectContext;
    }
    _taskManagedObjectContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _taskManagedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return _taskManagedObjectContext;
}

- (BOOL)saveContext:(NSManagedObjectContext *)managedObjectContext
{
    NSError *error;
    
    if([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
        NSError *saveContextError = [NSError errorWithDomain:PSCoreDataManagerErrorDomain
                                                        code:PSCoreDataManagerSavingContextError
                                                    userInfo:@{
                                                               NSUnderlyingErrorKey: error
                                                               }];
        if([self.delegate respondsToSelector:@selector(coreDataManagerDidFailSavingContextError:)]){
            [self.delegate coreDataManagerDidFailSavingContextError:saveContextError];
        }
        return NO;
    }
    return YES;
}


#pragma mark - fetchedResultsControllerForUpdateWithEntity

- (nonnull NSFetchedResultsController *)fetchedResultsControllerForUpdateWithEntity:(nonnull NSString *)anEntity {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:anEntity];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kDefaultKey ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    request.fetchBatchSize = 5;
    request.returnsObjectsAsFaults = YES;
    request.includesPropertyValues = NO;
    NSError *error;
    NSFetchedResultsController *fetchedResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.taskManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
    [fetchedResultController performFetch:&error];
    return fetchedResultController;
}

- (NSUInteger)sectionNumberOfObjectsForFetchedResultController:(nonnull NSFetchedResultsController *)fetchedResultController section:(NSInteger)section {
    NSArray *sections = fetchedResultController.sections;
    id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    return [sectionInfo numberOfObjects];
}

- (NSUInteger)numberOfObjectsForEntity:(nonnull NSString *)anEntity {
    NSFetchedResultsController *fetchedResultController = [self fetchedResultsControllerForUpdateWithEntity:anEntity];
    return [self sectionNumberOfObjectsForFetchedResultController:fetchedResultController section:0];
}

- (nonnull NSFetchRequest *)requestForSearchWithEntity:(nonnull NSString *)anEntity predicate:(nullable NSPredicate*)predicate sortDescriptor:(nullable NSSortDescriptor *)sortDescriptor {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:anEntity];
    if (predicate) {
        request.predicate = predicate;
    }
    if (sortDescriptor){
        request.sortDescriptors = @[sortDescriptor];
    } else {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kDefaultKey ascending:YES];
        request.sortDescriptors = @[sortDescriptor];
    }
    request.fetchBatchSize = 1;
    return request;
}

- (nonnull NSFetchedResultsController *)paymentsWithPredicate:(nullable NSPredicate *)aPredicate sortDescriptior:(nullable NSSortDescriptor *)aSortDescriptor {
    NSFetchRequest *request = [self requestForSearchWithEntity:kPaymentEntity predicate:aPredicate sortDescriptor:aSortDescriptor];
    return [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.mainManagedObjectContext sectionNameKeyPath:nil cacheName:nil];
}

- (void)savePaymentResult:(nonnull PLVPaymentResult *)paymentResult merchantId:(nonnull NSString *)merchanId completion:(void (^ __nonnull)(BOOL))completion {
    NSInteger numberOfObjects = [self numberOfObjectsForEntity:kPaymentEntity];
    PSPayment *entity = [NSEntityDescription insertNewObjectForEntityForName:kPaymentEntity inManagedObjectContext:self.taskManagedObjectContext];
    entity.index = [NSNumber numberWithInteger:numberOfObjects+1];
    entity.merchantId = merchanId;
    entity.paymentId = paymentResult.identifier;
    entity.date = paymentResult.date;
    entity.currency = paymentResult.currency;
    entity.amount = [NSNumber numberWithDouble:paymentResult.amount.doubleValue];
    entity.paymentState = [NSNumber numberWithInteger:paymentResult.state];
    entity.refundedAmount = @0.00;
    entity.remainingAmount = [NSNumber numberWithDouble:paymentResult.amount.doubleValue];
    entity.signature = paymentResult.signatureImageURL.absoluteString;
    completion([self saveContext:self.taskManagedObjectContext]);
}

- (void)updatePaymentWithRefund:(nonnull PLVRefund *)refund merchantId:(nonnull NSString *)merchantId completion:(void (^ __nonnull)(BOOL))completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"merchantId = %@ AND paymentId = %@", merchantId, refund.paymentIdentifier];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = predicate;
    [request setEntity:[NSEntityDescription entityForName:kPaymentEntity inManagedObjectContext:self.taskManagedObjectContext]];
    [request setIncludesPropertyValues:NO];
    [request setReturnsObjectsAsFaults:YES];
    NSError *error;
    NSArray *result = [self.taskManagedObjectContext executeFetchRequest:request error:&error];
    if ([result count] > 0) {
        PSPayment *payment = [result lastObject];
        payment.refundedAmount = [NSNumber numberWithDouble:refund.refundedAmount.doubleValue];
        payment.remainingAmount = [NSNumber numberWithDouble:refund.remainingAmount.doubleValue];
    }
    completion([self saveContext:self.taskManagedObjectContext]);
}

- (void)deletePaymentWithIdentifier:(nonnull NSString *)paymentIdentifier merchantId:(nonnull NSString *)merchantId completion:(void (^ __nonnull)(BOOL))completion {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"merchantId = %@ AND paymentId = %@", merchantId, paymentIdentifier];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    request.predicate = predicate;
    [request setEntity:[NSEntityDescription entityForName:kPaymentEntity inManagedObjectContext:self.taskManagedObjectContext]];
    [request setIncludesPropertyValues:NO];
    [request setReturnsObjectsAsFaults:YES];
    NSError *error;
    NSArray *result = [self.taskManagedObjectContext executeFetchRequest:request error:&error];
    if([result count] > 0) {
        NSManagedObject *payment = [result lastObject];
        [self.taskManagedObjectContext deleteObject:payment];
    }
    completion([self saveContext:self.taskManagedObjectContext]);
}

- (void)mockPaymentsResults {
    
    PSPayment *entity1 = [NSEntityDescription insertNewObjectForEntityForName:kPaymentEntity inManagedObjectContext:self.taskManagedObjectContext];
    entity1.index = [NSNumber numberWithInteger:[self numberOfObjectsForEntity:kPaymentEntity]+1];
    entity1.merchantId = @"testeIT5@sharklasers.com";
    entity1.paymentId = [[NSUUID UUID] UUIDString];
    entity1.date = [NSDate date];
    entity1.currency = @"EUR";
    entity1.amount = @9.92;
    entity1.paymentState = @0;
    entity1.signature = @"non signature";
    [self saveContext:self.taskManagedObjectContext];

    PSPayment *entity2 = [NSEntityDescription insertNewObjectForEntityForName:kPaymentEntity inManagedObjectContext:self.taskManagedObjectContext];
    entity2.index = [NSNumber numberWithInteger:[self numberOfObjectsForEntity:kPaymentEntity]+1];
    entity2.merchantId = @"testeIT5@sharklasers.com";
    entity2.paymentId = [[NSUUID UUID] UUIDString];
    entity2.date = [NSDate date];
    entity2.currency = @"EUR";
    entity2.amount = @1.29;
    entity2.paymentState = @0;
    entity2.signature = @"non signature";
    [self saveContext:self.taskManagedObjectContext];
    
    PSPayment *entity = [NSEntityDescription insertNewObjectForEntityForName:kPaymentEntity inManagedObjectContext:self.taskManagedObjectContext];
    entity.index = [NSNumber numberWithInteger:[self numberOfObjectsForEntity:kPaymentEntity]+1];
    entity.merchantId = @"testeIT5@sharklasers.com";
    entity.paymentId = [[NSUUID UUID] UUIDString];
    entity.date = [NSDate date];
    entity.currency = @"EUR";
    entity.amount = @1.69;
    entity.paymentState = @0;
    entity.signature = @"non signature";
    [self saveContext:self.taskManagedObjectContext];
}

@end
