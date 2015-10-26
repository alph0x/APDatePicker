//
//  APDatePickerDayCell.h
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APDatePicker.h"

typedef enum {
    APDAtePickerDayStatusNonSelected,
    APDAtePickerDayStatusSelected
} APDatePickerDayStatus;

@protocol APDatePickerDayCellDelegate;

@interface APDatePickerDayCell : UICollectionViewCell

@property (assign, nonatomic) APDatePickerDayStatus status;
@property (weak  , nonatomic) id<APDatePickerDayCellDelegate>delegate;

@property (retain, nonatomic) IBOutlet UIView *dayFrameView;
@property (retain, nonatomic) IBOutlet UILabel *dayNumberLabel;
@property (retain, nonatomic) IBOutlet UILabel *dayNameLabel;

@property (retain, nonatomic) UIColor *selectedColor;
@property (retain, nonatomic) UIColor *selectedBorderColor;
@property (retain, nonatomic) UIColor *nonSelectedColor;
@property (retain, nonatomic) UIColor *nonSelectedBorderColor;
@property (retain, nonatomic) UIFont *font;
@property (retain, nonatomic) NSDate *date;

-(void) cellStatusChange:(APDatePickerDayStatus) status;

@end

@protocol APDatePickerDayCellDelegate <NSObject>

-(void) cellDidChangeState:(APDatePickerDayCell *) cell;

@end
