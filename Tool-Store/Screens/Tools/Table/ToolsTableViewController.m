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

#define BATCH_SIZE 25

@interface ToolsTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *searchText;
@end

@implementation ToolsTableViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100.0f;
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
#pragma mark - Search bar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2)
    {
        self.searchText = searchText;
        self.fetchedResultsController = nil;
        [self fetchDataWithCompletion:^(NSError *error) {
            [self.tableView reloadData];
        }];
    }
    else if (searchText.length == 0)
    {
        [searchBar resignFirstResponder];
        self.searchText = @"";
        self.fetchedResultsController = nil;
        [self fetchDataWithCompletion:^(NSError *error) {
             [self.tableView reloadData];
        }];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
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
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray new];
    UITableViewRowAction *rentAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"Rent" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.toolsDelegate != nil)
        {
            if ([self.toolsDelegate respondsToSelector:@selector(selectedTool:)])
            {
                [self.tableView setEditing:NO animated:YES];
                Tool *tool = (Tool *)[self.fetchedResultsController objectAtIndexPath:indexPath];
                [self.toolsDelegate selectedTool:tool];
            }
        }
    }];
    rentAction.backgroundColor = [UIColor colorWithRed:0.278 green:0.185 blue:0.593 alpha:1.000];
    
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"More" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.toolsDelegate != nil)
        {
            if ([self.toolsDelegate respondsToSelector:@selector(moreTool:)])
            {
                [self.tableView setEditing:NO animated:YES];
                Tool *tool = (Tool *)[self.fetchedResultsController objectAtIndexPath:indexPath];
                [self.toolsDelegate moreTool:tool];
            }
        }
    }];
    moreAction.backgroundColor = [UIColor colorWithRed:0.154 green:0.413 blue:0.691 alpha:1.000];
    Tool *tool = (Tool *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([tool.stock intValue] > 0)
    {
        [array addObject:moreAction];
        [array addObject:rentAction];
    }
    else
    {
        [array addObject:moreAction];
    }
    return array;
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
