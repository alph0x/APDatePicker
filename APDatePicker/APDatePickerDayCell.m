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
    switch (status) {
        case APDAtePickerDayStatusSelected:{
            self.dayFrameView.layer.cornerRadius = 5.f;
            self.dayFrameView.layer.borderWidth = 1.f;
            self.dayFrameView.layer.borderColor = _COLOR_LIGHT_GRAY.CGColor;
        }
            break;
            
        default:{
            self.dayFrameView.layer.cornerRadius = 5.f;
            self.dayFrameView.layer.borderWidth = 1.f;
            self.dayFrameView.layer.borderColor = _COLOR_LIGHT_GRAY.CGColor;
        }
            break;
    }
    [self.delegate cellDidChangeState:self];
}

@end
