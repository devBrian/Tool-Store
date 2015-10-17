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

@interface MainViewController () <MainTableViewControllerDelegate>
@property (strong, nonatomic) MainTableViewController *mainTableViewController;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[NSUserDefaults standardUserDefaults] setObject:[[UserManager sharedInstance] getCurrentUser].email forKey:LAST_EMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
-(void)selectedRental:(Rental *)rental
{
    // TODO: Product detail screen
}
-(void)returnRental:(Rental *)rental
{
    if ([Functions isDateOverDue:rental.due_date])
    {
        [Functions showErrorWithMessage:[NSString stringWithFormat:@"Rental is overdue! You will be charged %.2f.", [rental.tool.overdue_fee floatValue]] forViewController:self];
    }
    if ([rental.quantity intValue] == 1)
    {
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
            
        }];
        self.mainTableViewController.mainTableDelegate = self;
    }
}
@end
