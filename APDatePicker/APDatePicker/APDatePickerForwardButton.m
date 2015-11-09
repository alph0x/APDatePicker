//
//  APDatePickerForwardButton.m
//  APDatePicker
//
//  Created by Alfredo Perez on 10/28/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import "APDatePickerForwardButton.h"

@implementation APDatePickerForwardButton

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.686 green: 0.686 blue: 0.686 alpha: 1];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(10, 7)];
    [bezierPath addLineToPoint: CGPointMake(18, 14)];
    [bezierPath addLineToPoint: CGPointMake(10, 21)];
    [color setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
}

@end
