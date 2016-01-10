//
//  RandomDataGenerator.h
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//

@interface RandomDataGenerator : NSObject

+ (instancetype _Nonnull)sharedObject;

- (NSArray<NSManagedObject *> * _Nonnull)generateEntitiesOfClass:(NSEntityDescription * _Nonnull)entityDescription count:(NSUInteger)count includingRelationships:(BOOL)includingRelationships inContext:(NSManagedObjectContext * _Nonnull)context;
- (void)generateAttributeUpdatesForEntities:(NSArray<NSManagedObject *> * _Nonnull)entities;
- (void)generateRelationshipUpdatesForEntities:(NSArray<NSManagedObject *> * _Nonnull)entities;

@end
