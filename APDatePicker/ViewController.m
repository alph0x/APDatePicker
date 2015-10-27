//
//  ViewController.m
//  APDatePicker
//
//  Created by Alfredo Perez on 10/23/15.
//  Copyright © 2015 Alfredo Perez. All rights reserved.
//

#import "ViewController.h"


@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker = [APDatePicker initAPDatePickerStartingFromDate:nil forDays:nil];
    [self.datePickerContainer addSubview:self.datePicker.view];
}

-(void)APDatePickerSelectedDays:(NSArray *)selectedDays {
    NSLog(@"%@", selectedDays);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
