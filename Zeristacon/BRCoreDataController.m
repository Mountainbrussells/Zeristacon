//
//  BRCoreDataController.m
//  HNReader
//
//  Created by Ben Russell on 3/8/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import "BRCoreDataController.h"

#import <CoreData/CoreData.h>

@interface BRCoreDataController ()

@property (strong, nonatomic) BRPersistenceController *persistencController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation BRCoreDataController

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController
{
    self = [super init];
    self.persistencController = persistenceController;
    self.managedObjectContext = self.persistencController.managedObjectContext;
    return self;
}

- (NSArray *)fetchEventsInContext:(NSManagedObjectContext *)managedObjectContext;
{
    __block NSArray *fetchedEvents;
    [managedObjectContext performBlockAndWait:^{
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        NSError *error;
        fetchedEvents = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    }];
    
    return fetchedEvents;
}

- (Event *)fetchEventWithUID:(NSInteger)uid inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    __block Event *event;
    __block NSArray *fetchResults;
    
    [managedObjectContext performBlockAndWait:^{
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:managedObjectContext];
        [request setPredicate:predicate];
        [request setEntity:entity];
        NSError *error;
        fetchResults = [managedObjectContext executeFetchRequest:request error:&error];
    }];
    
    if (fetchResults.count > 0) {
        event = fetchResults[0];
        return event;
    } else {
        return nil;
    }
}


@end
