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
#import "UIScrollView+EmptyDataSet.h"

@interface CommentTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation CommentTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [NSMutableArray new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark - Public
-(void)refreshTableData:(NSMutableArray *)data
{
    [self.tableData removeAllObjects];
    NSSortDescriptor *nameDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"post_date" ascending:YES];
    NSArray *sortedArray = [data sortedArrayUsingDescriptors:[NSArray arrayWithObject:nameDescriptor]];
    [self.tableData addObjectsFromArray:sortedArray];
    [self.tableView reloadData];
    [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.25f];
}
-(void)scrollToBottom
{
    if ([self.tableData count] > 0)
    {
        NSIndexPath *bottomIndexPath = [NSIndexPath indexPathForRow:[self.tableData count]-1 inSection:0];
        if ([self.tableView.indexPathsForVisibleRows containsObject:bottomIndexPath] == NO)
        {
            [self.tableView scrollToRowAtIndexPath:bottomIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_chat"];
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Be the first";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Comment about the Tool";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
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
    if ([self.tableData count] > 0)
    {
        return @"Comments";
    }
    else
    {
        return @"";
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = (Comment *)[self.tableData objectAtIndex:indexPath.row];
    if ([[UserManager sharedInstance].getCurrentUser.email isEqualToString:comment.author])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Comment *comment = (Comment *)[self.tableData objectAtIndex:indexPath.row];
        [self.delegate deleteComment:comment atIndexPath:indexPath];
    }
}
@end
