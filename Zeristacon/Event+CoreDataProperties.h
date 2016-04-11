//
//  Event+CoreDataProperties.h
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event.h"

NS_ASSUME_NONNULL_BEGIN

@interface Event (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *uid;
@property (nullable, nonatomic, retain) NSDate *startTime;
@property (nullable, nonatomic, retain) NSDate *finishTime;
@property (nullable, nonatomic, retain) NSString *location;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *dateUpdated;

@end

NS_ASSUME_NONNULL_END
