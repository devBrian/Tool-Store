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

@interface ToolsViewController () <ToolsTableViewControllerDelegate>
@property (strong, nonatomic) ToolsTableViewController *toolsTableViewController;
@end

@implementation ToolsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
