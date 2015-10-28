//
//  PSLoginProcessViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLoginProcessViewController.h"
#import "PSManager.h"
#import "PSLoginDelegate.h"

@interface PSLoginProcessViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *paylevenLogo;
@property (weak, nonatomic) IBOutlet UILabel *paylevenCopyrightLabel;

@end

@implementation PSLoginProcessViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureNavigationController];
    [self loginWithUserName:self.username password:self.password];
}

#pragma mark - ConfigureViewController

- (void)configureViewController {
    self.paylevenCopyrightLabel.text = [NSString stringWithFormat:@"payleven® %@", self.manager.currentYear.stringValue];
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

#pragma mark - loginWithUserName

- (void)loginWithUserName:(NSString *)username password:(NSString *)password {
    __weak typeof(self) weakSelf = self;
    
    /*
     * You can get your payleven APIKey here: https://service.payleven.com/uk/developer
     * 
     * Please keep in mind that you can use your own API key only with your own registered CFBundleIdentifier.
     */
    
    [self.manager.payleven loginWithUsername:username password:password APIKey:self.manager.APIKey completionHandler:^(NSError *error) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if([strongSelf.delegate conformsToProtocol:@protocol(PSLoginDelegate)]) {
            if(error) {
                [strongSelf.delegate loginDidFailWithError:error];
            } else {
                [strongSelf.delegate loginViewControllerDidFinish:(PSLoginViewController *)strongSelf.delegate];
            }
        }
    }];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}

@end
