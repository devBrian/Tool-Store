//
//  ToolsTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "ToolsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Functions.h"

@interface ToolsTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *toolImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *manufacturerLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockStatusLabel;
@end

@implementation ToolsTableViewCell
-(void)setCellData:(Tool *)tool
{
    [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:tool.image_url]];
    self.nameLabel.text = tool.name;
    self.manufacturerLabel.text = tool.manufacturer;
    self.conditionLabel.text = tool.condition;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[tool.rent_price floatValue]];
    self.durationLabel.text = [NSString stringWithFormat:@"%i days",[tool.rent_duration intValue]];
    if ([tool.stock intValue] > 0)
    {
        self.stockStatusLabel.text = [NSString stringWithFormat:@"In Stock (%i)", [tool.stock intValue]];
        self.stockStatusLabel.textColor = [UIColor colorWithRed:0.194 green:0.509 blue:0.852 alpha:1.000];
    }
    else
    {
        self.stockStatusLabel.text = @"Out-of-Stock";
        self.stockStatusLabel.textColor = [UIColor colorWithRed:0.850 green:0.218 blue:0.159 alpha:1.000];
    }
    self.conditionLabel.textColor = [Functions colorForCondition:tool.condition];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
