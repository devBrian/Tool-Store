//
//  ToolsViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "ToolsViewController.h"
#import "ToolsTableViewController.h"
#import "User.h"
#import "UserManager.h"
#import "Rental.h"
#import "AppDelegate.h"
#import "Functions.h"
#import "DetailViewController.h"
#import "ToolManager.h"
#import "RentalManager.h"

@interface ToolsViewController () <ToolsTableViewControllerDelegate>
@property (strong, nonatomic) ToolsTableViewController *toolsTableViewController;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) Tool *selectedTool;
@end

@implementation ToolsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.toolsTableViewController fetchDataWithCompletion:^(NSError *error) {
        if (error)
        {
            [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
        }
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}
#pragma mark - Tools Delegate
-(void)moreTool:(Tool *)tool
{
    self.selectedTool = tool;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}
-(void)selectedTool:(Tool *)tool
{
    if ([self toolRentalExists:tool] == NO)
    {
        [self createRentalForTool:tool andUser:[[UserManager sharedInstance] getCurrentUser]];
        [self saveExistingTool:tool];
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
    if ([segue.identifier isEqualToString:@"toolsTable"])
    {
        self.toolsTableViewController = (ToolsTableViewController *)segue.destinationViewController;
        self.toolsTableViewController.toolsDelegate = self;
    }
    else if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        self.detailViewController = (DetailViewController *)segue.destinationViewController;
        self.detailViewController.loadedToolData = self.selectedTool;
    }
}
@end
