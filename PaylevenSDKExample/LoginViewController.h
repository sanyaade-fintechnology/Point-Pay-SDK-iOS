//
//  LoginViewController.h
//  PaylevenSDKExample
//
//  Created by Alexei Kuznetsov on 14.10.14.
//  Copyright (c) 2014 payleven Holding GmbH. All rights reserved.
//

@import UIKit;
#import <PaylevenSDK/PaylevenSDK.h>

@class PLVPayleven;

@protocol LoginViewControllerDelegate;

/** Login view controller. */
@interface LoginViewController : UITableViewController

/** The receiver's delegate. */
@property(nonatomic, weak) id <LoginViewControllerDelegate> delegate;

/** Payleven. */
@property(nonatomic, strong) PLVPayleven *payleven;

/** Username field. */
@property(nonatomic, weak) IBOutlet UITextField *usernameField;

/** Password field. */
@property(nonatomic, weak) IBOutlet UITextField *passwordField;

/** Login activity indicator. */
@property(nonatomic, weak) IBOutlet UIActivityIndicatorView *loginActivityIndicator;

/** Updates cells according to login state. */
- (void)updateCellsWithLoginState:(PLVPaylevenLoginState)loginState;

/** Shows login failure alert. */
- (void)showLoginFailureAlertWithError:(NSError *)error;

@end


/** The delegate of LoginViewController must adopt the LoginViewControllerDelegate protocol. */
@protocol LoginViewControllerDelegate <NSObject>

@required

/** Called when LoginViewController finishes login. */
- (void)loginViewControllerDidFinish:(LoginViewController *)loginViewController;

@end
