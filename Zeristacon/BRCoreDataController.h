//
//  BRCoreDataController.h
//  HNReader
//
//  Created by Ben Russell on 3/8/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//
/*  This is the controller where all coredata fetches and saves will be made */

#import <Foundation/Foundation.h>
#import "BRPersistenceController.h"
#import "Event+CoreDataProperties.h"
#import <CoreData/CoreData.h>

@interface BRCoreDataController : NSObject

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (NSArray *)fetchEventsInContext:(NSManagedObjectContext *)managedObjectContext;
- (Event *)fetchEventWithUID:(NSInteger)uid inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;


@end
