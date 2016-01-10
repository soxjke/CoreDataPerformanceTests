//
//  User+CoreDataProperties.h
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *userId;
@property (nullable, nonatomic, retain) NSString *displayName;
@property (nullable, nonatomic, retain) NSString *avatar;
@property (nullable, nonatomic, retain) NSNumber *birthdate;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *posts;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *comments;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addPostsObject:(NSManagedObject *)value;
- (void)removePostsObject:(NSManagedObject *)value;
- (void)addPosts:(NSSet<NSManagedObject *> *)values;
- (void)removePosts:(NSSet<NSManagedObject *> *)values;

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet<NSManagedObject *> *)values;
- (void)removeComments:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
