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
#import "ToolManager.h"
#import "RentalManager.h"

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tapGesture];
}
#pragma mark - MainTableViewController Delegate
-(void)moreRental:(Rental *)rental
{
    self.selectedRental = rental;
    [self performSegueWithIdentifier:@"moreSegue" sender:self];
}
-(void)returnRental:(Rental *)rental
{
    NSString *errorMessage = [[RentalManager sharedInstance] returnRental:rental];
    if (errorMessage.length > 0)
    {
       [Functions showErrorWithMessage:errorMessage forViewController:self];
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainTable"])
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
