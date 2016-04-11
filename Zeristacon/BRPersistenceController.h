//
//  BRPersistenceController.h
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/20/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//
/*  This persistence controller sets up the core data stack.  It sets up 3 ManagedObjectContexts, 2 private and one public. The firste private is read only and can't be touched by the interface.  The public moc is what the UI uses for data and the second private moc is there if the interface needs to asynchronously add data to the store */ 

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^InitCallbackBlock)(void);

@interface BRPersistenceController : NSObject

@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

@property (strong, readonly) NSManagedObjectContext *dataContext;

- (id) initWithCallBack:(InitCallbackBlock)callBack;

- (void) save;

@end
