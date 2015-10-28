//
//  PSSignatureImageViewTableViewCell.m
//  PaylevenSDKInternalApp
//
//  Created by Bob Godwin Obi on 8/14/15.
//  Copyright (c) 2015 Payleven Holding GmbH. All rights reserved.
//

#import "PSSignatureImageViewTableViewCell.h"
#import "PSSignatureDelegate.h"
#import "PSIdentifiers.h"

@interface PSSignatureImageViewTableViewCell()

@property NSNumber *fingerDidMove;
@property CGPoint lastPoint1, lastPoint2, currentPoint;

@end

static void *PSSignatureContext = &PSSignatureContext;

@implementation PSSignatureImageViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.separatorInset = UIEdgeInsetsZero;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
    
    _fingerDidMove = [NSNumber numberWithBool:NO];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(fingerDidMove)) options:NSKeyValueObservingOptionNew context:PSSignatureContext];
    [self.cellImageView addObserver:self forKeyPath:NSStringFromSelector(@selector(image)) options:NSKeyValueObservingOptionNew context:PSSignatureContext];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.allObjects.firstObject;
    
    if(touch){
        self.fingerDidMove = [NSNumber numberWithBool:NO];
        self.currentPoint = [touch locationInView:self.cellImageView];
        self.lastPoint1 = [touch previousLocationInView:self.cellImageView];
        self.lastPoint2 = [touch previousLocationInView:self.cellImageView];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.allObjects.firstObject;
    
    if(touch){
        self.fingerDidMove = [NSNumber numberWithBool:YES];
        self.lastPoint2 = self.lastPoint1;
        self.lastPoint1 = [touch previousLocationInView:self.cellImageView];
        self.currentPoint = [touch locationInView:self.cellImageView];
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
        UIGraphicsBeginImageContextWithOptions(self.cellImageView.bounds.size, false, 0.0);
        /**
         * draw the entire image in the specified rectangle frame
         * using kCGBlendModeScreen for smoother lines on iPhone4
         */
        [self.cellImageView.image drawInRect:CGRectMake(0, 0, self.cellImageView.frame.size.width, self.cellImageView.frame.size.height) blendMode:kCGBlendModeScreen alpha:1.0];
        
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
        self.cellImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        /**
         * Give it back to the delegate
         */
        [self.signatureDelegate saveCaputuredSignatureImage:self.cellImageView.image.CGImage];
        /**
         * End image context to remove graphic from stack
         */
        UIGraphicsEndImageContext();
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (touches.allObjects.firstObject && self.fingerDidMove.boolValue == NO) {
        if(self.cellImageView.image) {
            self.fingerDidMove = [NSNumber numberWithBool:YES];
        }
        /**
         * Basically do the same thing as in the touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
         * but this time the CGContextMoveToPoint remains with the currentPoint in other to create a point
         */
        UIGraphicsBeginImageContextWithOptions(self.cellImageView.bounds.size, false, 0.0);
        [self.cellImageView.image drawInRect:CGRectMake(0, 0, self.cellImageView.frame.size.width, self.cellImageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.currentPoint.x, self.currentPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.cellImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.signatureDelegate saveCaputuredSignatureImage:self.cellImageView.image.CGImage];
        UIGraphicsEndImageContext();
    }
    [super touchesEnded:touches withEvent:event];
    [self.signatureDelegate didFinishSigning];
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
    
    if (object == self.cellImageView && context == PSSignatureContext && [keyPath isEqualToString:NSStringFromSelector(@selector(image))]){
        if (self.cellImageView.image) {
            self.cellSignHereImageView.image = [UIImage imageNamed:PaylevenSignHereLine];
        } else {
            self.cellSignHereImageView.image = [UIImage imageNamed:PaylevenSignHere];
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(fingerDidMove)) context:PSSignatureContext];
    [self.cellImageView removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))  context:PSSignatureContext];
}

@end
