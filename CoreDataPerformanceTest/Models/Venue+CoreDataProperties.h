//
//  Venue+CoreDataProperties.h
//  CoreDataPerformanceTest
//
//  Created by Petro Korienev on 1/10/16.
//  Copyright © 2016 Petro Korienev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Venue.h"

NS_ASSUME_NONNULL_BEGIN

@interface Venue (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSNumber *venueId;
@property (nullable, nonatomic, retain) Post *posts;

@end

NS_ASSUME_NONNULL_END
