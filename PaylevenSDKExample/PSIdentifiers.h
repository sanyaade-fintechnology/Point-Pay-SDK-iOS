//
//  PSIdentifiers.h
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/11/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

@import Foundation;

@interface PSIdentifiers : NSObject

#pragma mark - Images

FOUNDATION_EXPORT NSString *__nonnull const PaylevenAdd;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenCanceled;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenClear;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenClearDisabled;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenCNP;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenCNPSelected;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenCoins;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenList;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenLogo;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenLogout;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenReceipt;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenRefresh;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenRefund;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenSuccess;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenTerminal;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenTerminalWireFrame;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenErase;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenTick;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenTriangle;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenZigZag;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenLargeTerminal;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenSignHere;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenSignHereLine;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenMissingTerminal;
FOUNDATION_EXPORT NSString *__nonnull const PaylevenManualRefund;

#pragma mark - APIKEY

FOUNDATION_EXPORT NSString *__nonnull const PalevenAPIKey;

#pragma mark - Segues

FOUNDATION_EXPORT NSString *__nonnull const LoginProcessSegue;
FOUNDATION_EXPORT NSString *__nonnull const LogoutProcessSegue;
FOUNDATION_EXPORT NSString *__nonnull const HomeScreenSegue;
FOUNDATION_EXPORT NSString *__nonnull const PaymentViewSegue;
FOUNDATION_EXPORT NSString *__nonnull const PaymentProcessSegue;
FOUNDATION_EXPORT NSString *__nonnull const RefundProcessSegue;
FOUNDATION_EXPORT NSString *__nonnull const PaymentResultViewSegue;
FOUNDATION_EXPORT NSString *__nonnull const SignatureSegue;
FOUNDATION_EXPORT NSString *__nonnull const RefundViewSegue;
FOUNDATION_EXPORT NSString *__nonnull const RefundResultViewSegue;
FOUNDATION_EXPORT NSString *__nonnull const ReceiptSegue;
FOUNDATION_EXPORT NSString *__nonnull const TerminalSegue;
FOUNDATION_EXPORT NSString *__nonnull const TerminalMissingSegue;
FOUNDATION_EXPORT NSString *__nonnull const PaymentTerminalSegue;
FOUNDATION_EXPORT NSString *__nonnull const PaymentTerminalMissingSegue;
FOUNDATION_EXPORT NSString *__nonnull const UnwindTerminalSegue;
FOUNDATION_EXPORT NSString *__nonnull const DeviceConfigurationSegue;
FOUNDATION_EXPORT NSString *__nonnull const UnwindFromDeviceConfigurationSegue;
FOUNDATION_EXPORT NSString *__nonnull const UnwindPaymentResultViewSegue;
FOUNDATION_EXPORT NSString *__nonnull const UnwindLatestPaymentSegue;
FOUNDATION_EXPORT NSString *__nonnull const UnwindFromMissingTerminalSegue;
FOUNDATION_EXPORT NSString *__nonnull const UnwindRefundResultViewSegue;
FOUNDATION_EXPORT NSString *__nonnull const TemporaryAccessToPaymentSegue;
FOUNDATION_EXPORT NSString *__nonnull const LatestPaymentSegue;
FOUNDATION_EXPORT NSString *__nonnull const LatestPaymentMissingSegue;
FOUNDATION_EXPORT NSString *__nonnull const ManualRefundSegue;

#pragma mark - SortKeys

FOUNDATION_EXPORT NSString *__nonnull const kDefault;
FOUNDATION_EXPORT NSString *__nonnull const kMerchantId;
FOUNDATION_EXPORT NSString *__nonnull const kPaymentId;

#pragma mark - TableViewCells

FOUNDATION_EXPORT NSString *__nonnull const HomeTableViewCell;
FOUNDATION_EXPORT NSString *__nonnull const SignatureDescriptionTableViewCell;
FOUNDATION_EXPORT NSString *__nonnull const SignatureImageViewTableViewCell;
FOUNDATION_EXPORT NSString *__nonnull const TerminalTableViewCell;
FOUNDATION_EXPORT NSString *__nonnull const LatestPaymentTableViewCell;

#pragma mark - Controllers

FOUNDATION_EXPORT NSString *__nonnull const SignatureTableViewController;
FOUNDATION_EXPORT NSString *__nonnull const SignViewController;

#pragma mark - Amount
/**
 * we are using extern for C types and FOUNDATION_EXPORT for ObjC
 */

extern const int MIN_AMOUNT;
extern const int MAX_AMOUNT;

@end
