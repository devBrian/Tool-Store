//
//  DetailSubTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "DetailSubTableViewCell.h"

@implementation DetailSubTableViewCell

-(void)setCellData:(id)data
{
    NSArray *args = (NSArray *)data;
    self.textLabel.text = args.firstObject;
    if ([args.lastObject isKindOfClass:[NSNumber class]])
    {
        self.detailTextLabel.text = [NSString stringWithFormat:@"%i", [args.lastObject intValue]];
    }
    else
    {
        self.detailTextLabel.text = args.lastObject;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
