//
//  Post+CoreDataProperties.m
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Post+CoreDataProperties.h"

@implementation Post (CoreDataProperties)

@dynamic title;
@dynamic body;
@dynamic createdAt;
@dynamic updatedAt;
@dynamic likeCounter;
@dynamic isLikedByMe;
@dynamic postId;
@dynamic comments;
@dynamic author;
@dynamic venue;

@end
