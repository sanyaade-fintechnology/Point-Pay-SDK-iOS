//
//  PSLatestPaymentsTableViewDataSource.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/17/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSLatestPaymentsTableViewDataSource.h"
#import "PSLatestPaymentsViewController.h"
#import "PSLatestPaymentsTableViewCell.h"
#import "PSManager.h"
#import "PSIdentifiers.h"
#import "PSPayment.h"
#import "PSFormatter.h"

@interface PSLatestPaymentsTableViewDataSource ()

@property (nonnull, nonatomic) PSFormatter *formatter;
@property (nonnull, nonatomic) NSArray *mockPayments;

@end

@implementation PSLatestPaymentsTableViewDataSource

#pragma mark - Lazy initializzation

- (PSFormatter *)formatter {
    if (_formatter){
        return _formatter;
    }
    
    _formatter = [[PSFormatter alloc]init];
    return _formatter;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sections = self.fetchedResultController.sections;
    id <NSFetchedResultsSectionInfo> sectionInfo = sections[section];
    
    if ([sectionInfo numberOfObjects] == 0) {
        self.latestPaymentsTableViewController.noRefundView.hidden = NO;
        tableView.hidden = YES;
    } else {
        self.latestPaymentsTableViewController.noRefundView.hidden = YES;
        tableView.hidden = NO;
    }
    
    
     return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.fetchedResultController.sections) {
        return self.fetchedResultController.sections.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self tableView:tableView latestPaymentsCellForRowAtIndexPath:indexPath];
}

- (PSLatestPaymentsTableViewCell *)tableView:(UITableView *)tableView latestPaymentsCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PSLatestPaymentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LatestPaymentTableViewCell forIndexPath:indexPath];
    PSPayment *payment = [self.fetchedResultController objectAtIndexPath:indexPath];
    cell.paymentIdentifierLabel.text = payment.paymentId;
    cell.paymentDateLabel.text = [self stringDateAndTime:payment.date];
    cell.paymentAmountLabel.text = [self formatCurrencyWithAmount:payment.remainingAmount localIdentifier:[self localIdentifierForCurrency:payment.currency]];

    return cell;
}

#pragma mark - Helper methods

- (NSString *)stringDateAndTime:(NSDate *)date {
    self.formatter.dateFormatter.locale = [NSLocale currentLocale];
    self.formatter.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.formatter.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [self.formatter.dateFormatter stringFromDate:date];
}

- (NSString *)formatCurrencyWithAmount:(NSNumber *)amount localIdentifier:(NSString *)localIdentifier {
    self.formatter.currencyFormatter.locale = [NSLocale localeWithLocaleIdentifier:localIdentifier];
    return [self.formatter.currencyFormatter stringFromNumber:amount];
}

- (NSString *)localIdentifierForCurrency:(NSString *)currency {
    if ([currency isEqualToString:@"EUR"]) {
        return @"de_DE";
    } else if ([currency isEqualToString:@"GBP"]) {
        return @"en_GB";
    } else if ([currency isEqualToString:@"PLN"]) {
        return @"pl_PL";
    }
    return nil;
}

@end
