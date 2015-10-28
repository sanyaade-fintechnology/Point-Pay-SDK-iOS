//
//  PSReceiptViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSReceiptViewController.h"

@implementation PSReceiptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.receiptImageView.image = self.image;
    [self configureNavigationController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)configureNavigationController{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}



- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
