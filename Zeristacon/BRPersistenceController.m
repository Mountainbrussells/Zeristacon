//
//  BRPersistenceController.m
//  ColoradoBreweryFinder
//
//  Created by Ben Russell on 11/20/15.
//  Copyright © 2015 Ben Russell. All rights reserved.
//

#import "BRPersistenceController.h"

@interface BRPersistenceController ()

@property (strong, readwrite) NSManagedObjectContext *managedObjectContext;

@property (strong, readwrite) NSManagedObjectContext *dataContext;

@property (strong) NSManagedObjectContext *privateContext;

@property (copy) InitCallbackBlock initCallback;

- (void)initializeCoreData;

@end

@implementation BRPersistenceController

- (id)initWithCallBack:(InitCallbackBlock)callBack;
{
    if(!(self = [super init])) return nil;
    
    [self setInitCallback:callBack];
    [self initializeCoreData];
    
    return self;
}


- (void)initializeCoreData
{
    if ([self managedObjectContext]) return;
    
    NSURL *modelURL= [[NSBundle mainBundle] URLForResource:@"Zeristacon" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert2(mom, @"%@:%@ No model to generate store from", [self class], NSStringFromSelector(_cmd));
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSAssert(coordinator, @"Failed to initialize coordinator");
    

    
    [self setPrivateContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [[self privateContext] setPersistentStoreCoordinator:coordinator];
    
    [self setManagedObjectContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType]];
    [[self managedObjectContext] setParentContext:[self privateContext]];
    
    [self setDataContext:[[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType]];
    [[self dataContext] setParentContext:[self managedObjectContext]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSPersistentStoreCoordinator *psc = [[self privateContext] persistentStoreCoordinator];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
        options[NSInferMappingModelAutomaticallyOption] = @YES;
        options[NSSQLitePragmasOption] = @{@"journal_mode":@"DELETE"};
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"Zeristacon.sqlite"];
        
        NSLog(@"Core Data store path = \"%@\"", [storeURL path]);
        
        NSError *error;
        NSAssert2([psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error], @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        
        if (![self initCallback]) return;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self initCallback]();
        });
    });
}

- (void)save
{   __block BOOL hasChanges = NO;
    
    hasChanges = [[self managedObjectContext] hasChanges];
    
    if(!hasChanges) {
        [[self dataContext] performBlockAndWait:^{
            hasChanges = [[self dataContext] hasChanges];
        }];
    }
    
    if(!hasChanges) {
        return;
    }
    
    [[self dataContext] performBlockAndWait:^{
        [[self managedObjectContext] performBlockAndWait:^{
            NSError *error;
            
            NSAssert2([[self managedObjectContext] save:&error], @"Failed to save main context %@:%@", [error localizedDescription], [error userInfo]);
            [[self privateContext] performBlockAndWait:^{
                NSError *error;
                NSAssert2([[self privateContext] save:&error], @"Error saving privateContext %@:%@", [error localizedDescription], [error userInfo]);
            }];
        }];
    }];
}


@end
