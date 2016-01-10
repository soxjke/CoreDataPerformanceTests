//
//  PerformanceMeter.m
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//

#import "PerformanceMeter.h"

@interface PerformanceMeter ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDate *> *currentMeasurements;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableDictionary<NSString *, NSNumber *> *> *measuredResults;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSArray<NSString *> *> *measurementToTypeAndIdMap;
@property (nonatomic, strong) dispatch_queue_t isolationQueue;

@end

@implementation PerformanceMeter

+ (instancetype)sharedObject {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^() {
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (nil != self) {
        _isolationQueue = dispatch_queue_create("com.soxjke.PerformanceMeter", DISPATCH_QUEUE_SERIAL);
        _currentMeasurements = [NSMutableDictionary new];
        _measuredResults = [NSMutableDictionary new];
        _measurementToTypeAndIdMap = [NSMutableDictionary new];
    }
    return self;
}

- (NSString * _Nonnull)detachMeasureIdForMeasureOfType:(NSString * _Nonnull)type withId:(NSString  * _Nullable)identifier {
    NSMutableDictionary<NSString *, NSNumber *> * __block dictForMeasureType = nil;
    dispatch_async(self.isolationQueue, ^() {
        dictForMeasureType = self.measuredResults[type];
        if (nil == dictForMeasureType) {
            dictForMeasureType = [NSMutableDictionary new];
            self.measuredResults[type] = dictForMeasureType;
        }
    });
    
    if (nil == identifier) {
        identifier = [[NSUUID UUID] UUIDString];
    }
    
    NSString *measureId = [[NSUUID UUID] UUIDString];
    
    NSDate *startDate = [NSDate date];
    
    dispatch_async(self.isolationQueue, ^() {
        self.currentMeasurements[measureId] = startDate;
        self.measurementToTypeAndIdMap[measureId] = @[type, identifier];
    });
    
    return measureId;
}

- (void)stopMeasureWithMeasureId:(NSString * _Nonnull)measureId {
    NSDate *endDate = [NSDate date];
    dispatch_async(self.isolationQueue, ^() {
        NSArray<NSString *> *typeAndId = self.measurementToTypeAndIdMap[measureId];
        NSDate *startDate = self.currentMeasurements[measureId];
        self.measuredResults[typeAndId.firstObject][typeAndId.lastObject] = @([endDate timeIntervalSinceDate:startDate] * 1000);
        [self.currentMeasurements removeObjectForKey:measureId];
        [self.measurementToTypeAndIdMap removeObjectForKey:measureId];
    });
}

- (NSString * _Nonnull)metrics {
    NSMutableString *metrics = [NSMutableString new];
    dispatch_sync(self.isolationQueue, ^() {
        [metrics appendString:@"*****************\n"];        
        [metrics appendString:@"Printing performance metrics:\n"];
        [self.measuredResults enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableDictionary<NSString *,NSNumber *> * _Nonnull obj, BOOL * _Nonnull stop) {
            [metrics appendFormat:@"    Measurements for type %@:\n", key];
            [obj enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
                [metrics appendFormat:@"        %@: %@ ms;\n", key, obj];
            }];
        }];
        [metrics appendString:@"*****************\n"];
    });
    return [NSString stringWithString:metrics];
}

- (NSString * _Nonnull)description {
    return [self metrics];
}


@end
