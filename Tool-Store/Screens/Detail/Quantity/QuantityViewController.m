//
//  QuantityViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "QuantityViewController.h"

@interface QuantityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *qtyLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@end

@implementation QuantityViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.qtyLabel.text = @"1";
    self.stepper.minimumValue = 1;
    self.stepper.maximumValue = [self.loadedToolData.stock intValue];
    self.availableLabel.text = [NSString stringWithFormat:@"Available: %.0f", (self.stepper.maximumValue - self.stepper.minimumValue)];
}
- (IBAction)stepperValueChanged:(id)sender
{
    self.qtyLabel.text = [NSString stringWithFormat:@"%.0f", self.stepper.value];
    float left = self.stepper.maximumValue - self.stepper.value;
    if (left > 0)
    {
        self.availableLabel.text = [NSString stringWithFormat:@"Available: %.0f", left];
    }
    else
    {
        self.availableLabel.text = @"Rent All";
    }
}
- (IBAction)doneAction:(id)sender
{
    [self.delegate qtyDone:self.stepper.value];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
