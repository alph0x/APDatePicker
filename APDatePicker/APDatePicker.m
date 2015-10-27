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
    NSDateFormatter *monthNumberFormat;
    NSMutableArray *selectedDays;
    NSMutableArray *mIndexPaths;
    NSMutableArray *mCells;
    NSMutableArray *dIndexPaths;
    NSMutableArray *dCells;
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
    monthFormat = [[NSDateFormatter alloc] init];
    [monthFormat setDateFormat:@"MMMM YYYY"];
    dayNumberFormat = [[NSDateFormatter alloc] init];
    [dayNumberFormat setDateFormat:@"dd"];
    dayShortNameFormat = [[NSDateFormatter alloc] init];
    [dayShortNameFormat setDateFormat:@"EEE"];
    monthNumberFormat = [[NSDateFormatter alloc] init];
    [monthNumberFormat setDateFormat:@"MM"];
    
}

- (void)prepareArrayAndDatesForView {
    [self initDateFormatters];
    if (!self.startingDate) { //if there is no starting Date, starting date will be today.
        self.startingDate = TODAY; 
    }
    if (!self.numberOfDays) { //if there is no number of days, default is 30.
        self.numberOfDays = MONTH;
    }
    self.days = [self getArrayOfDays:self.numberOfDays startingFromDate:self.startingDate];
    self.months = [self getArrayOfMonthsFromDays:self.days];
    selectedDays = [NSMutableArray arrayWithObject:self.startingDate];
    mCells = [NSMutableArray new];
    dCells = [NSMutableArray new];
    mIndexPaths = [NSMutableArray new];
    dIndexPaths = [NSMutableArray new];
    [self.monthCollection reloadData];
    
}

- (NSArray *) getArrayOfMonthsFromDays:(NSArray *) daysArray {
    NSMutableArray *arrayOfMonths = [NSMutableArray arrayWithObject:[daysArray firstObject]];
    calendar = [NSCalendar currentCalendar];
    offset = [[NSDateComponents alloc] init];
    for (int i = 1; i < [daysArray count]; i++) {
        NSInteger component = (NSCalendarUnitMonth | NSCalendarUnitYear);
        NSDateComponents *dateA = [calendar components:component fromDate:[daysArray objectAtIndex:i]];
        NSDateComponents *dateB = [calendar components:component fromDate:[arrayOfMonths lastObject]];
        NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
        if (results == NSOrderedAscending) {
            [arrayOfMonths addObject:[calendar dateFromComponents:dateA]];
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

-(NSDate *) getTheHighlightedMonthOfDays:(NSArray *) days {
    int monthA = 0, monthB = 0;
    int monthValueA = 0, monthValueB = 0;
    NSDate *dateMonthA = [NSDate new];
    NSDate *dateMonthB = [NSDate new];
    for (APDatePickerDayCell *dayCell in days) {
        NSDate *day = dayCell.date;
        int tempMonth = [[monthNumberFormat stringFromDate:day] intValue];
        BOOL isFirstMonth = (monthValueA == [[monthNumberFormat stringFromDate:day] intValue] || dayCell == [days firstObject]);
        if (isFirstMonth) {
            monthValueA = 0 + tempMonth;
            dateMonthA = day;
        }else {
            monthValueB = 0 + tempMonth;
            dateMonthB = day;
        }
            if (monthValueA == [[monthNumberFormat stringFromDate:day] intValue]) {
                monthA++;
        }else
            if (monthValueB == [[monthNumberFormat stringFromDate:day] intValue]) {
                monthB++;
        }
        
    }
    if (monthA > monthB) {
        return dateMonthA;
    }
    
    return dateMonthB;
    
}

-(void) scrollToMonth:(NSDate *) month {
    NSIndexPath *nextIndexPath;
    for (APDatePickerMonthCell *monthCell in mCells) {
        NSIndexPath *indexPath = [mIndexPaths objectAtIndex:[mCells indexOfObject:monthCell]];
        NSInteger component = (NSCalendarUnitMonth | NSCalendarUnitYear);
        NSDateComponents *dateA = [calendar components:component fromDate:month];
        NSDateComponents *dateB = [calendar components:component fromDate:monthCell.date];
        NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
            if (results == NSOrderedAscending) {
                nextIndexPath =  [NSIndexPath indexPathForRow:(indexPath.row + 1)
                                                inSection:0];
            
        } else 
            if (results == NSOrderedDescending) {
                nextIndexPath =  [NSIndexPath indexPathForRow:(indexPath.row - 1)
                                                    inSection:0];
                
        } else {
            nextIndexPath = indexPath;
        }
        
        [self.monthCollection scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally  animated:YES];
        break;
    }
}

-(void) scrollToDay:(NSDate *) day {
    for (APDatePickerDayCell *dayCell in dCells) {
        NSIndexPath *indexPath = [dIndexPaths objectAtIndex:[dCells indexOfObject:dayCell]];
        NSInteger component = (NSCalendarUnitMonth | NSCalendarUnitYear);
        NSDateComponents *dateA = [calendar components:component fromDate:day];
        NSDateComponents *dateB = [calendar components:component fromDate:dayCell.date];
        NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
        NSIndexPath *nextIndexPath = indexPath;
        if (results == NSOrderedSame) {
            [self.daysCollection scrollToItemAtIndexPath:nextIndexPath atScrollPosition:10 animated:YES];
            break;
            
        }
        
    }
}

#pragma mark UICollectionView Delegates

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.daysCollection) {
        NSDate *currentMonth = [self getTheHighlightedMonthOfDays:[self.daysCollection visibleCells]];
        [self scrollToMonth:currentMonth];
    }
    if (scrollView == self.monthCollection) {
        APDatePickerMonthCell *monthCell = (APDatePickerMonthCell *)[[self.monthCollection visibleCells] firstObject];
        [self scrollToDay:monthCell.date];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size;
        if (collectionView == self.daysCollection) {
            size = CGSizeMake(38, 49);
    }else 
        if (collectionView == self.monthCollection) {
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
            NSLog(@"%@", [selectedDays description]);
            [self scrollToMonth:dayCell.date];
            [self.delegate APDatePickerSelectedDays:selectedDays];
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
            [dCells addObject:dayCell];
            [dIndexPaths addObject:indexPath];
            cell = dayCell;
                        
    }else 
        if (collectionView == self.monthCollection) {
            NSDate *month = [self.months objectAtIndex:indexPath.row];
            [self.monthCollection registerNib:[UINib nibWithNibName:@"APDatePickerMonthCell" bundle:nil] forCellWithReuseIdentifier:@"monthCell"];
            APDatePickerMonthCell *monthCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCell" forIndexPath:indexPath];
            [monthCell.monthLabel setText:[monthFormat stringFromDate:month]];
            monthCell.date = month;
            [mCells addObject:monthCell];
            [mIndexPaths addObject:indexPath];
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
