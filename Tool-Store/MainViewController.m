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


@interface MainViewController () <MainTableViewControllerDelegate>
@property (strong, nonatomic) MainTableViewController *mainTableViewController;
@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", [[UserManager sharedInstance] getCurrentUser].email);
    NSLog(@"%@", [[UserManager sharedInstance] getCurrentUser].company);
    NSLog(@"%@", [[UserManager sharedInstance] getCurrentUser].password);
    
    // TODO: Refresh data after user chooses tools
//    if (self.mainTableViewController)
//    {
//       [self.mainTableViewController refreshData];
//    }
}
-(IBAction)accountAction:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Actions" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [actionSheet dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Change Account Details" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
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
    
}
-(void)returnRental:(Rental *)rental
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:rental];
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't delete: %@", [error localizedDescription]);
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
        [self.mainTableViewController refreshData];
        self.mainTableViewController.mainTableDelegate = self;
    }
}
@end
