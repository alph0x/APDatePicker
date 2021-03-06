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
#define YEAR 12

@interface APDatePicker () {
    NSCalendar *calendar;
    NSDateComponents *offset;
    NSDateFormatter *monthFormat;
    NSDateFormatter *dayNumberFormat;
    NSDateFormatter *dayShortNameFormat;
    NSDateFormatter *monthNumberFormat;
    NSMutableArray *selectedDays;
    NSIndexPath *dayPagingIndexPath;
    NSIndexPath *monthPagingIndexPath;
    NSInteger currentMonthIndex;
    NSInteger currentDayIndex;
    NSInteger daysPages;
    NSInteger monthPages;
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
    [self.monthCollection reloadData];
    
}

- (NSArray *) getArrayOfMonthsFromDays:(NSArray *) daysArray {
    APDatePickerDayCell *dCell = [daysArray objectAtIndex:0];
    APDatePickerMonthCell *initialMonthCell = [[APDatePickerMonthCell alloc] init];
    [initialMonthCell.monthLabel setText:[monthFormat stringFromDate:dCell.date]];
    initialMonthCell.date = dCell.date;
    initialMonthCell.indexPath = dCell.indexPath;
    NSMutableArray *arrayOfMonths = [NSMutableArray arrayWithObject:initialMonthCell];
    calendar = [NSCalendar currentCalendar];
    offset = [[NSDateComponents alloc] init];
    for (int i = 1; i < [daysArray count]; i++) {
        NSInteger component = (NSCalendarUnitMonth | NSCalendarUnitYear);
        APDatePickerDayCell *monthCell = [daysArray objectAtIndex:i];
        APDatePickerDayCell *lastMonthCell = [arrayOfMonths lastObject];
        NSDateComponents *dateA = [calendar components:component fromDate:monthCell.date];
        NSDateComponents *dateB = [calendar components:component fromDate:lastMonthCell.date];
        NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i-1 inSection:0];
        if (results == NSOrderedAscending) {
            APDatePickerMonthCell *mCell = [[APDatePickerMonthCell alloc] init];
            mCell.date = monthCell.date;
            mCell.indexPath = indexPath;
            [arrayOfMonths addObject:mCell];
        }
    }
    
    return [arrayOfMonths sortedArrayUsingComparator:^NSComparisonResult(APDatePickerMonthCell *a, APDatePickerMonthCell *b) {
        return [[a date] compare:[b date]];
    }];
    
}

- (NSArray *) getArrayOfDays:(NSNumber *) numberOfDays startingFromDate:(NSDate *) startingDate {
    NSMutableArray *arrayOfDays = [NSMutableArray new];
    startingDate=[NSDate date];
    calendar = [NSCalendar currentCalendar];
    offset = [[NSDateComponents alloc] init];
    for (int i = 0; i < [numberOfDays intValue]; i++) {
        [offset setDay:i];
        NSDate *day = [calendar dateByAddingComponents:offset toDate:startingDate options:0];
        [self.daysCollection registerNib:[UINib nibWithNibName:@"APDatePickerDayCell" bundle:nil] forCellWithReuseIdentifier:@"dayCell"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        APDatePickerDayCell *dayCell = [[APDatePickerDayCell alloc] init];
        dayCell.date = day;
        dayCell.indexPath = indexPath;
        
        [arrayOfDays addObject:dayCell];
    }
    
    return [arrayOfDays sortedArrayUsingComparator:^NSComparisonResult(APDatePickerDayCell *a, APDatePickerDayCell *b) {
        return [[a date] compare:[b date]];
    }];
    
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
    for (APDatePickerMonthCell *monthCell in self.months) {
        NSIndexPath *indexPath = monthCell.indexPath;
        NSInteger component = (NSCalendarUnitMonth | NSCalendarUnitYear);
        NSDateComponents *dateA = [calendar components:component fromDate:month];
        NSDateComponents *dateB = [calendar components:component fromDate:monthCell.date];
        NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
        int index = (dateA.month - dateB.month);
        if (index < 0) {
            if (dateA.year > dateB.year) {
                index = dateA.month + (YEAR - dateB.month);
            }
        }
        if (results == NSOrderedAscending) {
            nextIndexPath =  [NSIndexPath indexPathForRow:(indexPath.row + index)
                                                inSection:0];
            
        } else 
            if (results == NSOrderedDescending) {
                nextIndexPath =  [NSIndexPath indexPathForRow:(indexPath.row - index)
                                                    inSection:0];
                
            } else {
                nextIndexPath = indexPath;
            }
        monthPagingIndexPath = nextIndexPath;
        APDatePickerDayCell *dayCell;
        for (APDatePickerDayCell *dCell in self.days) {
            if (dCell.date == month) {
                dayCell = dCell;
                break;
            }
        }
        if (dayCell.indexPath.row == 0) {
            monthPagingIndexPath = dayCell.indexPath;
        }
        [self.monthCollection scrollToItemAtIndexPath:monthPagingIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally  animated:YES];
        break;
    }
}

-(void) scrollToDay:(NSDate *) day {
    for (APDatePickerDayCell *dayCell in self.days) {
        NSIndexPath *indexPath = dayCell.indexPath;
        NSInteger component = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
        NSDateComponents *dateA = [calendar components:component fromDate:day];
        NSDateComponents *dateB = [calendar components:component fromDate:dayCell.date];
        NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
        NSIndexPath *nextIndexPath = indexPath;
        if (results == NSOrderedSame) {
            dayPagingIndexPath = nextIndexPath;
            [self.daysCollection scrollToItemAtIndexPath:nextIndexPath atScrollPosition:10 animated:YES];
            break;
            
        }
        
    }
}

-(NSComparisonResult) compareDate:(NSDate *) date1 withDate:(NSDate *) date2 {
    NSInteger component = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    NSDateComponents *dateA = [calendar components:component fromDate:date1];
    NSDateComponents *dateB = [calendar components:component fromDate:date2];
    NSComparisonResult results = [[calendar dateFromComponents:dateB] compare:[calendar dateFromComponents:dateA]];
    return results;
}

#pragma mark IBActions
- (IBAction)monthBackButtonTapped:(id)sender {
    [self changeMonthPage:APDatePickerDirectionBackward]; 
}
- (IBAction)monthForwardButtonTapped:(id)sender {
    [self changeMonthPage:APDatePickerDirectionForward];
}

-(void) changeMonthPage:(APDatePickerDirection) direction {
    int index = [self.monthCollection visibleCells].count;
    if (direction == APDatePickerDirectionBackward) {
        index = index * - 1;
    }
    for (APDatePickerMonthCell *mCell in self.months) {
        APDatePickerMonthCell *monthCell = [[self.monthCollection visibleCells] firstObject];
        if (monthCell.date == mCell.date) {
            monthPagingIndexPath = [NSIndexPath indexPathForRow:monthPagingIndexPath.row + index inSection:0];
            if (monthPagingIndexPath.row < 0) {
                monthPagingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }else if (monthPagingIndexPath.row >= ([self.numberOfDays intValue]/30 + 1)) {
                monthPagingIndexPath = [NSIndexPath indexPathForRow:monthPagingIndexPath.row - index inSection:0];
                break;
            }
            [self.monthCollection scrollToItemAtIndexPath:monthPagingIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CATransaction setCompletionBlock:^{
                    //                    APDatePickerMonthCell *currentMonthCell = [[self.monthCollection visibleCells] firstObject];
                    //                    [self scrollToDay:currentMonthCell.date];
                    [self scrollViewDidEndDecelerating:self.monthCollection];
                }];
            });
            break;
        }
    }
}

- (IBAction)dayBackButtonTapped:(id)sender {
    [self changeDayPage:APDatePickerDirectionBackward];
}
- (IBAction)dayForwardButtonTapped:(id)sender {
    [self changeDayPage:APDatePickerDirectionForward];
}

-(void) changeDayPage:(APDatePickerDirection) direction {
    NSArray *visibleCells = [[self.daysCollection visibleCells] sortedArrayUsingComparator:^NSComparisonResult(APDatePickerDayCell *a, APDatePickerDayCell *b) {
        return [[a date] compare:[b date]];
    }];
    int index = visibleCells.count;
    
    if (direction == APDatePickerDirectionBackward) {
        index = index * - 1;
    }
    
    for (APDatePickerDayCell *dCell in self.days) {
        
        APDatePickerDayCell *dayCell = [visibleCells firstObject];
        if (dayCell.date == dCell.date) {
            dayPagingIndexPath = [NSIndexPath indexPathForRow:dayPagingIndexPath.row + index inSection:0];
            if (dayPagingIndexPath.row < 0) {
                dayPagingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            }else if (dayPagingIndexPath.row > self.days.count){
                dayPagingIndexPath = [NSIndexPath indexPathForRow:dayPagingIndexPath.row - index inSection:0];
            }
            [self.daysCollection scrollToItemAtIndexPath:dayPagingIndexPath 
                                        atScrollPosition:10 
                                                animated:YES];
            [self scrollViewDidEndDecelerating:self.daysCollection];
            break;
        }
    }
}

#pragma mark UICollectionView Delegates

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.daysCollection) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CATransaction setCompletionBlock:^{
                NSArray *visibleCells = [[self.daysCollection visibleCells] sortedArrayUsingComparator:^NSComparisonResult(APDatePickerDayCell *a, APDatePickerDayCell *b) {
                    return [[a date] compare:[b date]];
                }];
                NSDate *currentMonth = [self getTheHighlightedMonthOfDays:visibleCells];
                APDatePickerDayCell *dCell = [visibleCells firstObject];
                if (dCell.indexPath.row == 0) {
                    currentMonth = dCell.date;
                }
                currentDayIndex = self.daysCollection.contentOffset.x / self.daysCollection.frame.size.width;
                dayPagingIndexPath = [NSIndexPath indexPathForRow:currentDayIndex * visibleCells.count
                                                        inSection:0];
                
                [self scrollToMonth:currentMonth];
            }];
        });
    }
    if (scrollView == self.monthCollection) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CATransaction setCompletionBlock:^{
                NSMutableArray *visibleCells = [NSMutableArray arrayWithArray:[[self.monthCollection visibleCells] sortedArrayUsingComparator:^NSComparisonResult(APDatePickerDayCell *a, APDatePickerDayCell *b) {
                    return [[a date] compare:[b date]];
                }]];
                if (visibleCells.count > 1) {
                    [visibleCells removeObjectAtIndex:0];
                }
                APDatePickerMonthCell *monthCell = (APDatePickerMonthCell *)[visibleCells firstObject];
                for (APDatePickerMonthCell *mCell in self.months) {
                    if (monthCell.date == mCell.date) {
                        monthPagingIndexPath = [NSIndexPath indexPathForItem:monthCell.indexPath.row inSection:0];
                        break;
                    }
                }
                [self scrollToDay:monthCell.date];
            }];
        });
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
            for (NSDate *date in selectedDays) {
                if ([self compareDate:date withDate:dayCell.date] == NSOrderedSame) {
                    [selectedDays removeObject:date];
                    break;
                }
            }
            
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
        [self.daysCollection registerNib:[UINib nibWithNibName:@"APDatePickerDayCell" bundle:nil] forCellWithReuseIdentifier:@"dayCell"];
        APDatePickerDayCell *dayCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"dayCell" forIndexPath:indexPath];
        APDatePickerDayCell *dCell = [self.days objectAtIndex:indexPath.row];
        dayCell.date = dCell.date;
        [dayCell.dayNumberLabel setText:[dayNumberFormat stringFromDate:dCell.date]];
        [dayCell.dayNameLabel setText:[dayShortNameFormat stringFromDate:dCell.date]];
        dayCell.indexPath = indexPath;
        [dayCell cellStatusChange:[self defineStatusForCell:dayCell]];
        cell = dayCell;
        
    }else 
        if (collectionView == self.monthCollection) {
            [self.monthCollection registerNib:[UINib nibWithNibName:@"APDatePickerMonthCell" bundle:nil] forCellWithReuseIdentifier:@"monthCell"];
            APDatePickerMonthCell *monthCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"monthCell" forIndexPath:indexPath];
            APDatePickerMonthCell *mCell = [self.months objectAtIndex:indexPath.row];
            [monthCell.monthLabel setText:[monthFormat stringFromDate:mCell.date]];
            monthCell.date = mCell.date;
            monthCell.indexPath = indexPath;
            cell = monthCell;
        }
    
    daysPages = floor(self.daysCollection.contentSize.width /    
                      self.daysCollection.frame.size.width);
    monthPages = floor(self.monthCollection.contentSize.width /    
                       self.monthCollection.frame.size.width);
    
    return cell;
}

-(APDatePickerDayStatus) defineStatusForCell:(APDatePickerDayCell *) dayCell {
    NSDate *dayCellDate = dayCell.date;
    for (NSDate *date in selectedDays) {
        NSInteger components = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
        NSDateComponents *dayCellDateComponents = [calendar components:components fromDate:dayCellDate];
        NSDateComponents *dateComponents = [calendar components:components fromDate:date];
        NSComparisonResult results = [[calendar dateFromComponents:dayCellDateComponents] compare:[calendar dateFromComponents:dateComponents]];
        if (results == NSOrderedSame) {
            return APDAtePickerDayStatusSelected;
        }
    }
    return APDAtePickerDayStatusNonSelected;
}

+(instancetype) initAPDatePickerStartingFromDate:(NSDate *) startingDate forDays:(NSNumber *) numberOfDay {
    APDatePicker *datePicker = [[APDatePicker alloc] initWithNibName:@"APDatePicker" bundle:nil];
    datePicker.startingDate = startingDate;
    datePicker.numberOfDays = numberOfDay;
    return datePicker;
}

@end
