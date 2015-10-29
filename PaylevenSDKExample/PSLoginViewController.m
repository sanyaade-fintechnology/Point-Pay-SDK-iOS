//
//  PSLoginViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLoginViewController.h"
#import "PSLoginProcessViewController.h"
#import "PSIdentifiers.h"
#import "PSManager.h"
#import "PSLoginDelegate.h"
#import "PSManagerDelegate.h"
#import "PSSystemDevice.h"
#import "PSHomeViewController.h"
#import "PSSignViewController.h"

@interface PSLoginViewController ()<UITextFieldDelegate, UIAlertViewDelegate>

#pragma mark - IBOutlet properties

@property (weak, nonatomic) id <PSManagerDelegate> managerDelegate;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIImageView *paylevenLogo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *paylevenLogoTopConstraint;
@property (weak, nonatomic) IBOutlet UILabel *paylevenCopyrightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameTextFieldTopConstriant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordTextFieldTopContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonHeightConstraint;

@property (nonatomic) NSDictionary *originalConstraintSizes;

@property (nonatomic) PSManager *manager;

@end

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@implementation PSLoginViewController

#pragma mark - Init

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]){
        _manager = [[PSManager alloc]init];
        _managerDelegate = _manager;
        _delegate = self;
    }
    return self;
}

- (void)dealloc {
    [self removeKeyBoardObserver];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self configureNavigationController];
    [self updateLoginButton];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
}

#pragma mark - ConfigureView

- (void)configureViewController {
    self.username.delegate = self;
    self.password.delegate = self;
    [self configureTextField:self.username];
    [self configureTextField:self.password];
    self.paylevenCopyrightLabel.text = [NSString stringWithFormat:@"payleven® %@", self.manager.currentYear.stringValue];
    self.originalConstraintSizes = @{
                                     @"paylevenLogoTopConstraint": @(self.paylevenLogoTopConstraint.constant),
                                     @"usernameTextFieldTopConstriant": @(self.usernameTextFieldTopConstriant.constant),
                                     @"loginButtonHeightConstraint": @(self.loginButtonHeightConstraint.constant),
                                     @"passwordTextFieldTopContraint": @(self.passwordTextFieldTopContraint.constant)
                                     };
    
    //FIXME: Remove auth parameters
    //self.username.text = @"info@payleven.de";
    //self.username.text = @"b@dg.er";
    //self.username.text = @"testeIT5@sharklasers.com";
    //self.username.text = @"mposuk@sharklasers.com"
    //self.username.text = @"mpospl@sharklasers.com";
    //self.username.text = @"testeIT5@sharklasers.com";
    
    self.username.text = @"testlive16@sharklasers.com";
    self.password.text = @"12345678";
}

- (void)configureNavigationController {
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = YES;
}

- (void)configureTextField:(UITextField *)textField {
    textField.layer.borderColor = self.manager.paylevenGrayColor.CGColor;
    textField.layer.borderWidth = 1.00;
    textField.layer.cornerRadius = 7.00;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 42)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - Login

- (IBAction)login:(id)sender {
    
    /**
     * Replace the name and password with the merchant username and password.
     *
     * You can register a merchant account here: https://payleven.com/
     */
    
    if(self.username.text.length > 0 && self.password.text.length > 0){
        [self performSegueWithIdentifier:LoginProcessSegue sender:self];
    }
}

- (void)updateLoginButton {
    if(self.username.text.length > 0 && self.password.text.length > 0){
        [self enableLoginButton];
    } else {
        [self disableLoginButton];
    }
}

- (void)enableLoginButton {
    self.loginButton.enabled = YES;
    self.loginButton.userInteractionEnabled = YES;
    self.loginButton.backgroundColor = self.manager.paylevenBlueColor;
    [self.loginButton addTarget:self action:@selector(methodTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.loginButton addTarget:self action:@selector(methodTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [self.loginButton addTarget:self action:@selector(methodTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
}

- (void)disableLoginButton {
    self.loginButton.enabled = NO;
    self.loginButton.userInteractionEnabled = NO;
    self.loginButton.backgroundColor = self.manager.paylevenGrayColor;
}

- (void)methodTouchDown:(id)sender {
    self.loginButton.alpha = 0.5;
}

- (void)methodTouchUpInside:(id)sender {
    self.loginButton.alpha = 1.0;
}

- (void)methodTouchUpOutside:(id)sender {
    self.loginButton.alpha = 1.0;
}

#pragma mark - PrepareForSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:LoginProcessSegue]) {
        PSLoginProcessViewController *loginProcessViewController = (PSLoginProcessViewController *)segue.destinationViewController;
        loginProcessViewController.delegate = self;
        loginProcessViewController.manager = self.manager;
        loginProcessViewController.username = self.username.text;
        loginProcessViewController.password = self.password.text;
    } else if ([segue.identifier isEqualToString:HomeScreenSegue]) {
        PSHomeViewController *homeViewController = (PSHomeViewController *)segue.destinationViewController;
        homeViewController.manager = self.manager;
    }
}

#pragma mark - Observers

- (void)addKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGRect keyboard = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [self updateloginButtonBottomConstraintWithHeight:keyboard.size.height];

    if([PSSystemDevice currentDeviceType] == PSDeviceType_IS_IPHONE_4_OR_LESS) {
        self.paylevenLogoTopConstraint.constant = 8.00;
        self.usernameTextFieldTopConstriant.constant = 8.00;
        self.loginButtonHeightConstraint.constant = 40.00;
        self.passwordTextFieldTopContraint.constant = 8.00;
    } else if ([PSSystemDevice currentDeviceType] == PSDeviceType_IS_IPHONE_5) {
        self.paylevenLogoTopConstraint.constant = 20.00;
        self.loginButtonHeightConstraint.constant = 50.00;
        self.usernameTextFieldTopConstriant.constant = 20.00;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [self updateloginButtonBottomConstraintWithHeight:0.00];
    self.paylevenLogoTopConstraint.constant = [self.originalConstraintSizes[@"paylevenLogoTopConstraint"] floatValue];
    self.usernameTextFieldTopConstriant.constant = [self.originalConstraintSizes[@"usernameTextFieldTopConstriant"] floatValue];
    self.loginButtonHeightConstraint.constant = [self.originalConstraintSizes[@"loginButtonHeightConstraint"] floatValue];
    self.passwordTextFieldTopContraint.constant = [self.originalConstraintSizes[@"passwordTextFieldTopContraint"] floatValue];
    [self updateLoginButton];
}

#pragma mark - LoginButton Constraint

- (void)updateloginButtonBottomConstraintWithHeight:(CGFloat)height {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.loginButtonBottomConstraint.constant = height;
    }];
    
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - Login error

- (void)presentAlertViewWithError:(NSError *)error {
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Login Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Login Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self)weakSelf = self;
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [alertViewController addAction:okAction];

        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

#pragma mark - AlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
     [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - LoginDelegate

- (void)loginViewControllerDidFinish:(PSLoginViewController *)loginViewController {
    [self.managerDelegate updateMerchantIdWithString:self.username.text];
    [loginViewController performSegueWithIdentifier:HomeScreenSegue sender:loginViewController.navigationController];
}

- (void)loginDidFailWithError:(NSError *)error {
    [self presentAlertViewWithError:error];
}

/**
 @brief This is defending the PSLoginDelegate should in case
 someone tries to override the delegate outside this class
 we check that the overriding class conforms to the protocol
 */
- (void)setDelegate:(id <PSLoginDelegate> )delegate
{
    if (delegate && ![delegate conformsToProtocol:@protocol(PSLoginDelegate)]) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object doesn't conform to the delegate protocol" userInfo:nil] raise];
    }
    _delegate = delegate;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string  isEqual:@"\n"]){
        [textField resignFirstResponder];
        if(self.username.text.length > 0 && self.password.text.length > 0){
            [self performSegueWithIdentifier:LoginProcessSegue sender:self];
        }
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self addKeyBoardObserver];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self observeTextField:textField];
    textField.layer.borderColor = self.manager.paylevenBlueColor.CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.layer.borderColor = self.manager.paylevenGrayColor.CGColor;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [textField resignFirstResponder];
}

#pragma mark - observeTextField

- (void)observeTextField:(UITextField *)textField
{
    __weak typeof(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:NSOperationQueuePriorityNormal usingBlock: ^(NSNotification *note) {
        UITextField *notificationTextField = note.object;
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (notificationTextField.text.length <= 0) {
            [strongSelf disableLoginButton];
        } else {
            [strongSelf updateLoginButton];
        }
    }];
}

@end
