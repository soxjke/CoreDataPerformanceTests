//
//  ViewController.m
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *measureId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.measureId = START_MEASURE_AND_GET_TOKEN(@"Appearance transition", NSStringFromClass([self class]));
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidAppear:(BOOL)animated {
    STOP_MEASURE(self.measureId);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^() {
        PRINT_METRICS;
    });
}

@end
