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
@property (weak, nonatomic) IBOutlet UILabel *rentOnLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLeftLabel;
@end

@implementation MainTableViewCell
-(void)setCellData:(Rental *)data
{
    Tool *tool = data.tool;
    [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:tool.image_url]];
    
    if ([tool.rental.quantity intValue] > 1)
    {
        NSString *string = [NSString stringWithFormat:@"%@ (%i)", tool.name,[tool.rental.quantity intValue]];
        NSString *subScript = [NSString stringWithFormat:@"(%i)",[tool.rental.quantity intValue]];
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:[string rangeOfString:subScript]];
        [attrString addAttribute:NSBaselineOffsetAttributeName value:@10 range:[string rangeOfString:subScript]];
        
        self.nameLabel.attributedText = attrString;
    }
    else
    {
        self.nameLabel.text = tool.name;
    }
    
    self.manufacturerLabel.text = tool.manufacturer;
    self.rentOnLabel.text = [NSString stringWithFormat:@"Rented on: %@",[Functions stringFromDate:data.rent_date]];
    NSInteger days = [Functions differenceInDays:[NSDate date] toDate:data.due_date];
    self.daysLeftLabel.text = [Functions countDownMessageForDays:days];
    self.daysLeftLabel.textColor = [Functions colorForDays:days];
}
@end
