//
//  APDatePickerMonthCell.h
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APDatePickerMonthCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;

@property (retain, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSDate *date;

@end
