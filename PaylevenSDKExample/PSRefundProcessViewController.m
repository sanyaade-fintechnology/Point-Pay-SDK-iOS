//
//  PSRefundProcessViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/26/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSRefundProcessViewController.h"
#import "PSManager.h"

@interface PSRefundProcessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *paylevenCopyrightLabel;

@end

@implementation PSRefundProcessViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - ConfigureViewController

- (void)configureViewController {
    self.paylevenCopyrightLabel.text = [NSString stringWithFormat:@"payleven® %@", self.manager.currentYear.stringValue];
}

- (void)refundViewControllerDidFinish:(void (^)(void))completion {
    [self dismissViewControllerAnimated:NO completion:completion];
}


@end
