//
//  PSSignatureImageViewTableViewCell.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import UIKit;
@protocol PSSignatureDelegate;

@interface PSSignatureImageViewTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *cellImageView;
@property (nonatomic, weak) IBOutlet UIImageView *cellSignHereImageView;
@property (nonatomic) id <PSSignatureDelegate> signatureDelegate;

@end
