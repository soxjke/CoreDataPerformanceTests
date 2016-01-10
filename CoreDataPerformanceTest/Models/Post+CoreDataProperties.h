//
//  Post+CoreDataProperties.h
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface Post (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSNumber *createdAt;
@property (nullable, nonatomic, retain) NSNumber *updatedAt;
@property (nullable, nonatomic, retain) NSNumber *likeCounter;
@property (nullable, nonatomic, retain) NSNumber *isLikedByMe;
@property (nullable, nonatomic, retain) NSNumber *postId;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *comments;
@property (nullable, nonatomic, retain) User *author;
@property (nullable, nonatomic, retain) NSManagedObject *venue;

@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet<NSManagedObject *> *)values;
- (void)removeComments:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
