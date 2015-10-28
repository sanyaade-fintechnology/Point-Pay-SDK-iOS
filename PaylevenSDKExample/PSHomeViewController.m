//
//  PSHomeViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSHomeViewController.h"
#import "PSLatestPaymentsViewController.h"
#import "PSLatestPaymentsTableViewDataSource.h"
#import "PSLogoutViewController.h"
#import "PSPaymentViewController.h"
#import "PSHomeTableViewDelegate.h"
#import "PSHomeTableViewDataSource.h"
#import "PSTerminalMissingViewController.h"
#import "PSTerminalTableViewController.h"
#import "PSRefundViewController.h"
#import "PSMissingPaymentsViewController.h"
#import "PSManager.h"
#import "PSIdentifiers.h"
#import "PSCoreDataManagerDelegate.h"
#import "PSCoreDataManager.h"
#import <PaylevenSDK/PLVDevice.h>
#import <PaylevenSDK/PLVPayleven.h>
@import CoreData;

@interface PSHomeViewController ()

@property (nonnull, nonatomic) PSCoreDataManager *coreDataManager;

@end

@implementation PSHomeViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        _coreDataManager = [[PSCoreDataManager alloc]initWithDelegate:self];
    }
    
    return self;
}

#pragma mark - Life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    [self configureNavigationController];
    [self configureViewController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    /* Used for mocking payments
     * [self.coreDataManager mockPaymentsResults];
     */
    [self fetchLatestPayments];
}

#pragma mark - ConfigureViewController

- (void)configureViewController {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableViewDelegate.homeTableViewController = self;
    self.tableViewDelegate.manager = self.manager;
    self.versionLabel.text = [NSString stringWithFormat:@"version %@ build %@ SDK %@", self.manager.versionNumber, self.manager.buildNumber, [PLVPayleven SDKVersion]];
    [self.tableView reloadData];
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)fetchLatestPayments {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"merchantId = %@ && remainingAmount.intValue > 0", self.manager.merchantId];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:kDefault ascending:YES];
    self.fetchedResultController = [self.coreDataManager paymentsWithPredicate:predicate sortDescriptior:sortDescriptor];
    [self.fetchedResultController performFetch:nil];
}

#pragma mark - Error message

- (void)presentAlertViewWithErrorMessage:(NSString *)aMessage title:(NSString *)title {
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title message:aMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:title message:aMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertViewController addAction:okAction];
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:LogoutProcessSegue]) {
        PSLogoutViewController *logoutViewController = (PSLogoutViewController *)segue.destinationViewController;
        logoutViewController.manager = self.manager;
        logoutViewController.delegate = self;
    } else if ([segue.identifier isEqualToString:TerminalSegue]) {
        PSTerminalTableViewController *terminalTableViewController = (PSTerminalTableViewController *)segue.destinationViewController;
        terminalTableViewController.manager = self.manager;
        terminalTableViewController.managerDelegate = self.manager;
    } else if ([segue.identifier isEqualToString:TerminalMissingSegue]) {
        PSTerminalMissingViewController *terminalMissingViewController = (PSTerminalMissingViewController *)segue.destinationViewController;
        terminalMissingViewController.manager = self.manager;
    } else if ([segue.identifier isEqualToString:LatestPaymentMissingSegue]) {
        PSMissingPaymentsViewController *missingPaymentsViewController = (PSMissingPaymentsViewController *)segue.destinationViewController;
        missingPaymentsViewController.title = @"Refund";
        missingPaymentsViewController.manager = self.manager;
        missingPaymentsViewController.managerDelegate = self.manager;
    } else if ([segue.identifier isEqualToString:PaymentViewSegue]) {
        PSPaymentViewController *paymentViewController = (PSPaymentViewController *)segue.destinationViewController;
        paymentViewController.manager = self.manager;
        paymentViewController.managerDelegate = self.manager;
        paymentViewController.coreDataManager = self.coreDataManager;
    } else if ([segue.identifier isEqualToString:RefundViewSegue]) {
        PSRefundViewController *refundViewController = (PSRefundViewController *)segue.destinationViewController;
        refundViewController.manager = self.manager;
        refundViewController.managerDelegate = (id <PSManagerDelegate>)self.manager;
        refundViewController.coreDataManager = self.coreDataManager;
    } else if ([segue.identifier isEqualToString:LatestPaymentSegue]){
        PSLatestPaymentsViewController *latestPaymentViewController = (PSLatestPaymentsViewController *)segue.destinationViewController;
        latestPaymentViewController.manager = self.manager;
        latestPaymentViewController.coreDataManager = self.coreDataManager;
        latestPaymentViewController.dataSource.selectedPayment = self.manager.selectedPayment;
        latestPaymentViewController.managerDelegate = self.manager;
        latestPaymentViewController.fetchedResultController = self.fetchedResultController;
    }
}

#pragma mark - UnwindFromMissingTerminalViewController

- (IBAction)unwindFromMissingTerminalViewController:(UIStoryboardSegue *)sender {
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.60 * NSEC_PER_SEC));
    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf performSegueWithIdentifier:TerminalSegue sender:strongSelf];

    });
}

#pragma mark - LogoutDelegate

- (void)logoutDidFailWithError:(NSError *)error {
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"Logout Error"];
}

- (void)logoutViewControllerDidFinish:(PSLogoutViewController *)logoutViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
    [logoutViewController dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark - PSCoreDataManagerDelegate

- (void)coreDataManagerDidFailInitializingContextError:(NSError * __nonnull)error {
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"System Error"];
}

- (void)coreDataManagerDidFailMergingContextChangesError:(NSError * __nonnull)error {
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"System Error"];
}

- (void)coreDataManagerDidFailSavingContextError:(NSError * __nonnull)error {
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"System Error"];
}

- (void)coreDataManagerDidFailSettingPersistantStoreCoordinatorError:(NSError * __nonnull)error {
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"System Error"];
}

- (void)coreDataManagerDidMergeChangesFromContext {
    [self viewDidLoad];
}

@end
