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

@interface ToolsViewController () <ToolsTableViewControllerDelegate, UISearchBarDelegate>
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
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
}
#pragma mark - Search bar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2)
    {
        self.toolsTableViewController.searchText = searchText;
        self.toolsTableViewController.fetchedResultsController = nil;
        [self.toolsTableViewController fetchDataWithCompletion:^(NSError *error) {
            if (error)
            {
                [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
            }
            else
            {
                [self.toolsTableViewController.tableView reloadData];
            }
        }];
    }
    else if (searchText.length == 0)
    {
        [searchBar resignFirstResponder];
        self.toolsTableViewController.searchText = @"";
        self.toolsTableViewController.fetchedResultsController = nil;
        [self.toolsTableViewController fetchDataWithCompletion:^(NSError *error) {
            if (error)
            {
                [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
            }
            else
            {
                [self.toolsTableViewController.tableView reloadData];
            }
        }];
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - Tools Delegate
-(void)moreTool:(Tool *)tool
{
    self.selectedTool = tool;
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
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
