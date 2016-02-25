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
#import "ToolManager.h"
#import "RentalManager.h"
#import "UserManager.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *manufactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (weak, nonatomic) IBOutlet UILabel *overdueLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *inventoryLabel;
@property (strong, nonatomic) CommentViewController *commentViewController;
@property (weak, nonatomic) IBOutlet UIButton *rentButton;
@property (nonatomic, readwrite) int inventoryAmount;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *conditionSegmentedControl;
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
    [self.conditionSegmentedControl setSelectedSegmentIndex:[Functions indexForSegmentedControlForCondition:self.loadedToolData.condition]];
    self.durationLabel.text = [NSString stringWithFormat:@"%i rental days", [self.loadedToolData.rent_duration intValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"$ %.2f rent price", [self.loadedToolData.rent_price floatValue]];
    [self.rentButton setTitle:[NSString stringWithFormat:@"Rent for %i days", [self.loadedToolData.rent_duration intValue]] forState:UIControlStateNormal];
    
    if ([self.loadedToolData.stock intValue] > 0)
    {
        self.stockLabel.text = [NSString stringWithFormat:@"%i left in stock", [self.loadedToolData.stock intValue]];
    }
    else
    {
        self.stockLabel.text = @"Out-of-Stock";
        self.stockLabel.textColor = [UIColor colorWithRed:0.850 green:0.218 blue:0.159 alpha:1.000];
    }
    self.originLabel.text = self.loadedToolData.origin;
    self.overdueLabel.text = [NSString stringWithFormat:@"$ %.2f overdue fee", [self.loadedToolData.overdue_fee floatValue]];
    
    for (Rental *rent in [UserManager sharedInstance].getCurrentUser.rental)
    {
        if ([rent.tool isEqual:self.loadedToolData])
        {
            self.inventoryLabel.text = [NSString stringWithFormat:@"%i in your inventory", [rent.quantity intValue]];
            self.inventoryAmount = [rent.quantity intValue];
            break;
        }
    }
    if (self.inventoryAmount == 0)
    {
        self.inventoryLabel.text = @"";
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.loadedToolData.comments.count == 0)
    {
        self.commentLabel.text = [NSString stringWithFormat:@"comment - be the first"];
    }
    else
    {
        if (self.loadedToolData.comments.count > 1)
        {
            self.commentLabel.text = [NSString stringWithFormat:@"%lu comments", self.loadedToolData.comments.count];
        }
        else
        {
            self.commentLabel.text = [NSString stringWithFormat:@"%lu comment", self.loadedToolData.comments.count];
        }
    }
}
-(IBAction)rentAction:(id)sender
{
    [Functions showErrorWithMessage:@"Added 1 to your inventory" forViewController:self];
    
    if ([self.loadedToolData.stock intValue] > 0)
    {
        if ([self toolRentalExists:self.loadedToolData] == NO)
        {
            [self createRentalForTool:self.loadedToolData andUser:[[UserManager sharedInstance] getCurrentUser]];
            [self saveExistingTool:self.loadedToolData];
        }
        self.inventoryAmount += 1;
        self.inventoryLabel.text = [NSString stringWithFormat:@"%i in your inventory", self.inventoryAmount];
        self.stockLabel.text = [NSString stringWithFormat:@"%i left in stock", [self.loadedToolData.stock intValue]];
    }
    else
    {
        self.rentButton.alpha = 0.5f;
        self.rentButton.userInteractionEnabled = NO;
        self.stockLabel.text = @"Out-of-Stock";
        self.stockLabel.textColor = [UIColor colorWithRed:0.850 green:0.218 blue:0.159 alpha:1.000];
    }
}
-(void)createRentalForTool:(Tool *)tool andUser:(User *)user
{
    [[RentalManager sharedInstance] createRentalForTool:tool andUser:user];
}
-(void)saveExistingTool:(Tool *)tool
{
    [[ToolManager sharedInstance] saveExistingTool:tool];
}
-(BOOL)toolRentalExists:(Tool *)tool
{
    return [[ToolManager sharedInstance] toolRentalExists:tool];
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
