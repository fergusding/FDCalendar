//
//  ViewController.m
//  FDCalendarDemo
//
//  Created by fergusding on 15/8/20.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "ViewController.h"
#import "FDCalendar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FDCalendar *calendar = [[FDCalendar alloc] initWithCurrentDate:[NSDate date]];
    CGRect frame = calendar.frame;
    frame.origin.y = 64;
    calendar.frame = frame;
    [self.view addSubview:calendar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
