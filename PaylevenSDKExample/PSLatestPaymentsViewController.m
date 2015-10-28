//
//  PSLatestPaymentsTableViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLatestPaymentsViewController.h"
#import "PSLatestPaymentsTableViewDataSource.h"
#import "PSLatestPaymentsTableViewDelegate.h"
#import "PSRefundViewController.h"
#import "PSCoreDataManager.h"
#import "PSManager.h"
#import "PSIdentifiers.h"
#import "PSPayment.h"
#import <PaylevenSDK/PLVPaymentResultAdditionalData.h>

@interface PSLatestPaymentsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *refundBarbuttonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation PSLatestPaymentsViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [[PSLatestPaymentsTableViewDataSource alloc] init];
    self.delegate = [[PSLatestPaymentsTableViewDelegate alloc] init];
    
    
    //[self configureViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureViewController];
    [self configureNavigationController];
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - ShowRefundViewController

- (IBAction)showRefundViewController:(id)sender {
    [self performSegueWithIdentifier:RefundViewSegue sender:self.refundBarbuttonItem];
}

#pragma mark - ConfigureViewController

- (void)configureViewController {
    self.dataSource.latestPaymentsTableViewController = self;
    self.delegate.latestPaymentsTableViewController = self;
    [self.fetchedResultController performFetch:nil];

    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.delegate;
    
    self.dataSource.fetchedResultController = self.fetchedResultController;
    self.delegate.fetchedResultController = self.fetchedResultController;
    self.dataSource.manager = self.manager;
    self.noRefundView.hidden = YES;

    
    [self.tableView reloadData];
}

#pragma  mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:RefundViewSegue]){
        PSRefundViewController *refundViewController = (PSRefundViewController *)segue.destinationViewController;
        refundViewController.manager = self.manager;
        refundViewController.managerDelegate = self.managerDelegate;
        refundViewController.coreDataManager = self.coreDataManager;
        if (self.dataSource.selectedPayment && [sender isKindOfClass:[PSLatestPaymentsViewController class]]) {
            refundViewController.payment = self.dataSource.selectedPayment;
        } else if ([sender isKindOfClass:[UIBarButtonItem class]] && sender == self.refundBarbuttonItem){
            refundViewController.payment = nil;
        }
    }
}

@end
