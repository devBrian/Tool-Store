//
//  HistoryViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import "HistoryViewController.h"
#import "HistoryTableViewController.h"

@interface HistoryViewController ()
@property (nonatomic, strong) HistoryTableViewController *historyTableViewController;
@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"historyTable"])
    {
        self.historyTableViewController = (HistoryTableViewController *)segue.destinationViewController;
    }
}
@end
