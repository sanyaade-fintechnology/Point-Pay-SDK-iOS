//
//  ADYBarcodeConstants.h
//  Pods
//
//  Created by Taras Kalapun on 7/27/15.
//
//

#ifndef AdyenPOSLib_ADYBarcodeConstants_h
#define AdyenPOSLib_ADYBarcodeConstants_h

/** @name Barcode */

/** 
 
 ## Barcode scanning
 
 To receive the barcode implement the following:
 
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(barcodeReceived:)
        name:ADYNotificationBarcodeReceived
        object:nil];
 
 
    - (void)barcodeReceived:(NSNotification *)notification {
        NSString *barcode = notification.object;
        NSString *symbology = notification.userInfo[@"symbology”]
        ADYBarcodeType barcodeType = [notification.userInfo[@"type"] integerValue];
    }

 
 ## Using Soft button barcode
 

    UIButton *barcodeBtn = [[UIButton alloc] init];
    [barcodeBtn setTitle:@"Barcode" forState:UIControlStateNormal];
    [barcodeBtn addTarget:self action:@selector(startBarcodeScan:) forControlEvents:UIControlEventTouchDown];
    [barcodeBtn addTarget:self action:@selector(stopBarcodeScan:) forControlEvents:UIControlEventTouchUpInside];
 
    - (IBAction)startBarcodeScan:(id)sender {
        ADYDevice *device = _selectedDeviceManager.selectedDevice;
        [device startBarcodeScan];
    }
 
    - (IBAction)stopBarcodeScan:(id)sender {
        ADYDevice *device = _selectedDeviceManager.selectedDevice;
        [device stopBarcodeScan];
    }
 
 */

typedef NS_ENUM(NSInteger, ADYBarcodeType) {
    ADYBarcodeTypeNA,
    ADYBarcodeTypeCode39,
    ADYBarcodeTypeCodabar,
    ADYBarcodeTypeCode128,
    ADYBarcodeTypeD25,
    ADYBarcodeTypeIATA,
    ADYBarcodeTypeITF,
    ADYBarcodeTypeCode93,
    ADYBarcodeTypeUPCA,
    ADYBarcodeTypeUPCE,
    ADYBarcodeTypeEAN8,
    ADYBarcodeTypeEAN13,
    ADYBarcodeTypeCode11,
    ADYBarcodeTypeMSI,
    ADYBarcodeTypeEAN128,
    ADYBarcodeTypeUPCE1,
    ADYBarcodeTypePDF417,
    ADYBarcodeTypeCode39FULLASCII,
    ADYBarcodeTypeTrioptic,
    ADYBarcodeTypeBookland,
    ADYBarcodeTypeCouponCode,
    ADYBarcodeTypeISBT128,
    ADYBarcodeTypeMicroPDF,
    ADYBarcodeTypeDataMatrix,
    ADYBarcodeTypeQRCode,
    ADYBarcodeTypePostnetUS,
    ADYBarcodeTypePlanetUS,
    ADYBarcodeTypeCode32,
    ADYBarcodeTypeISBT128Concat,
    ADYBarcodeTypePostalJapan,
    ADYBarcodeTypePostalAustralia,
    ADYBarcodeTypePostalDutch,
    ADYBarcodeTypeMaxicode,
    ADYBarcodeTypePostbarCA,
    ADYBarcodeTypePostalUK,
    ADYBarcodeTypeMacroPDF417,
    ADYBarcodeTypeRSS14,
    ADYBarcodeTypeRSSLimited,
    ADYBarcodeTypeRSSExpanded,
    ADYBarcodeTypeScanletWebcode,
    ADYBarcodeTypeCueCATCode,
    ADYBarcodeTypeUPCA_2,
    ADYBarcodeTypeUPCE_2,
    ADYBarcodeTypeEAN8_2,
    ADYBarcodeTypeEAN13_2,
    ADYBarcodeTypeUPCE1_2,
    ADYBarcodeTypeCompositeCCA_EAN128,
    ADYBarcodeTypeCompositeCCA_EAN13,
    ADYBarcodeTypeCompositeCCA_EAN8,
    ADYBarcodeTypeCompositeCCA_RSSExpand,
    ADYBarcodeTypeCompositeCCA_RSSLimit,
    ADYBarcodeTypeCompositeCCA_RSS14,
    ADYBarcodeTypeCompositeCCA_UPCA,
    ADYBarcodeTypeCompositeCCA_UPCE,
    ADYBarcodeTypeCompositeCCC_EAN128,
    ADYBarcodeTypeTLC39,
    ADYBarcodeTypeCompositeCCB_EAN128,
    ADYBarcodeTypeCompositeCCB_EAN13,
    ADYBarcodeTypeCompositeCCB_EAN8,
    ADYBarcodeTypeCompositeCCB_RSSExpand,
    ADYBarcodeTypeCompositeCCB_RSSLimit,
    ADYBarcodeTypeCompositeCCB_RSS14,
    ADYBarcodeTypeCompositeCCB_UPCA,
    ADYBarcodeTypeCompositeCCB_UPCE,
    ADYBarcodeTypeKOREAN3of5,
    ADYBarcodeTypeUPCA_5,
    ADYBarcodeTypeUPCE_5,
    ADYBarcodeTypeEAN8_5,
    ADYBarcodeTypeEAN13_5,
    ADYBarcodeTypeUPCE1_5,
    ADYBarcodeTypeMacroMicroPDFADYBarcodeType
};

#endif
