//
//  FormViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "FormViewController.h"
#import "FormTableViewController.h"
#import "Form.h"

@interface FormViewController () <FormTableViewControllerDelegate>
@property (nonatomic, strong) FormTableViewController *formTableViewController;
@property (nonatomic, strong) Form *formItem;
@end

@implementation FormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submit)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.title = @"Edit";
    [self.formTableViewController refreshTableData:self.loadedFormData];
    self.formItem = self.loadedFormData.lastObject;
}
-(void)cancel
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)submit
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(formSubmitted:)])
        {
            [self.delegate formSubmitted:self.loadedFormData];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)formSubmitted:(Form *)formData
{
    NSInteger index = 0;
    for (Form *data in self.loadedFormData)
    {
        if (data.form_id == formData.form_id)
        {
            break;
        }
        index++;
    }
    [self.loadedFormData replaceObjectAtIndex:index withObject:formData];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"formTable"])
    {
        self.formTableViewController = (FormTableViewController *)segue.destinationViewController;
        self.formTableViewController.delegate = self;
    }
}

@end
