//
//  ViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/1/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewController.h"
#import "SignupViewController.h"
#import "UserManager.h"
#import "AppDelegate.h"
#import "Functions.h"
#import "Tool.h"
#import "DetailViewController.h"

@interface MainViewController () <MainTableViewControllerDelegate>
@property (strong, nonatomic) MainTableViewController *mainTableViewController;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) Rental *selectedRental;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSUserDefaults standardUserDefaults] setObject:[[UserManager sharedInstance] getCurrentUser].email forKey:LAST_EMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(IBAction)accountAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Actions" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Account info" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:@"account" sender:self];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Sign out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[UserManager sharedInstance] signOut];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
#pragma mark - MainTableViewController Delegate
-(void)moreRental:(Rental *)rental
{
    self.selectedRental = rental;
    [self performSegueWithIdentifier:@"moreSegue" sender:self];
}
-(void)returnRental:(Rental *)rental
{
    if ([Functions isDateOverDue:rental.due_date])
    {
        [Functions showErrorWithMessage:[NSString stringWithFormat:@"Rental is overdue! You will be charged %.2f.", [rental.tool.overdue_fee floatValue]] forViewController:self];
    }
    if ([rental.quantity intValue] == 1)
    {
        [self updateExistingTool:rental.tool];
        [self deleteTool:rental];
    }
    else
    {
        rental.quantity = [NSNumber numberWithInt:[rental.quantity intValue]-1];
    }
}
-(void)deleteTool:(Rental *)rental
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:rental];
    NSError *error;
    if (![context save:&error])
    {
        [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
    }
}
-(void)updateExistingTool:(Tool *)tool
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tool"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", tool];
    request.predicate = predicate;
    
    NSError *error;
    Tool *temp = [[context executeFetchRequest:request error:&error] lastObject];
    temp.stock = [NSNumber numberWithInt:[tool.stock intValue] + 1];
    
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"account"])
    {
        SignupViewController *signup = (SignupViewController *)segue.destinationViewController;
        signup.loadedUserData = [[UserManager sharedInstance] getCurrentUser];
    }
    else if ([segue.identifier isEqualToString:@"mainTable"])
    {
        self.mainTableViewController = (MainTableViewController *)segue.destinationViewController;
        [self.mainTableViewController fetchDataWithCompletion:^(NSError *error) {
            if (error)
            {
                [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
            }
        }];
        self.mainTableViewController.mainTableDelegate = self;
    }
    else if ([segue.identifier isEqualToString:@"moreSegue"])
    {
        self.detailViewController = (DetailViewController *)segue.destinationViewController;
        self.detailViewController.loadedToolData = self.selectedRental.tool;
    }
}
@end
