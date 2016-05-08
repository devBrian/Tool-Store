//
//  DetailTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailMainTableViewCell.h"
#import "DetailSubTableViewCell.h"
#import "CommentTableViewCell.h"

@interface DetailTableViewController () <DetailMainTableViewCellDelegate>

@end

@implementation DetailTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [NSMutableArray new];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [UIView new];
}
-(void)refreshTableData:(NSMutableArray *)data
{
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:data];
    [self.tableView reloadData];
}
-(void)rentAction:(id)sender
{
    [self.delegate rentAction:sender];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    switch (section)
    {
        case 0:
            numberOfRows = 1;
            break;
        case 1:
        case 2:
        {
            NSArray *args = [[NSArray alloc] initWithArray:[self.tableData objectAtIndex:section]];
            numberOfRows = args.count;
            break;
        }
        default:
            break;
    }
    return numberOfRows;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 250.0f;
    }
    else if (indexPath.section == 1)
    {
        return 44.0f;
    }
    else if (indexPath.section == 2)
    {
        return 100.0f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return @"Detail";
    }
    else if (section == 2)
    {
        NSArray *args = [[NSArray alloc] initWithArray:[self.tableData objectAtIndex:section]];
        if (args.count == 0)
        {
            return @"Be the first to comment on the tool today";
        }
        else
        {
            return @"Comments";
        }
        
    }
    return [super tableView:tableView titleForHeaderInSection:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            DetailMainTableViewCell *cell = (DetailMainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailMainTableViewCell" forIndexPath:indexPath];
            cell.delegate = self;
            [cell setCellData:[self.tableData objectAtIndex:indexPath.section]];
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
            break;
        }
        case 1:
        {
            DetailSubTableViewCell *cell = (DetailSubTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DetailSubTableViewCell" forIndexPath:indexPath];
            NSArray *args = [[NSArray alloc] initWithArray:[self.tableData objectAtIndex:indexPath.section]];
            [cell setCellData:[args objectAtIndex:indexPath.row]];
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
            break;
        }
        case 2:
        {
            CommentTableViewCell *cell = (CommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentTableViewCell" forIndexPath:indexPath];
            NSArray *args = [[NSArray alloc] initWithArray:[self.tableData objectAtIndex:indexPath.section]];
            [cell setCellData:[args objectAtIndex:indexPath.row]];
            [cell setNeedsUpdateConstraints];
            [cell updateConstraintsIfNeeded];
            return cell;
            break;
        }
        default:
        {
            UITableViewCell *cell;
            return cell;
            break;
        }
    }
}
@end
