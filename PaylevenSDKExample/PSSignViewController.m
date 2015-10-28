//
//  PSSignViewController.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Obi on 9/25/15.
//  Copyright © 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSSignViewController.h"
#import "PSSignatureDelegate.h"
#import "PSIdentifiers.h"
#import "PSManager.h"

@interface PSSignViewController ()

@property NSNumber *fingerDidMove;
@property CGPoint lastPoint1, lastPoint2, currentPoint;

@end

static void *PSSignatureContext = &PSSignatureContext;

@implementation PSSignViewController

#pragma mark - AwakeFromNib

- (void)awakeFromNib {
    [super awakeFromNib];
    self.signatureDelegate = self;
    _fingerDidMove = [NSNumber numberWithBool:NO];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(fingerDidMove)) options:NSKeyValueObservingOptionNew context:PSSignatureContext];
    [self.signatureImageView addObserver:self forKeyPath:NSStringFromSelector(@selector(image)) options:NSKeyValueObservingOptionNew context:PSSignatureContext];
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self clearCapturedSignatureImage];
    self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma mark - ConfigureViewController

- (void)configureViewController {
    self.amountLabel.text = self.amountString;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    UIFont *font = [UIFont fontWithName:@"MyriadPro-Semibold" size:18];
    [self.titleBarButtonItem setTitleTextAttributes:@{
                                                      NSFontAttributeName: font,
                                                      NSForegroundColorAttributeName: [UIColor colorWithRed:0.1568627451 green:0.2196078431 blue:0.2980392157 alpha:1]
                                                      } forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(fingerDidMove)) context:PSSignatureContext];
    [self.signatureImageView removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))  context:PSSignatureContext];
    self.signatureImageView.image = nil;
    self.caputuredSignatureImage = nil;
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(fingerDidMove)) options:NSKeyValueObservingOptionNew context:PSSignatureContext];
    [self.signatureImageView addObserver:self forKeyPath:NSStringFromSelector(@selector(image)) options:NSKeyValueObservingOptionNew context:PSSignatureContext];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(fingerDidMove)) context:PSSignatureContext];
    [self.signatureImageView removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))  context:PSSignatureContext];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.allObjects.firstObject;
    
    if(touch){
        self.fingerDidMove = [NSNumber numberWithBool:NO];
        self.currentPoint = [touch locationInView:self.signatureImageView];
        self.lastPoint1 = [touch previousLocationInView:self.signatureImageView];
        self.lastPoint2 = [touch previousLocationInView:self.signatureImageView];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.allObjects.firstObject;
    
    if(touch){
        self.fingerDidMove = [NSNumber numberWithBool:YES];
        self.lastPoint2 = self.lastPoint1;
        self.lastPoint1 = [touch previousLocationInView:self.signatureImageView];
        self.currentPoint = [touch locationInView:self.signatureImageView];
        /**
         * find mid points to be used for quadratic bezier curve
         */
        CGPoint middlePoint1 = [self middlePoint:self.lastPoint1 secondPoint:self.lastPoint2];
        CGPoint middlePoint2 = [self middlePoint:self.currentPoint secondPoint:self.lastPoint1];
        /**
         * Begin context with UIGraphicsBeginImageContextWithOptions and make sure
         * the opaque mode is set to false in other to remove the blurry shades on
         * retina device
         */
        UIGraphicsBeginImageContextWithOptions(self.signatureImageView.bounds.size, false, 0.0);
        /**
         * draw the entire image in the specified rectangle frame
         * using kCGBlendModeScreen for smoother lines on iPhone4
         */
        [self.signatureImageView.image drawInRect:CGRectMake(0, 0, self.signatureImageView.frame.size.width, self.signatureImageView.frame.size.height) blendMode:kCGBlendModeScreen alpha:1.0];
        
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
        /**
         * set line cap
         */
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        /**
         * set width
         */
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
        /**
         * set stroke color
         */
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        /**
         * set begin path
         */
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        /**
         * start a new sub-path from the middlePoint1
         */
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), middlePoint1.x, middlePoint1.y);
        /**
         * create quadratic Bézier curve from the current point
         * using a control point and an end point
         */
        CGContextAddQuadCurveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint1.x, self.lastPoint1.y, middlePoint2.x, middlePoint2.y);
        /**
         * set the miter limit for the joins of connected lines in a graphics context
         */
        CGContextSetMiterLimit(UIGraphicsGetCurrentContext(), 2.0);
        /**
         * paint a line along the current path
         */
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        /**
         * set the image based on the contents of the current bitmap-based graphics context
         */
        self.signatureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        /**
         * Give it back to the delegate
         */
        [self.signatureDelegate saveCaputuredSignatureImage:self.signatureImageView.image.CGImage];
        /**
         * End image context to remove graphic from stack
         */
        UIGraphicsEndImageContext();
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (touches.allObjects.firstObject && self.fingerDidMove.boolValue == NO) {
        if(self.signatureImageView.image) {
            self.fingerDidMove = [NSNumber numberWithBool:YES];
        }
        /**
         * Basically do the same thing as in the touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
         * but this time the CGContextMoveToPoint remains with the currentPoint in other to create a point
         */
        UIGraphicsBeginImageContextWithOptions(self.signatureImageView.bounds.size, false, 0.0);
        [self.signatureImageView.image drawInRect:CGRectMake(0, 0, self.signatureImageView.frame.size.width, self.signatureImageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.signatureImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.signatureDelegate saveCaputuredSignatureImage:self.signatureImageView.image.CGImage];
        UIGraphicsEndImageContext();
    }
    [super touchesEnded:touches withEvent:event];
    [self.signatureDelegate didFinishSigning];
}

-(IBAction)clearSignature:(id)sender {
    [self clearCapturedSignatureImage];
}

- (IBAction)cancel:(id)sender {
    if (self.completionBlock) {
        self.completionBlock(NO, nil);
    }
}

- (IBAction)pay:(id)sender {
    if (self.completionBlock) {
        self.completionBlock(YES, self.caputuredSignatureImage);
    }
}

#pragma mark - middlePoint

- (CGPoint)middlePoint:(CGPoint)firstPoint secondPoint:(CGPoint)secondPoint {
    return CGPointMake((firstPoint.x + secondPoint.x) / 2.0, (firstPoint.y + secondPoint.y) / 2.0);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && context == PSSignatureContext && [keyPath isEqualToString:NSStringFromSelector(@selector(fingerDidMove))]) {
        [self.signatureDelegate enableCancelBarButtonItemWithBool:self.fingerDidMove.boolValue];
    }
    
    if (object == self.signatureImageView && context == PSSignatureContext && [keyPath isEqualToString:NSStringFromSelector(@selector(image))]){
        if (self.signatureImageView.image) {
            self.signHereImageView.image = [UIImage imageNamed:PaylevenSignHereLine];
        } else {
            self.signHereImageView.image = [UIImage imageNamed:PaylevenSignHere];
        }
    }
}

#pragma mark - SignatureDelegate

- (void)enableCancelBarButtonItemWithBool:(BOOL)fingerDidMove {
    if(fingerDidMove){
        self.clearBarButtonItem.image = [UIImage imageNamed:PaylevenClear];
        self.clearBarButtonItem.enabled = YES;
        self.payButton.userInteractionEnabled = YES;
        self.payButton.enabled = YES;
        self.payButton.backgroundColor = self.manager.paylevenBlueBackgoundColor;
        self.signHereImageView.image = [UIImage imageNamed:PaylevenSignHereLine];
    }
}

- (void)presentAlertViewWithError:(NSError *)error {
    if([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Payment Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    } else {
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Payment Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
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

- (void)clearCapturedSignatureImage {
    self.caputuredSignatureImage = nil;
    self.signatureImageView.image = nil;
    self.clearBarButtonItem.image = [UIImage imageNamed:PaylevenClearDisabled];
    self.signHereImageView.image = [UIImage imageNamed:PaylevenSignHere];
    self.clearBarButtonItem.enabled = NO;
    self.payButton.userInteractionEnabled = NO;
    self.payButton.enabled = NO;
    self.payButton.backgroundColor = self.manager.paylevenGrayBackgoundColor;
}

- (void)saveCaputuredSignatureImage:(CGImageRef)image {
    self.caputuredSignatureImage = image;
}

- (void)dismissViewController {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didFinishSigning {
    //self.signatureImageView.image = nil;
}

@end
