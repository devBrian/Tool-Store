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
#import "UIScrollView+EmptyDataSet.h"

@interface MainTableViewController () <NSFetchedResultsControllerDelegate, UISearchBarDelegate, MainTableViewCellDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *searchText;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, assign) BOOL isSearching;
@end

@implementation MainTableViewController
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88.0f;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.tableView.emptyDataSetVisible == NO)
    {
        self.searchBar.hidden = NO;
    }
    else
    {
        self.searchBar.hidden = YES;
    }
}
#pragma mark - Public
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
#pragma mark - UISearchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 2)
    {
        self.searchText = searchText;
        self.fetchedResultsController = nil;
        [self fetchDataWithCompletion:^(NSError *error) {
            self.isSearching = YES;
            [self.tableView reloadData];
        }];
    }
    else if (searchText.length == 0)
    {
        [searchBar resignFirstResponder];
        self.searchText = @"";
        self.fetchedResultsController = nil;
        [self fetchDataWithCompletion:^(NSError *error) {
            self.isSearching = YES;
            [self.tableView reloadData];
        }];
    }
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.isSearching = NO;
}
#pragma mark - MainTableViewCell Delegate
-(void)returnRental:(Rental *)rental
{
    if (self.mainTableDelegate != nil)
    {
        if ([self.mainTableDelegate respondsToSelector:@selector(returnRental:)])
        {
            [self.mainTableDelegate returnRental:rental];
        }
    }
}
#pragma mark - DZNEmptyDataSet
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"ic_build"];
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isSearching == NO)
    {
        self.searchBar.hidden = YES;
        NSString *text = @"You haven't rented a tool yet.";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                     NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    else
    {
        NSString *text = @"Sorry, we did not find a match. Please try again.";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                     NSForegroundColorAttributeName: [UIColor darkGrayColor]};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isSearching == NO)
    {
        NSString *text = @"Visit the store and start picking out some tools today.";
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    else
    {
        NSString *text = @"Tip: Double check your spelling.";
        NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        paragraph.alignment = NSTextAlignmentCenter;
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13.0f],
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                     NSParagraphStyleAttributeName: paragraph};
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.fetchedResultsController sections] count];
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
    cell.delegate = self;
    [cell setCellData:rental];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [NSMutableArray new];
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
    moreAction.backgroundColor = [UIColor colorWithRed:0.154 green:0.413 blue:0.691 alpha:1.000];
    [array addObject:moreAction];
    return array;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return sectionInfo.name;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
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
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rent_date" ascending:NO];
        [fetchRequest setSortDescriptors:@[sortDescriptor]];
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"day" cacheName:nil];
        aFetchedResultsController.delegate = self;
        _fetchedResultsController = aFetchedResultsController;
    }
    return _fetchedResultsController;
}
#pragma mark - NSFetchedResultsController Delegate
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id) anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
        {
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeDelete:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeUpdate:
        {
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
        case NSFetchedResultsChangeMove:
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
@end
