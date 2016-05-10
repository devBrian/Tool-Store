//
//  ToolsTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "ToolsTableViewController.h"
#import "ToolsTableViewCell.h"
#import "AppDelegate.h"
#import "Functions.h"
#import "UIScrollView+EmptyDataSet.h"

#define BATCH_SIZE 25

@interface ToolsTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation ToolsTableViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}
-(void)fetchDataWithCompletion:(void (^)(NSError *error))completion
{
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        completion(error);
    }
    completion(error);
}
#pragma mark - DZNEmptyDataSet
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_store"];
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Sorry, we did not find a match. Please try again.";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Tip: Double check your spelling";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
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
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ToolsTableViewCell";
    ToolsTableViewCell *cell = (ToolsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ToolsTableViewCell *)[nib objectAtIndex:0];
    }
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
-(void)configureCell:(ToolsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Tool *tool = (Tool *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setCellData:tool];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.toolsDelegate != nil)
    {
        if ([self.toolsDelegate respondsToSelector:@selector(moreTool:)])
        {
            [self.tableView setEditing:NO animated:YES];
            Tool *tool = (Tool *)[self.fetchedResultsController objectAtIndexPath:indexPath];
            [self.toolsDelegate moreTool:tool];
        }
    }
}
#pragma mark - Fetched results controller
- (NSFetchedResultsController *)fetchedResultsController
{
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        // Create the fetch request for the entity.
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setFetchBatchSize:BATCH_SIZE];
        // Edit the entity name as appropriate.
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tool" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        if (self.searchText && self.searchText.length > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", self.searchText];
            [fetchRequest setPredicate:predicate];
        }
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortByName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSSortDescriptor *sortByPrice = [[NSSortDescriptor alloc] initWithKey:@"rent_price" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortByName,sortByPrice]];
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = aFetchedResultsController;
    }
    return _fetchedResultsController;
}
#pragma mark - Fetched results controller Delegate
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id) anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(ToolsTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
           [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
@end
