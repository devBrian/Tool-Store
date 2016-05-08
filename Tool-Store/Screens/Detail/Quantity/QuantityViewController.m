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
    self.stepper.value = 1;
    self.stepper.minimumValue = 1;
    self.stepper.maximumValue = [self.loadedToolData.stock intValue];
    float left = self.stepper.maximumValue - self.stepper.value;
    [self updateAvailable:left];
}
-(void)updateAvailable:(float)left
{
    if (left > 0)
    {
        self.availableLabel.text = [NSString stringWithFormat:@"Available: %.0f", left];
    }
    else
    {
        self.availableLabel.text = @"Rent All";
    }
}
#pragma mark - IBActions
- (IBAction)stepperValueChanged:(id)sender
{
    self.qtyLabel.text = [NSString stringWithFormat:@"%.0f", self.stepper.value];
    float left = self.stepper.maximumValue - self.stepper.value;
    [self updateAvailable:left];
}
- (IBAction)doneAction:(id)sender
{
    [self.delegate qtyDone:self.stepper.value];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
