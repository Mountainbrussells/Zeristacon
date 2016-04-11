//
//  BRServiceController.h
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "BRPersistenceController.h"
#import "BRCoreDataController.h"

@class Event;

@interface BRServiceController : NSObject

@property (strong, nonatomic) BRCoreDataController *coreDataController;

- (id) initWithPersistenceController:(BRPersistenceController *)persistenceController;

- (void) updateEventsWithCompletion:(void (^)(NSError *error))completion;

@end
