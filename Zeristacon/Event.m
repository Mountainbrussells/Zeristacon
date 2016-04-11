//
//  Event.m
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import "Event.h"

@implementation Event

+ (id)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSParameterAssert(managedObjectContext);
    Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:managedObjectContext];
    
    return event;
}

- (void)willSave
{
    [super willSave];
    if (![self isDeleted] && self.changedValues[@"dateUpdated"] == nil) {
        self.dateUpdated = [NSDate date];
    }
    
    
    
}

@end
