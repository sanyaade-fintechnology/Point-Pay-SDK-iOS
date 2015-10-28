//
//  PSHomeTableViewDataSource.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/12/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSHomeTableViewDataSource.h"
#import "PSOption.h"
#import "PSIdentifiers.h"
#import "PSHomeTableViewCell.h"

@interface PSHomeTableViewDataSource()

@property (nonatomic) NSArray *options;

@end

@implementation PSHomeTableViewDataSource

- (NSArray *)options {

    if (_options) {
        return _options;
    }
    
    PSOption *payment = [[PSOption alloc]initWithDescription:@"Payment"
                                                       image:[UIImage imageNamed:PaylevenCoins]];
    PSOption *refund = [[PSOption alloc]initWithDescription:@"Refund"
                                                      image:[UIImage imageNamed:PaylevenRefund]];
    PSOption *terminal = [[PSOption alloc]initWithDescription:@"Terminals"
                                                        image:[UIImage imageNamed:PaylevenTerminal]];
    PSOption *logout = [[PSOption alloc]initWithDescription:@"Log out"
                                                      image:[UIImage imageNamed:PaylevenLogout]];
    _options = @[payment, refund, terminal, logout];
    
    return _options;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView homeTableViewCellForRowAtIndexPath:indexPath];
}

- (PSHomeTableViewCell *)tableView:(UITableView *)tableView homeTableViewCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PSHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HomeTableViewCell forIndexPath:indexPath];
    PSOption *option = self.options[indexPath.row];
    cell.cellDescriptionLabel.text = option.aDescription;
    cell.cellImageView.image = option.image;
    
    return cell;
}



@end
