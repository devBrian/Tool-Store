//
//  MainTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Functions.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import CoreData;

@interface MainTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *toolImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@end

@implementation MainTableViewCell
-(void)setCellData:(Rental *)data
{
    Tool *tool = data.tool;
    [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:tool.image_url]];
    
    if ([tool.rental.quantity intValue] > 1)
    {
        self.qtyLabel.text = [NSString stringWithFormat:@"%@ (%i)",tool.condition,[tool.rental.quantity intValue]];
    }
    else
    {
        self.qtyLabel.text = tool.condition;
    }
    self.qtyLabel.textColor = [Functions colorForCondition:tool.condition];
    self.nameLabel.text = tool.name;
    self.manufacturerLabel.text = tool.manufacturer;
    NSInteger days = [Functions differenceInDays:[NSDate date] toDate:data.due_date];
    self.daysLeftLabel.text = [Functions countDownMessageForDays:days];
    self.daysLeftLabel.textColor = [Functions colorForDays:days];
}
@end
