//
//  APDatePicker.h
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APDatePickerStyleSheet.h"
#import "APDatePickerDayCell.h"
#import "APDatePickerMonthCell.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@protocol APDatePickerDelegate;

@interface APDatePicker : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak  , nonatomic) id<APDatePickerDelegate>delegate;

@property (strong, nonatomic) NSDate *startingDate;
@property (strong, nonatomic) NSNumber *numberOfDays;

@property (strong, nonatomic) NSArray *months;
@property (strong, nonatomic) NSArray *days;

/**********************
 * Month Collection Components
 **********************/
@property (strong, nonatomic) IBOutlet UIButton *previousMonthButton;
@property (strong, nonatomic) IBOutlet UICollectionView *monthCollection;
@property (strong, nonatomic) IBOutlet UIButton *nextMonthButton;

/**********************
 * Day Collection Components
 **********************/
@property (strong, nonatomic) IBOutlet UIButton *previousWeekButton;
@property (strong, nonatomic) IBOutlet UIButton *nextWeekButton;
@property (strong, nonatomic) IBOutlet UICollectionView *daysCollection;

/**********************
 * Colors Parameters
 **********************/

@property (strong, nonatomic) UIColor *selectedColor;
@property (strong, nonatomic) UIColor *selectedBorderColor;
@property (strong, nonatomic) UIColor *nonSelectedColor;
@property (strong, nonatomic) UIColor *nonSelectedBorderColor;


+(instancetype) initAPDatePickerStartingFromDate:(NSDate *) day forDays:(NSNumber *) numberOfDays; 

@end

@protocol APDatePickerDelegate <NSObject>

-(void) APDatePickerSelectedDays:(NSArray *) selectedDays;

@end