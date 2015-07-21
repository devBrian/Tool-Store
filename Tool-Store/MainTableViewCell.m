//
//  MainTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Functions.h"

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
    self.rentOnLabel.text = [NSString stringWithFormat:@"Rented on: %@",[Functions stringFromDate:data.rent_date]];
    NSInteger days = [Functions differenceInDays:[NSDate date] toDate:data.due_date];
    if (days < 1)
    {
        self.daysLeftLabel.text = @"Less than a day";
        self.daysLeftLabel.textColor = [UIColor redColor];
    }
    else if (days < 0)
    {
        self.daysLeftLabel.text = @"Over due!";
        self.daysLeftLabel.textColor = [UIColor purpleColor];
    }
    else if (days < 30)
    {
        self.daysLeftLabel.text = [NSString stringWithFormat:@"%li \ndays left",days];
        self.daysLeftLabel.textColor = [UIColor orangeColor];
    }
    else
    {
        self.daysLeftLabel.text = [NSString stringWithFormat:@"%li \ndays left",days];
        self.daysLeftLabel.textColor = [UIColor blackColor];
    }
}
@end
