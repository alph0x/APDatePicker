//
//  ViewController.h
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APDatePicker.h"

@interface ViewController : UIViewController <APDatePickerDelegate>

@property (strong, nonatomic) APDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *datePickerContainer;

@end

