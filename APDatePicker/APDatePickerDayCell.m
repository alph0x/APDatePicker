//
//  APDatePickerDayCell.m
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import "APDatePickerDayCell.h"



@implementation APDatePickerDayCell {
    
}

- (void)awakeFromNib {
    
}

-(void) cellStatusChange:(APDatePickerDayStatus) status {
    
    self.status = status;
    self.dayFrameView.layer.cornerRadius = 5.f;
    self.dayFrameView.layer.borderWidth = 1.f;
    
    switch (status) {
        case APDAtePickerDayStatusSelected:{
            self.dayFrameView.layer.borderColor = _COLOR_DARK_GREEN.CGColor;
            [self.dayFrameView setBackgroundColor:_COLOR_GREEN];
            [self.dayNumberLabel setTextColor:_COLOR_WHITE];
        }
            break;
            
        default:{
            self.dayFrameView.layer.borderColor = _COLOR_LIGHT_GRAY.CGColor;
            [self.dayFrameView setBackgroundColor:_COLOR_WHITE];
            [self.dayNumberLabel setTextColor:_COLOR_DARK_GRAY];
        }
            break;
    }
    [self.delegate cellDidChangeState:self];
}

@end
