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
    APDAtePickerDayStatusSelected,
    APDAtePickerDayStatusNonSelected
} APDatePickerDayStatus;

@protocol APDatePickerDayCellDelegate;

@interface APDatePickerDayCell : UICollectionViewCell

@property (assign, nonatomic) APDatePickerDayStatus status;
@property (weak  , nonatomic) id<APDatePickerDayCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIView *dayFrameView;
@property (strong, nonatomic) IBOutlet UILabel *dayNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayNameLabel;

@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *selectedBorderColor;
@property (strong, nonatomic) UIColor *nonSelectedColor;
@property (strong, nonatomic) UIColor *nonSelectedBorderColor;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) NSDate *date;

-(void) cellStatusChange:(APDatePickerDayStatus) status;

@end

@protocol APDatePickerDayCellDelegate <NSObject>

-(void) cellDidChangeState:(APDatePickerDayCell *) cell;

@end
