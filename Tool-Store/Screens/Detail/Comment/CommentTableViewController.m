//
//  CommentTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentTableViewCell.h"
#import "AppDelegate.h"
#import "UserManager.h"

@interface CommentTableViewController ()
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation CommentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [NSMutableArray new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
}
-(void)refreshTableData:(NSMutableArray *)data
{
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:data];
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CommentTableViewCell";
    CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)configureCell:(CommentTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = (Comment *)[self.tableData objectAtIndex:indexPath.row];
    [cell setCellData:comment];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Comments";
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = (Comment *)[self.tableData objectAtIndex:indexPath.row];
    if ([[UserManager sharedInstance].getCurrentUser.email isEqualToString:comment.author])
    {
        return YES;
    }
    return NO;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Comment *comment = (Comment *)[self.tableData objectAtIndex:indexPath.row];
        [self.delegate deleteComment:comment];
    }
}
@end
