//
//  HistoryTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import "HistoryTableViewCell.h"
#import "Payment.h"
#import "Functions.h"

@interface HistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *toolNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation HistoryTableViewCell

-(void)setCellData:(id)data
{
    Payment *payment = (Payment *)data;
    self.toolNameLabel.text = payment.tool_name;
    self.typeLabel.text = payment.type;
    self.timeLabel.text = [Functions timeStringFromDate:payment.createdAt];
    
    if ([payment.type isEqualToString:@"deposit"])
    {
        self.amountLabel.text = [NSString stringWithFormat:@"+ %@", [payment.amount stringValue]];
        self.amountLabel.textColor = [UIColor colorWithRed:0.20 green:0.65 blue:0.29 alpha:1.00];
    }
    else
    {
        self.amountLabel.text = [NSString stringWithFormat:@"- %@", [payment.amount stringValue]];
    }
}

@end
