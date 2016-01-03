//
//  AccountTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/2/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "AccountTableViewController.h"
#import "UserManager.h"

@interface AccountTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@end

@implementation AccountTableViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailCell.detailTextLabel.text = [UserManager sharedInstance].getCurrentUser.email;
    self.companyCell.detailTextLabel.text = [UserManager sharedInstance].getCurrentUser.company;
    self.versionCell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
