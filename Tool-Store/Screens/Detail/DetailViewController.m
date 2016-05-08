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
#import "QuantityViewController.h"
#import "DetailTableViewController.h"

@interface DetailViewController () <QuantityViewControllerDelegate, DetailTableViewControllerDelegate, CommentViewControllerDelegate>
@property (strong, nonatomic) CommentViewController *commentViewController;
@property (strong, nonatomic) QuantityViewController *qtyViewController;
@property (strong, nonatomic) DetailTableViewController *detailTable;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
}
-(void)refreshData
{
    NSMutableArray *comments = [self.loadedToolData.comments allObjects].mutableCopy;
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"post_date" ascending:NO];
    NSArray *sortedArray = [comments sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    NSMutableArray *detailArray = @[self.loadedToolData, @[@[@"Manufacturer",self.loadedToolData.manufacturer],
                                                           @[@"Condition", [self.loadedToolData.condition uppercaseString]],
                                                           @[@"Origin",self.loadedToolData.origin],
                                                           @[@"Overdue fee", [NSString stringWithFormat:@"$%.2f", [self.loadedToolData.overdue_fee floatValue]]]], sortedArray ].mutableCopy;
    [self.detailTable refreshTableData:detailArray];
}
#pragma mark - DetailTableViewControllerDelegate
-(void)rentAction:(id)sender
{
    [self performSegueWithIdentifier:@"qtySegue" sender:self];
}
#pragma mark - QuantityViewControllerDelegate
-(void)qtyDone:(int)qty
{
    int temp = [self.loadedToolData.stock intValue] - qty;
    self.loadedToolData.stock = [NSNumber numberWithInt:temp];
    [self saveExistingTool:self.loadedToolData];
    [self createRentalForTool:self.loadedToolData andUser:[[UserManager sharedInstance] getCurrentUser] andQty:qty];
    [self.detailTable.tableView reloadData];
}
-(void)commentsUpdated
{
   [self refreshData];
}
-(void)createRentalForTool:(Tool *)tool andUser:(User *)user andQty:(int)qty
{
    [[RentalManager sharedInstance] createRentalForTool:tool andUser:user andQty:qty];
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
        self.commentViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"qtySegue"])
    {
        self.qtyViewController = (QuantityViewController *)segue.destinationViewController;
        self.qtyViewController.loadedToolData = self.loadedToolData;
        self.qtyViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"detailTable"])
    {
        self.detailTable = (DetailTableViewController *)segue.destinationViewController;
        self.detailTable.delegate = self;
    }
}
@end
