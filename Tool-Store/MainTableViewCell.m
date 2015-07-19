//
//  MainTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "MainTableViewCell.h"

@import CoreData;

@interface MainTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *toolImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@end

@implementation MainTableViewCell
-(void)setCellData:(Rental *)data
{
    Tool *tool = data.tool;
    self.toolImageView.image = [UIImage imageNamed:tool.image];
    self.nameLabel.text = tool.name;
    self.manufacturerLabel.text = tool.manufacturer;
    self.rentOnLabel.text = [NSString stringWithFormat:@"Rented on: %@",[NSDateFormatter localizedStringFromDate:data.rent_date dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:[NSDate date] toDate:data.due_date options:0];
    self.daysLeftLabel.text = [NSString stringWithFormat:@"%li days left", (long)difference.day];
}
@end
