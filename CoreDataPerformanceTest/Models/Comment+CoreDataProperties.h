//
//  Comment+CoreDataProperties.h
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *comentId;
@property (nullable, nonatomic, retain) NSString *text;
@property (nullable, nonatomic, retain) User *author;

@end

NS_ASSUME_NONNULL_END
