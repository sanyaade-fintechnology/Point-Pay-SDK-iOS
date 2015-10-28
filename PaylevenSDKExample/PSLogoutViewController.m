//
//  PSLogoutViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLogoutViewController.h"
#import "PSManager.h"
#import "PSLogoutDelegate.h"
#import <PaylevenSDK/PLVPayleven.h>

@interface PSLogoutViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *logoutActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *paylevenCopyrightLabel;

@end

@implementation PSLogoutViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureViewController];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    [self logout];
}

- (void)configureViewController {
    self.paylevenCopyrightLabel.text = [NSString stringWithFormat:@"payleven® %@", self.manager.currentYear.stringValue];
}

#pragma mark - Logout

- (void)logout {
    
    if (self.manager.payleven.loginState != PLVPaylevenLoginStateLoggingOut || self.manager.payleven.loginState != PLVPaylevenLoginStateLoggingIn) {
        __weak typeof(self)weakSelf = self;
        [self.manager.payleven logoutWithCompletionHandler:^(NSError *error) {
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if ([strongSelf.delegate conformsToProtocol:@protocol(PSLogoutDelegate)]) {
                if (error) {
                    [strongSelf.delegate logoutDidFailWithError:error];
                } else {
                    [strongSelf.delegate logoutViewControllerDidFinish:strongSelf];
                }
            }
        }];
    }
}
@end
