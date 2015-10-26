//
//  APDatePicker.m
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import "APDatePicker.h"

#define TODAY [NSDate new]
#define MONTH [NSNumber numberWithInt:30]

@interface APDatePicker () {
    NSCalendar *calendar;
    NSDateComponents *offset;
    NSDateFormatter *monthFormat;
    NSDateFormatter *dayNumberFormat;
    NSDateFormatter *dayShortNameFormat;
    NSMutableArray *selectedDays;
}

@end

@implementation APDatePicker

- (void)viewDidLoad {
    [super viewDidLoad];
    [self prepareArrayAndDatesForView];
    [self.daysCollection setDelegate:self];
    [self.daysCollection setDataSource:self];
    [self.monthCollection setDelegate:self];
    [self.monthCollection setDataSource:self];
    
    
    
    
}

- (void) initDateFormatters {
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    monthFormat = [[NSDateFormatter alloc] init];
    [monthFormat setLocale:usLocale];
    [monthFormat setDateFormat:@"MMMM YYYY"];
    dayNumberFormat = [[NSDateFormatter alloc] init];
    [dayNumberFormat setLocale:usLocale];
    [dayNumberFormat setDateFormat:@"dd"];
    dayShortNameFormat = [[NSDateFormatter alloc] init];
    [dayShortNameFormat setLocale:usLocale];
    [dayShortNameFormat setDateFormat:@"EEE"];
    
    
    
    
}

- (void)prepareArrayAndDatesForView {
    [self initDateFormatters];
    if (!self.startingDate) { //if there is no starting Date, starting date will be today.
        self.startingDate = TODAY; 
    }
    if (!self.numberOfDays) { //if there is no number ofd
        self.numberOfDays = MONTH;
    }
    self.days = [self getArrayOfDays:self.numberOfDays startingFromDate:self.startingDate];
    self.months = [self getArrayOfMonthsFromDays:self.days];
    selectedDays = [NSMutableArray arrayWithObject:self.startingDate];
    [self.monthCollection reloadData];
}

- (NSArray *) getArrayOfMonthsFromDays:(NSArray *) daysArray {
    NSMutableArray *arrayOfMonths = [NSMutableArray arrayWithObject:[daysArray firstObject]];
    calendar = [NSCalendar currentCalendar];
    offset = [[NSDateComponents alloc] init];
    for (int i = 1; i < [daysArray count]; i++) {
        [offset setMonth:i];
        NSDate *nextMonth = [calendar dateByAddingComponents:offset toDate:[daysArray objectAtIndex:i] options:0];
        if ([arrayOfMonths lastObject] != nextMonth) {
            [arrayOfMonths addObject:nextMonth];
        }
    }
    
    
    return arrayOfMonths;
}

- (NSArray *) getArrayOfDays:(NSNumber *) numberOfDays startingFromDate:(NSDate *) startingDate {
    NSMutableArray *arrayOfDays = [NSMutableArray arrayWithObject:startingDate];
    startingDate=[NSDate date];calendar = [NSCalendar currentCalendar];
    offset = [[NSDateComponents alloc] init];
    for (int i = 1; i < [numberOfDays intValue]; i++) {
        [offset setDay:i];
        NSDate *nextDay = [calendar dateByAddingComponents:offset toDate:startingDate options:0];
        [arrayOfDays addObject:nextDay];
    }
    
    return arrayOfDays;
}

#pragma mark UICollectionView Delegates
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
    if (collectionView == self.daysCollection) {
        size = CGSizeMake(38, 49);
    }else if (collectionView == self.monthCollection) {
        size = CGSizeMake(266, 28);
    }
    return size;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.daysCollection) {
        [self.daysCollection scrollToItemAtIndexPath:indexPath atScrollPosition:10 animated:YES];
        APDatePickerDayCell *dayCell = (APDatePickerDayCell *)[collectionView cellForItemAtIndexPath:indexPath];
        APDatePickerDayStatus newStatus = dayCell.status == APDAtePickerDayStatusSelected ? APDAtePickerDayStatusNonSelected:APDAtePickerDayStatusSelected;
        if (newStatus == APDAtePickerDayStatusSelected) {
            [selectedDays addObject:dayCell.date];
        }else {
            [selectedDays removeObject:dayCell.date];
        }
        [dayCell cellStatusChange:newStatus];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger items = [self.months count];
    if (collectionView == self.daysCollection) {
        items = [self.days count];
    }
    
    return items;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
        if (collectionView == self.daysCollection) {
            NSDate *day = [self.days objectAtIndex:indexPath.row];
            [self.daysCollection registerNib:[UINib nibWithNibName:@"APDatePickerDayCell" bundle:nil] forCellWithReuseIdentifier:@"dayCell"];
            APDatePickerDayCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
            dayCell.date = day;
            [dayCell.dayNumberLabel setText:[dayNumberFormat stringFromDate:day]];
            [dayCell.dayNameLabel setText:[dayShortNameFormat stringFromDate:day]];
            [dayCell cellStatusChange:APDAtePickerDayStatusNonSelected];
            for (NSDate *selectedDate in selectedDays) {
                if (dayCell.date == selectedDate) {
                    [dayCell cellStatusChange:APDAtePickerDayStatusSelected];
                    break;
                }
            }  
            cell = dayCell;
                        
    }else 
        if (collectionView == self.monthCollection) {
            NSDate *month = [self.months objectAtIndex:indexPath.row];
            [self.monthCollection registerNib:[UINib nibWithNibName:@"APDatePickerMonthCell" bundle:nil] forCellWithReuseIdentifier:@"monthCell"];
            APDatePickerMonthCell *monthCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCell" forIndexPath:indexPath];
            [monthCell.monthLabel setText:[monthFormat stringFromDate:month]];
            cell = monthCell;
    }
    
    return cell;
}

+(instancetype) initAPDatePickerStartingFromDate:(NSDate *) startingDate forDays:(NSNumber *) numberOfDay {
    APDatePicker *datePicker = [[APDatePicker alloc] initWithNibName:@"APDatePicker" bundle:nil];
    datePicker.startingDate = startingDate;
    datePicker.numberOfDays = numberOfDay;
    return datePicker;
}

@end
