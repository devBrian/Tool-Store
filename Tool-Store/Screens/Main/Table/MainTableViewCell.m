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
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@end

@implementation MainTableViewCell
-(void)setCellData:(Rental *)data
{
    Tool *tool = (Tool *)data.tool;
    Rental *rental = (Rental *)data;
    self.activeData = data;
    [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:tool.image_url]];
    if ([rental.quantity intValue] > 1)
    {
        self.nameLabel.text = [NSString stringWithFormat:@"%@ (%i)",tool.name,[rental.quantity intValue]];
    }
    else
    {
        self.nameLabel.text = tool.name;
    }
    self.manufacturerLabel.text = tool.manufacturer;
    NSInteger days = [Functions differenceInDays:[NSDate date] toDate:data.due_date];
    self.daysLeftLabel.text = [Functions countDownMessageForDays:days];
    self.daysLeftLabel.textColor = [Functions colorForDays:days];
    self.returnButton.layer.borderColor = self.returnButton.titleLabel.textColor.CGColor;
    self.returnButton.layer.cornerRadius = 3.0f;
    self.returnButton.layer.borderWidth = 1.0f;
    self.moreButton.layer.borderColor = self.moreButton.titleLabel.textColor.CGColor;
    self.moreButton.layer.cornerRadius = 3.0f;
    self.moreButton.layer.borderWidth = 1.0f;
}
-(IBAction)returnRental:(id)sender
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(returnRental:)])
        {
            [self.delegate returnRental:self.activeData];
        }
    }
}
@end
