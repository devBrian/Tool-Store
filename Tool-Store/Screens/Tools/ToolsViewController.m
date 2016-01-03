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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    Rental *rental = [NSEntityDescription insertNewObjectForEntityForName:@"Rental" inManagedObjectContext:context];
    rental.tool = tool;
    rental.user = user;
    rental.rent_date = [NSDate date];
    rental.quantity = [NSNumber numberWithInt:1];
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
}
-(BOOL)toolRentalExists:(Tool *)tool
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rental"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tool == %@", tool];
    request.predicate = predicate;
    
    NSError *error;
    if ([[context executeFetchRequest:request error:&error] count] > 0)
    {
        Rental *rental = [[context executeFetchRequest:request error:&error] lastObject];
        NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:rental.rent_date];
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        if([today day] == [otherDay day] && [today month] == [otherDay month] && [today year] == [otherDay year] && [today era] == [otherDay era])
        {
            rental.quantity = [NSNumber numberWithInt:[rental.quantity intValue]+1];
            [self saveExistingTool:tool];
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
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
