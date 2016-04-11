//
//  ViewController.h
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BRPersistenceController.h"
#import "BRServiceController.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) BRPersistenceController *perstistenceController;
@property (strong, nonatomic) BRServiceController *serviceController;

@end

