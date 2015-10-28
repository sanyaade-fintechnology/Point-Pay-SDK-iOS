//
//  PSMissingPaymentsViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 9/16/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSMissingPaymentsViewController.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
#import "PSRefundViewController.h"

@interface PSMissingPaymentsViewController ()

@property (nonatomic, weak) IBOutlet UIBarButtonItem *refundUIBarButtonItem;

@end

@implementation PSMissingPaymentsViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureNavigationController];
}

#pragma mark - ConfigureNavigationController

- (void)configureNavigationController{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (IBAction)showRefundViewController:(id)sender {
    [self performSegueWithIdentifier:ManualRefundSegue sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:ManualRefundSegue]){
        PSRefundViewController *refundViewController = (PSRefundViewController *)segue.destinationViewController;
        refundViewController.manager = self.manager;
        refundViewController.managerDelegate = self.managerDelegate;
        refundViewController.payment = nil;
        refundViewController.title = @"Manual";
    }
}


@end
