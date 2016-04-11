//
//  BRServiceController.m
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import "BRServiceController.h"
#import "Event+CoreDataProperties.h"

static NSString *const kBaseZeristaURL = @"https://zeristacon.zerista.com/event?format=json";



@interface BRServiceController ()

@property (strong, nonatomic)BRPersistenceController *persistenceController;
@property (strong, nonatomic)NSManagedObjectContext *writeMOC;

@end

@implementation BRServiceController

- (id)initWithPersistenceController:(BRPersistenceController *)persistenceController
{
    self = [super init];
    self.persistenceController = persistenceController;
    self.writeMOC = self.persistenceController.dataContext;
    
    
    return self;
}

- (void) updateEventsWithCompletion:(void (^)(NSError *error))completion
{
    NSString *urlString = kBaseZeristaURL;
    
    NSURL *parseURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *parseRequest = [[NSMutableURLRequest alloc] initWithURL:parseURL];
    [parseRequest setHTTPMethod:@"GET"];

    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:parseRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *dataError;
            NSDictionary *eventsData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&dataError];
            
            
            
            __block NSMutableArray *mocEventArray = [NSMutableArray arrayWithArray:[self.coreDataController fetchEventsInContext:self.writeMOC]];
            [self.writeMOC performBlockAndWait:^{
                for (id event in eventsData) {
                    
                    NSInteger eventID = (NSInteger)[event objectForKey:@"id"];
                    Event *existingEvent = [self.coreDataController fetchEventWithUID:eventID inManagedObjectContext:self.writeMOC];
                    if (existingEvent) {
                        
                        existingEvent.name = [event objectForKey:@"name"];
                        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                        NSString* startDateString = [event objectForKey:@"start"];
                        NSDate* startDate = [dateFormatter dateFromString:startDateString];
                        existingEvent.startTime = startDate;
                        NSString* finishDateString = [event objectForKey:@"finish"];
                        NSDate* finishDate = [dateFormatter dateFromString:finishDateString];
                        existingEvent.finishTime = finishDate;
                        NSDictionary *location = [event objectForKey:@"location"];
                        //existingEvent.location = [location objectForKey:@"name"];
                        existingEvent.uid = [event objectForKey:@"id"];
                        
                    
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                        [mocEventArray removeObject:existingEvent];
                    } else  {
                        
                        Event *mocEvent = [Event insertInManagedObjectContext:self.writeMOC];
                        mocEvent.name = [event objectForKey:@"name"];
                        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
                        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
                        NSString* startDateString = [event objectForKey:@"start"];
                        NSDate* startDate = [dateFormatter dateFromString:startDateString];
                        mocEvent.startTime = startDate;
                        NSString* finishDateString = [event objectForKey:@"finish"];
                        NSDate* finishDate = [dateFormatter dateFromString:finishDateString];
                        mocEvent.finishTime = finishDate;
                        NSDictionary *location = [event objectForKey:@"location"];
                        
                        if (location == NULL) {
                            mocEvent.location = @"Location TBD";
                        } else {
//                            mocEvent.location = [location objectForKey:@"name"];
                        }
                        mocEvent.uid = [event objectForKey:@"id"];
                        
                        NSError *mocError;
                        [self.writeMOC save:&mocError];
                    }
                    
                    
                    
                }
                
                if (mocEventArray.count > 0) {
                    for (Event *event in mocEventArray) {
                        [self.writeMOC deleteObject:event];
                    }
                }
                
                [self.persistenceController save];
            }];
            
            
            
            
            
            
            if (completion) {
                completion(nil);
            }
        }
        
        if (response) {
            NSLog(@"Request Response:%@", response);
        }
        
        if (error) {
            NSLog(@"RequestError:%@", error);
        }
    }];
    
    [task resume];

}
@end
