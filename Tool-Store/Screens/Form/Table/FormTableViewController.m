//
//  FormTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "FormTableViewController.h"
#import "FormTableViewCell.h"

@interface FormTableViewController () <FormTableViewCellDelegate>
@property (strong, nonatomic) NSMutableArray *tableData;
@end

@implementation FormTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableData = [NSMutableArray new];
    self.tableView.tableFooterView = [UIView new];
}
-(void)refreshTableData:(NSMutableArray *)data
{
    [self.tableData removeAllObjects];
    [self.tableData addObjectsFromArray:data];
    [self.tableView reloadData];
}
-(void)formSubmitted:(Form *)formData
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(formSubmitted:)])
        {
            [self.delegate formSubmitted:formData];
        }
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FormTableViewCell";
    FormTableViewCell *cell = (FormTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (FormTableViewCell *)[nib objectAtIndex:0];
    }
    [self configureCell:cell atIndexPath:indexPath];
    cell.delegate = self;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)configureCell:(FormTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Form *form = (Form *)[self.tableData objectAtIndex:indexPath.section];
    [cell setCellData:form];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Form *form = (Form *)[self.tableData objectAtIndex:section];
    return form.formTitle;
}
@end
