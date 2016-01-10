//
//  PerformanceMeter.h
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//

#define START_MEASURE_AND_GET_TOKEN(type, identifier) [[PerformanceMeter sharedObject] detachMeasureIdForMeasureOfType:(type) withId:(identifier)]
#define STOP_MEASURE(identifier) [[PerformanceMeter sharedObject] stopMeasureWithMeasureId:(identifier)];
#define PRINT_METRICS NSLog(@"%@", [[PerformanceMeter sharedObject] metrics])

@interface PerformanceMeter : NSObject

+ (instancetype _Nonnull)sharedObject;

- (NSString * _Nonnull)detachMeasureIdForMeasureOfType:(NSString * _Nonnull)type withId:(NSString  * _Nullable)identifier;
- (void)stopMeasureWithMeasureId:(NSString * _Nonnull)measureId;
- (NSString * _Nonnull)metrics;

@end
