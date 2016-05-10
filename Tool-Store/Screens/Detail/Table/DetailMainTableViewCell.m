//
//  DetailMainTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "DetailMainTableViewCell.h"
#import "Functions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserManager.h"
#import "Rental.h"

@interface DetailMainTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rentedImageView;
@property (weak, nonatomic) IBOutlet UILabel *rentedLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceWithDurationLabel;
@property (weak, nonatomic) IBOutlet UIButton *rentButton;
@end

@implementation DetailMainTableViewCell

-(void)setCellData:(id)data
{
    Tool *tool = (Tool *)data;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:tool.image_url]];
    self.nameLabel.text = tool.name;
    self.priceWithDurationLabel.text = [NSString stringWithFormat:@"$%.2f for %i days", [tool.rent_price floatValue], [tool.rent_duration intValue]];
    
    if ([tool.stock intValue] > 0)
    {
        self.stockLabel.text = [NSString stringWithFormat:@"%i available", [tool.stock intValue]];
        self.rentButton.userInteractionEnabled = YES;
        self.rentButton.alpha = 1.0f;
    }
    else
    {
        self.stockLabel.text = @"not available";
        self.stockLabel.textColor = [UIColor colorWithRed:0.850 green:0.218 blue:0.159 alpha:1.000];
        self.rentButton.userInteractionEnabled = NO;
        self.rentButton.alpha = 0.5f;
    }
    int amount = 0;
    for (Rental *rent in [UserManager sharedInstance].getCurrentUser.rental)
    {
        if ([rent.tool isEqual:tool])
        {
            self.rentedLabel.text = [NSString stringWithFormat:@"%i", [rent.quantity intValue]];
            amount += [rent.quantity intValue];
        }
    }
    if (amount == 0)
    {
        self.rentedLabel.text = @"";
        self.rentedImageView.hidden = YES;
    }
    else
    {
        self.rentedLabel.text = [NSString stringWithFormat:@"%i", amount];
        self.rentedImageView.hidden = NO;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)rentAction:(id)sender
{
    [self.delegate rentAction:sender];
}

@end
