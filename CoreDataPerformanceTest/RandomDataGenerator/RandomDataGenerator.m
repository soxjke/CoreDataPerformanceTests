//
//  RandomDataGenerator.m
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//

#import "RandomDataGenerator.h"

#define TARGET_TOMANY_VIRALITY 2
#define RANDOM_BOOL (rand() > RAND_MAX / 2)
#define RANDOM_INT16 ((int16_t)rand())
#define RANDOM_INT32 ((int32_t)rand())
#define RANDOM_INT64 ((int64_t)rand() << 32 | rand())
#define RANDOM_DATE [[NSDate date] dateByAddingTimeInterval:-(rand() & 0xFFFF)]
#define RANDOM_DOUBLE ((double)rand() * (double)rand() / (double)rand())
#define RANDOM_FLOAT ((float)rand() * (float)rand() / (float)rand())
#define RANDOM_INT(limit) (RANDOM_INT32 * (limit) / RAND_MAX)

@interface RandomDataGenerator ()

@property (nonatomic, retain) NSMutableArray<NSString *> *generationStack;

@end

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
        _generationStack = [NSMutableArray new];
    }
    return self;
}

- (NSArray<NSManagedObject *> * _Nonnull)generateEntitiesOfClass:(NSEntityDescription * _Nonnull)entityDescription
                                                           count:(NSUInteger)count
                                          includingRelationships:(BOOL)includingRelationships
                                                       inContext:(NSManagedObjectContext * _Nonnull)context {
    NSMutableArray<NSManagedObject *> *resultingEntities = [NSMutableArray arrayWithCapacity:count];
    if ([self.generationStack containsObject:entityDescription.name]) {
        NSFetchRequest *fetchRequest = [NSFetchRequest new];
        fetchRequest.entity = entityDescription;
        fetchRequest.fetchLimit = count;
        resultingEntities = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    }
    else {
        [self.generationStack addObject:entityDescription.name];
        [context performBlockAndWait:^() {
            for(NSUInteger i = 0; i < count; i++) {
                [resultingEntities addObject:[[NSManagedObject alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context]];
            }
            [entityDescription.propertiesByName enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, __kindof NSPropertyDescription * _Nonnull obj, BOOL * _Nonnull stop) {
                id underlyingProperty = [obj valueForKey:@"_underlyingProperty"];
                if ([underlyingProperty isKindOfClass:[NSAttributeDescription class]]) {
                    NSAttributeDescription *attrDescription = (NSAttributeDescription *)underlyingProperty;
                    for(NSManagedObject *managedObject in resultingEntities) {
                        [self generateValueOfType:attrDescription.attributeType forObject:managedObject key:key];
                    }
                }
                if ([underlyingProperty isKindOfClass:[NSRelationshipDescription class]] && includingRelationships) {
                    NSRelationshipDescription *relationshipDescription = (NSRelationshipDescription *)underlyingProperty;
                    NSEntityDescription *destinationEntity = relationshipDescription.destinationEntity;
                    BOOL isToMany = relationshipDescription.toMany;
                    NSArray *sampleObjects = [self generateEntitiesOfClass:destinationEntity
                                                                     count:count * (isToMany ? TARGET_TOMANY_VIRALITY : 1)
                                                    includingRelationships:includingRelationships
                                                                 inContext:context];
                    for(NSManagedObject *managedObject in resultingEntities) {
                        if (isToMany) {
                            if (0 == [[managedObject valueForKey:key] count]) {
                                [self pickSeveralObjectsFromArray:sampleObjects
                                                        forObject:managedObject
                                                     relationship:key];
                            }
                        }
                        else {
                            if (nil == [managedObject valueForKey:key]) {
                                [self assignRandomObjectFromArray:sampleObjects
                                                        forObject:managedObject
                                                     relationship:key];
                            }
                        }
                    }
                }
                if ([underlyingProperty isKindOfClass:[NSFetchedPropertyDescription class]] && includingRelationships) {
                    NSFetchedPropertyDescription * __unused fetchedPropertyDescription = (NSFetchedPropertyDescription *)underlyingProperty;
                    @throw @"Not supported";
                }
            }];
        }];
        [self.generationStack removeLastObject];
    }
    if (0 == self.generationStack.count) {
        id measure = START_MEASURE_AND_GET_TOKEN(@"Object generation", @"CoreData save");
        [context save:nil];
        STOP_MEASURE(measure);
    }
    return [NSArray arrayWithArray:resultingEntities];
}

- (void)generateAttributeUpdatesForEntities:(NSArray<NSManagedObject *> * _Nonnull)entities {
    
}

- (void)generateRelationshipUpdatesForEntities:(NSArray<NSManagedObject *> * _Nonnull)entities {
    
}

- (void)generateValueOfType:(NSAttributeType)type
                  forObject:(NSManagedObject * _Nonnull)managedObject
                        key:(NSString * _Nonnull)key {
    switch (type) {
        case NSUndefinedAttributeType:
            @throw @"Undefined attribute";
            break;
        case NSInteger16AttributeType:
            [managedObject setValue:@(RANDOM_INT16) forKey:key];
            break;
        case NSInteger32AttributeType:
            [managedObject setValue:@(RANDOM_INT32) forKey:key];
            break;
        case NSInteger64AttributeType:
            [managedObject setValue:@(RANDOM_INT64) forKey:key];
            break;
        case NSDecimalAttributeType:
            [managedObject setValue:[NSDecimalNumber decimalNumberWithMantissa:RANDOM_INT64 exponent:RANDOM_INT16 isNegative:RANDOM_BOOL] forKey:key];
            break;
        case NSDoubleAttributeType:
            [managedObject setValue:@(RANDOM_DOUBLE) forKey:key];
            break;
        case NSFloatAttributeType:
            [managedObject setValue:@(RANDOM_FLOAT) forKey:key];
            break;
        case NSStringAttributeType:
            [managedObject setValue:[[NSUUID UUID] UUIDString] forKey:key];
            break;
        case NSBooleanAttributeType:
            [managedObject setValue:@(RANDOM_BOOL) forKey:key];
            break;
        case NSDateAttributeType:
            [managedObject setValue:RANDOM_DATE forKey:key];
            break;
        case NSBinaryDataAttributeType:
            [managedObject setValue:[[[NSUUID UUID] UUIDString] dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
            break;
        case NSTransformableAttributeType:
            @throw @"Not supported";
        case NSObjectIDAttributeType:
            break;
    }
}
         
- (void)pickSeveralObjectsFromArray:(NSArray * _Nonnull)sampleObjects
                          forObject:(NSManagedObject * _Nonnull)managedObject
                       relationship:(NSString * _Nonnull)relationship {
    NSUInteger numberOfObjectsInRelationship = RANDOM_INT(TARGET_TOMANY_VIRALITY + 1) + 1;
    NSUInteger numberOfSampleObjects = sampleObjects.count;
    NSMutableSet *set = [NSMutableSet setWithCapacity:numberOfObjectsInRelationship];
    for(NSUInteger i = 0; i < numberOfObjectsInRelationship; i++) {
        [set addObject:sampleObjects[RANDOM_INT(numberOfSampleObjects)]];
    }
    [managedObject setValue:[NSSet setWithSet:set] forKey:relationship];
}

- (void)assignRandomObjectFromArray:(NSArray * _Nonnull)sampleObjects
                          forObject:(NSManagedObject * _Nonnull)managedObject
                       relationship:(NSString * _Nonnull)relationship {
    NSUInteger numberOfSampleObjects = sampleObjects.count;
    [managedObject setValue:sampleObjects[RANDOM_INT(numberOfSampleObjects)] forKey:relationship];
}

@end
