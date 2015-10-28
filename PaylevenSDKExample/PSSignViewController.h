//
//  PSSignViewController.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Obi on 9/25/15.
//  Copyright © 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@class PSManager;
#import "PSSignatureDelegate.h"

@interface PSSignViewController : UIViewController<PSSignatureDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *signatureImageView;
@property (nonatomic, weak) IBOutlet UIImageView *signHereImageView;
@property (nonatomic) id <PSSignatureDelegate> signatureDelegate;
@property (nonatomic, weak) PSManager *manager;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *clearBarButtonItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *cancleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (nonatomic) CGImageRef caputuredSignatureImage;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UIButton *payButton;
@property (nonatomic) NSString *amountString;

@property(copy) void (^completionBlock)(BOOL confirm, CGImageRef caputuredSignatureImage);

@end
