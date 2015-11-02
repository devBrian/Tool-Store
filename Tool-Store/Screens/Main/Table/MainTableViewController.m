//
//  MainTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "AppDelegate.h"
#import "UserManager.h"

@interface MainTableViewController () <NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *searchText;
@end

@implementation MainTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 66.0f;
}
-(void)fetchDataWithCompletion:(void (^)(NSError *error))completion
{
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
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
            if ([[[self.fetchedResultsController sections] objectAtIndex:0] numberOfObjects] > 0)
            {
                [self.tableView reloadData];
            }
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
    static NSString *cellIdentifier = @"MainTableViewCell";
    MainTableViewCell *cell = (MainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (MainTableViewCell *)[nib objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)configureCell:(MainTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Rental *rental = (Rental *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setCellData:rental];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray new];
    UITableViewRowAction *returnAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Return" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.mainTableDelegate != nil)
        {
            if ([self.mainTableDelegate respondsToSelector:@selector(returnRental:)])
            {
                [self.tableView setEditing:NO animated:YES];
                Rental *rental = (Rental *)[self.fetchedResultsController objectAtIndexPath:indexPath];
                [self.mainTableDelegate returnRental:rental];
            }
        }
    }];
    UITableViewRowAction *moreAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"More" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.mainTableDelegate != nil)
        {
            if ([self.mainTableDelegate respondsToSelector:@selector(moreRental:)])
            {
                [self.tableView setEditing:NO animated:YES];
                Rental *rental = (Rental *)[self.fetchedResultsController objectAtIndexPath:indexPath];
                [self.mainTableDelegate moreRental:rental];
            }
        }
    }];
    [array addObject:moreAction];
    [array addObject:returnAction];
    return array;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"My Rentals";
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
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Rental"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user == %@", [UserManager sharedInstance].getCurrentUser];
        [fetchRequest setPredicate:predicate];
        if (self.searchText.length > 0)
        {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tool.name CONTAINS[cd] %@", self.searchText];
            [fetchRequest setPredicate:predicate];
        }
        // Edit the sort key as appropriate.
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"due_date" ascending:YES];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = aFetchedResultsController;
    }
    return _fetchedResultsController;
}
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id) anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(MainTableViewCell *)[self.tableView
                                 cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray
                                                    arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
@end
