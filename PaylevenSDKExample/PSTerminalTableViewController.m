//
//  PSTerminalTableViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSTerminalTableViewController.h"
#import "PSTerminalTableViewDataSource.h"
#import "PSTerminalTableViewDelegate.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
#import <PaylevenSDK/PLVDevice.h>
@import CoreBluetooth;

@interface PSTerminalTableViewController()<CBCentralManagerDelegate>
@property (nonatomic) CBCentralManagerState bluetoothState;
@property (nonnull, nonatomic) CBCentralManager *bluetoothManager;
@property (nonnull, nonatomic) PLVPayleven *payleven;

@end

static void *PSBluetoothDevicesContext = &PSBluetoothDevicesContext;

@implementation PSTerminalTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObservers];
        _bluetoothManager = [[CBCentralManager alloc]initWithDelegate:self
                                                                queue:self.manager.concurrentQueue
                                                              options:@{CBCentralManagerOptionShowPowerAlertKey:@YES}];
        _bluetoothState = CBCentralManagerStateUnknown;
    }
    return self;
}

- (void)setPayleven:(PLVPayleven *)payleven {
    if (_payleven != payleven) {
        if (_payleven != nil) {
            [_payleven removeObserver:self forKeyPath:NSStringFromSelector(@selector(devices)) context:PSBluetoothDevicesContext];
        }
        _payleven = payleven;
        if (_payleven != nil) {
            [_payleven addObserver:self forKeyPath:NSStringFromSelector(@selector(devices)) options:NSKeyValueObservingOptionNew context:PSBluetoothDevicesContext];
        }
    }
}

#pragma mark - Observers

- (void)addObservers
{
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(bluetoothState)) options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:PSBluetoothDevicesContext];
}

- (void)removeObservers
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(bluetoothState)) context:PSBluetoothDevicesContext];
    [self.payleven removeObserver:self forKeyPath:NSStringFromSelector(@selector(devices)) context:PSBluetoothDevicesContext];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && context == PSBluetoothDevicesContext && [keyPath isEqualToString:NSStringFromSelector(@selector(bluetoothState))]) {
        CBCentralManagerState newState = [change[@"new"] integerValue];
        if(newState != CBCentralManagerStatePoweredOn){
            [self presentAlertViewWithErrorMessage:@"Please turn on your bluetooth" title:@"Bluetooth error"];
        } else {
            self.delegate.bluetoothState = newState;
        }
        [self.tableView reloadData];
    }
    if (object == self.payleven && context == PSBluetoothDevicesContext && [keyPath isEqualToString:NSStringFromSelector(@selector(devices))] )   {
        [self.tableView reloadData];
    }
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureViewController];
    [self configureNavigationController];
}

#pragma mark - ConfigureViewController

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.toolbarHidden = YES;
}

- (void)configureViewController {
    self.dataSource.manager = self.manager;
    self.dataSource.terminalTableViewController = self;
    self.delegate.terminalTableViewController = self;
    self.delegate.bluetoothState = self.bluetoothState;
    self.delegate.manager = self.manager;
    self.payleven = self.manager.payleven;
    [self.tableView reloadData];
}

#pragma mark - Present Error

- (void)presentAlertViewWithErrorMessage:(nonnull NSString *)aMessage title:(nonnull NSString *)title{
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

#pragma mark - PSDeviceConfigurationDelegate

- (void)didFailConfiguringDeviceWithError:(nonnull NSError *)error controller:(nonnull UIViewController *)controller {
    [self.managerDelegate updateSelectedDevice:nil];
    self.dataSource.isBoardinDevice = NO;
    [self.tableView reloadData];
    [self presentAlertViewWithErrorMessage:error.localizedDescription title:@"Device error"];
}

- (void)didSuccessfullyPrepareDevice:(nonnull PLVDevice *)device controller:(nonnull UIViewController *)controller {
    
    [self.managerDelegate updateSelectedDevice:device];
    
    self.dataSource.sortedDevice = [self.manager.payleven.devices sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PLVDevice *device1 = (PLVDevice *)obj1;
        PLVDevice *device2 = (PLVDevice *)obj2;
        return [device1.name compare:device2.name];
    }];
    self.dataSource.isBoardinDevice = NO;
    [self.tableView reloadData];
}

- (void)configureDevice:(PLVDevice *)device {
    /**
     * Takes some seconds see device after blueTooth connection
     * so we just do dispatch after 2 second to be on the save side
     */
    [self.managerDelegate updateSelectedDevice:device];
    
    self.dataSource.isBoardinDevice = YES;
    [self.tableView reloadData];
    
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.00 * NSEC_PER_SEC));
    __weak typeof(self)weakSelf = self;
    
    dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        [device prepareWithCompletionHandler:^(NSError *error) {
            if (device.ready) {
                [strongSelf didSuccessfullyPrepareDevice:device controller:strongSelf];
            } else {
                [strongSelf didFailConfiguringDeviceWithError:error controller:strongSelf];
            }
        }];
    });
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    __weak typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.bluetoothState = central.state;
    });
}

- (void)dealloc {
    [self removeObservers];
}

@end
