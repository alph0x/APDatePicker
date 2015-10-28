//
//  APDatePickerBackwardButton.m
//  APDatePicker
//
//  Created by Alfredo Perez on 10/28/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import "APDatePickerBackwardButton.h"

@implementation APDatePickerBackwardButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.686 green: 0.686 blue: 0.686 alpha: 1];
    
    //// Bezier Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 14, 14);
    CGContextRotateCTM(context, 180 * M_PI / 180);
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(-4, -7)];
    [bezierPath addLineToPoint: CGPointMake(4, 0)];
    [bezierPath addLineToPoint: CGPointMake(-4, 7)];
    [color setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    CGContextRestoreGState(context);

}


@end
