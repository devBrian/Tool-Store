//
//  DetailViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "DetailViewController.h"
#import "Functions.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommentViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *manufactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) CommentViewController *commentViewController;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.loadedToolData.name;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.loadedToolData.image_url]];
    self.nameLabel.text = self.title;
    self.manufactorLabel.text = [NSString stringWithFormat:@"%@", self.loadedToolData.manufacturer];
    self.conditionLabel.text = [NSString stringWithFormat:@"%@", [self.loadedToolData.condition capitalizedString]];
    self.durationLabel.text = [NSString stringWithFormat:@"%i rental days", [self.loadedToolData.rent_duration intValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f rent price", [self.loadedToolData.rent_price floatValue]];
    self.stockLabel.text = [NSString stringWithFormat:@"%i in stock",  [self.loadedToolData.stock intValue]];
    self.originLabel.text = self.loadedToolData.origin;
    self.overdueLabel.text = [NSString stringWithFormat:@"%.2f overdue fee", [self.loadedToolData.overdue_fee floatValue]];
    self.conditionLabel.textColor = [Functions colorForCondition:self.loadedToolData.condition];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"commentSegue"])
    {
        self.commentViewController = (CommentViewController *)segue.destinationViewController;
        self.commentViewController.loadedToolData = self.loadedToolData;
    }
}
@end
