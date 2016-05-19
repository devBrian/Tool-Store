//
//  HomeViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 2/21/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "HomeViewController.h"
#import "UserManager.h"
#import "Rental.h"
#import "Functions.h"

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageLabel.text = [self statusMessage];
    if ([self.messageLabel.text containsString:@"Invite"] == NO)
    {
        self.messageLabel.textColor = [UIColor colorWithRed:0.850 green:0.218 blue:0.159 alpha:1.000];
    }
}
-(NSString *)statusMessage
{
    NSString *message = @"Invite your family and friends to test out the app";
    NSSet *rentals = [UserManager sharedInstance].getCurrentUser.rental;
    NSArray *rents = [rentals allObjects];
    for (Rental *rental in rents)
    {
        NSInteger days = [Functions differenceInDays:[NSDate date] toDate:rental.due_date];
        if (days < 0)
        {
            message = @"You have rentals that are pass due.";
            break;
        }
        else if (days < 1)
        {
            message = @"You have rentals that will be due soon.";
            break;
        }
    }
    return message;
}
- (IBAction)shareAction:(id)sender
{
    NSString *string = @"Check out this app called Rent a Tool. You rent a tool and return it, it's that easy.";
    NSURL *URL = [NSURL URLWithString:@""];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[string, URL] applicationActivities:nil];
    [self.navigationController presentViewController:activityViewController animated:YES completion:nil];
}
@end
