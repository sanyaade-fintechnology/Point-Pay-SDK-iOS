//
//  PSTerminalMissingViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSTerminalMissingViewController.h"
#import "PSManager.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
#import <PaylevenSDK/PLVDevice.h>

@interface PSTerminalMissingViewController ()

@property (nonnull, nonatomic) PLVPayleven *payleven;

@end

static void *PSMissingDevicesContext = &PSMissingDevicesContext;

@implementation PSTerminalMissingViewController

#pragma mark - Life cycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    self.payleven = self.manager.payleven;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureNavigationController];
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - Payleven object

- (void)setPayleven:(PLVPayleven *)payleven {
    if (_payleven != payleven) {
        if (_payleven != nil) {
            [_payleven removeObserver:self forKeyPath:NSStringFromSelector(@selector(devices)) context:PSMissingDevicesContext];
        }
        _payleven = payleven;
        if (_payleven != nil) {
            [_payleven addObserver:self forKeyPath:NSStringFromSelector(@selector(devices)) options:NSKeyValueObservingOptionNew context:PSMissingDevicesContext];
        }
    }
}

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.payleven && context == PSMissingDevicesContext  && [keyPath isEqualToString:NSStringFromSelector(@selector(devices))] )   {
        if ([self.payleven.devices count] > 0) {
            [self performSegueWithIdentifier:UnwindFromMissingTerminalSegue sender:self];
        }
    }
}

#pragma mark - dealoc

- (void)dealloc {
     [self.payleven removeObserver:self forKeyPath:NSStringFromSelector(@selector(devices)) context:PSMissingDevicesContext];
}

@end
