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
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@end

@implementation ToolsTableViewCell
-(void)setCellData:(Tool *)tool
{
    [self.toolImageView sd_setImageWithURL:[NSURL URLWithString:tool.image_url]];
    self.nameLabel.text = tool.name;
    self.manufacturerLabel.text = tool.manufacturer;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f",[tool.rent_price floatValue]];
    self.durationLabel.text = [NSString stringWithFormat:@"Rent for %i days",[tool.rent_duration intValue]];
    if ([tool.stock intValue] > 0)
    {
        self.priceLabel.text = [NSString stringWithFormat:@"%i for %.2f",[tool.stock intValue],[tool.rent_price floatValue]];
    }
    else
    {
        self.priceLabel.text = [NSString stringWithFormat:@"More on the way at $%.2f",[tool.rent_price floatValue]];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
@end
