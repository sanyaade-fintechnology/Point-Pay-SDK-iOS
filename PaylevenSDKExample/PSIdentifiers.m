//
//  PSIdentifiers.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSIdentifiers.h"

@implementation PSIdentifiers

#pragma mark - Images

NSString *const PaylevenAdd = @"PaylevenAdd";
NSString *const PaylevenCanceled = @"PaylevenCanceled";
NSString *const PaylevenClear = @"PaylevenClear";
NSString *const PaylevenClearDisabled = @"PaylevenClearDisabled";
NSString *const PaylevenCNP = @"PaylevenCNP";
NSString *const PaylevenCNPSelected = @"PaylevenCNPSelected";
NSString *const PaylevenCoins = @"PaylevenCoins";
NSString *const PaylevenList = @"PaylevenList";
NSString *const PaylevenLogo = @"PaylevenLogo";
NSString *const PaylevenLogout = @"PaylevenLogout";
NSString *const PaylevenReceipt = @"PaylevenReceipt";
NSString *const PaylevenRefresh = @"PaylevenRefresh";
NSString *const PaylevenRefund = @"PaylevenRefund";
NSString *const PaylevenSuccess = @"PaylevenSuccess";
NSString *const PaylevenTerminal = @"PaylevenTerminal";
NSString *const PaylevenTerminalWireFrame = @"PaylevenTerminalWireFrame";
NSString *const PaylevenErase = @"PaylevenErase";
NSString *const PaylevenTick = @"PaylevenTick";
NSString *const PaylevenTriangle = @"PaylevenTriangle";
NSString *const PaylevenZigZag = @"PaylevenZigZag";
NSString *const PaylevenLargeTerminal = @"PaylevenLargeTerminal";
NSString *const PaylevenMissingTerminal = @"PaylevenMissingTerminal";
NSString *const PaylevenSignHere = @"PaylevenSignHere";
NSString *const PaylevenSignHereLine = @"PaylevenSignHereLine";
NSString *const PaylevenManualRefund = @"PaylevenManualRefund";

#pragma  mark - APIKEY

NSString *const PalevenAPIKey = @"PalevenAPIKey";

#pragma mark - Segues

NSString *const LoginProcessSegue = @"LoginProcessSegue";
NSString *const LogoutProcessSegue = @"LogoutProcessSegue";
NSString *const HomeScreenSegue = @"HomeScreenSegue";
NSString *const PaymentViewSegue = @"PaymentViewSegue";
NSString *const PaymentProcessSegue = @"PaymentProcessSegue";
NSString *const RefundProcessSegue = @"RefundProcessSegue";
NSString *const PaymentResultViewSegue = @"PaymentResultViewSegue";
NSString *const SignatureSegue = @"SignatureSegue";
NSString *const RefundViewSegue = @"RefundViewSegue";
NSString *const RefundResultViewSegue = @"RefundResultViewSegue";
NSString *const ReceiptSegue = @"ReceiptSegue";
NSString *const TerminalSegue = @"TerminalSegue";
NSString *const TerminalMissingSegue = @"TerminalMissingSegue";
NSString *const PaymentTerminalSegue = @"PaymentTerminalSegue";
NSString *const PaymentTerminalMissingSegue = @"PaymentTerminalMissingSegue";
NSString *const UnwindTerminalSegue = @"UnwindTerminalSegue";
NSString *const UnwindFromMissingTerminalSegue = @"UnwindFromMissingTerminalSegue";
NSString *const DeviceConfigurationSegue = @"DeviceConfigurationSegue";
NSString *const UnwindFromDeviceConfigurationSegue = @"UnwindFromDeviceConfigurationSegue";
NSString *const UnwindPaymentResultViewSegue = @"UnwindPaymentResultViewSegue";
NSString *const UnwindLatestPaymentSegue = @"UnwindLatestPaymentSegue";
NSString *const UnwindRefundResultViewSegue = @"UnwindRefundResultViewSegue";
NSString *const TemporaryAccessToPaymentSegue = @"TemporaryAccessToPaymentSegue";
NSString *const LatestPaymentSegue = @"LatestPaymentSegue";
NSString *const LatestPaymentMissingSegue = @"LatestPaymentMissingSegue";
NSString *const ManualRefundSegue = @"ManualRefundSegue";

#pragma mark - SortKeys

NSString *const kDefault = @"index";
NSString *const kMerchantId = @"merchantId";
NSString *const kPaymentId = @"paymentId";

#pragma mark - TableViewCells

NSString *const HomeTableViewCell = @"HomeTableViewCell";
NSString *const SignatureDescriptionTableViewCell = @"SignatureDescriptionTableViewCell";
NSString *const SignatureImageViewTableViewCell = @"SignatureImageViewTableViewCell";
NSString *const TerminalTableViewCell = @"TerminalTableViewCell";
NSString *const LatestPaymentTableViewCell = @"LatestPaymentTableViewCell";

#pragma mark - Controllers

NSString *const SignatureTableViewController = @"SignatureTableViewController";
NSString *const SignViewController = @"SignViewController";

#pragma  mark - Amount

const int MIN_AMOUNT = 100;
const int MAX_AMOUNT = 1999999;

@end