//
//  BREventTableViewCell.h
//  Zeristacon
//
//  Created by Ben Russell on 4/11/16.
//  Copyright © 2016 Ben Russell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BREventTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;

@end
