//
//  Event+CoreDataProperties.m
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Event+CoreDataProperties.h"

@implementation Event (CoreDataProperties)

@dynamic uid;
@dynamic startTime;
@dynamic finishTime;
@dynamic location;
@dynamic name;
@dynamic dateUpdated;

@end
