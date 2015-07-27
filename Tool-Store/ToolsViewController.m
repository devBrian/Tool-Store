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

@interface ToolsViewController () <ToolsTableViewControllerDelegate, UISearchBarDelegate>
@property (strong, nonatomic) ToolsTableViewController *toolsTableViewController;
@end

@implementation ToolsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.delegate=self;
    [searchBar setPlaceholder:@"Search Tools"];
    self.navigationItem.titleView = searchBar;
    
    [self searchForText:searchBar.text];
}
-(void)searchForText:(NSString *)text
{
    [self.toolsTableViewController searchForText:text completion:^(NSError *error) {
        if (error)
        {
            [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
        }
    }];
}
#pragma mark - Search Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length > 3 || (searchBar.text.length == 0))
    {
        // FIXME: Crash after searching
        //Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'no object at index 30 in section at index 0'
        //[self searchForText:searchBar.text];
    }
    if ((searchBar.text.length == 0))
    {
        [searchBar resignFirstResponder];
    }
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}
#pragma mark - Tools Delegate 
-(void)selectedTool:(Tool *)tool
{
    NSString *message = [NSString stringWithFormat:@"Do you want to rent %@ for %i days at %.2f?", tool.name, [tool.rent_duration intValue],[tool.rent_price floatValue]];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Rent" message:message preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self createRentalForTool:tool andUser:[[UserManager sharedInstance] getCurrentUser]];
        [self saveExistingTool:tool];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
-(void)createRentalForTool:(Tool *)tool andUser:(User *)user
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Rental *rental = [NSEntityDescription insertNewObjectForEntityForName:@"Rental" inManagedObjectContext:context];
    rental.tool = tool;
    rental.user = user;
    rental.rent_date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *due_date = [calendar dateByAddingUnit:NSCalendarUnitDay value:[tool.rent_duration intValue] toDate:[NSDate date] options:0];
    rental.due_date = due_date;
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
-(void)saveExistingTool:(Tool *)tool
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tool"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", tool];
    request.predicate = predicate;
    
    NSError *error;
    Tool *temp = [[context executeFetchRequest:request error:&error] lastObject];
    temp.stock = [NSNumber numberWithInt:[tool.stock intValue]-1];
    
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    //[self.toolsTableViewController.tableView reloadData];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toolsTable"])
    {
        self.toolsTableViewController = (ToolsTableViewController *)segue.destinationViewController;
        self.toolsTableViewController.toolsDelegate = self;
    }
}
@end
