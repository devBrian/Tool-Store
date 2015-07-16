//
//  ToolsTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "ToolsTableViewCell.h"

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
    self.toolImageView.image = tool.image;
    self.nameLabel.text = tool.name;
    self.manufacturerLabel.text = tool.manufacturer;
    self.conditionLabel.text = tool.condition;
    self.priceLabel.text = [NSString stringWithFormat:@"%i",[tool.rent_price intValue]];
    self.durationLabel.text = [NSString stringWithFormat:@"%i",[tool.rent_duration intValue]];
    
    if (tool.stock > 0)
    {
        self.stockStatusLabel.text = @"In-Stock";
    }
    else
    {
        self.stockStatusLabel.text = @"Out-of-Stock";
    }
}
@end
