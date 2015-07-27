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
    self.daysLeftLabel.text = [Functions countDownMessageForDays:days];
    self.daysLeftLabel.textColor = [Functions colorForDays:days];
}
@end
