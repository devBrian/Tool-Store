//
//  WalletViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import "WalletViewController.h"
#import "PaymentManager.h"
#import "UserManager.h"

@interface WalletViewController ()
@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentControl;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end

@implementation WalletViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.balanceLabel.text = [[[UserManager sharedInstance] getCurrentUser].balance stringValue];
}
- (IBAction)submitAction:(id)sender
{
    NSString *type = @"deposit";
    if ([self.typeSegmentControl selectedSegmentIndex] == 0)
    {
        type = @"withdraw";
    }
    [[PaymentManager sharedInstance] createPayment:type amount:[self.amountField.text floatValue] andTool:@"bank"];
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(finishedTransaction)])
        {
            [self.delegate finishedTransaction];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
