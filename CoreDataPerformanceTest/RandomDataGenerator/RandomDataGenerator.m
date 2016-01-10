//
//  RandomDataGenerator.m
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//

#import "RandomDataGenerator.h"

@implementation RandomDataGenerator

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
        srand((unsigned int)time(NULL));
    }
    return self;
}

- (NSArray<NSManagedObject *> * _Nonnull)generateEntitiesOfClass:(NSEntityDescription * _Nonnull)entityDescription count:(NSUInteger)count includingRelationships:(BOOL)includingRelationships inContext:(NSManagedObjectContext * _Nonnull)context {
    NSMutableArray<NSManagedObject *> *resultingEntities = [NSMutableArray arrayWithCapacity:count];
    [context performBlockAndWait:^() {
        for(NSUInteger i = 0; i < count; i++) {
            [resultingEntities addObject:[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context]];
        }
        [entityDescription.propertiesByName enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, __kindof NSPropertyDescription * _Nonnull obj, BOOL * _Nonnull stop) {
            NSAttributeDescription *attrDescription = [obj valueForKey:@"_underlyingProperty"];
            for(NSManagedObject *managedObject in resultingEntities) {
                switch (attrDescription.attributeType) {
                    case NSUndefinedAttributeType:
                        @throw @"Undefined attribute";
                        break;
                    case NSInteger16AttributeType:
                        [managedObject setValue:@(rand()) forKey:key];
                    case NSInteger32AttributeType:
                        [managedObject setValue:@(rand()) forKey:key];
                    case NSInteger64AttributeType:
                        [managedObject setValue:@((int64_t)rand() << 32 | rand()) forKey:key];
                    case NSDecimalAttributeType:
                        [managedObject setValue:[NSDecimalNumber decimalNumberWithMantissa:(int64_t)rand() << 32 | rand() exponent:rand() isNegative:rand() > RAND_MAX / 2] forKey:key];
                    case NSDoubleAttributeType:
                        
                    case NSFloatAttributeType:
                    case NSStringAttributeType:
                    case NSBooleanAttributeType:
                    case NSDateAttributeType:
                    case NSBinaryDataAttributeType:
                    case NSTransformableAttributeType:
                        @throw @"Not supported";
                    case NSObjectIDAttributeType:
                        break;
                }
            }
        }];
    }];
    return [NSArray arrayWithArray:resultingEntities];
}

- (void)generateAttributeUpdatesForEntities:(NSArray<NSManagedObject *> * _Nonnull)entities {
    
}

- (void)generateRelationshipUpdatesForEntities:(NSArray<NSManagedObject *> * _Nonnull)entities {
    
}

@end
