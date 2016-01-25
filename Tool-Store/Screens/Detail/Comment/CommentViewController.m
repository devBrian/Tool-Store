//
//  CommentViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/23/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "CommentViewController.h"
#import "AppDelegate.h"
#import "UserManager.h"
#import "CommentTableViewController.h"
#import "Functions.h"
#import "InputTextViewController.h"
#import "KeyboardManager.h"

@interface CommentViewController () <CommentTableViewControllerDelegate, InputTextViewControllerDelegate>
@property (strong, nonatomic) CommentTableViewController *commentTableViewController;
@property (strong, nonatomic) InputTextViewController *inputTextViewController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputContainerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;
@property (weak, nonatomic) IBOutlet UIView *tableContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomInputConstraint;
@end

@implementation CommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Comments";
    [self.commentTableViewController refreshTableData:[self.loadedToolData.comments allObjects].mutableCopy];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)createCommentWithText:(NSString *)text
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:context];
    comment.user = [UserManager sharedInstance].getCurrentUser;
    comment.comment_text = text;
    comment.post_date = [NSDate date];
    comment.tool = self.loadedToolData;
    comment.author =  [UserManager sharedInstance].getCurrentUser.email;
    NSError *error;
    if (![context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    [[self.loadedToolData.comments allObjects].mutableCopy addObject:comment];
    [self.commentTableViewController refreshTableData:[self.loadedToolData.comments allObjects].mutableCopy];
}
-(void)deleteComment:(Comment *)comment atIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:comment];
    NSError *error;
    if (![context save:&error])
    {
        [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
    }
    [self.commentTableViewController.tableData removeObject:comment];
    [self.commentTableViewController.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - InputViewController Delegate
-(void)sendInputText:(NSString *)text
{
    [self createCommentWithText:text];
}
-(void)updateContainerPosition:(CGFloat)bottom
{
    [UIView animateWithDuration:0.1f animations:^{
        self.bottomInputConstraint.constant = bottom;
        [self.view layoutIfNeeded];
    }];
}
-(void)updateContainerHeight:(CGFloat)height
{
    self.inputContainerHeightConstraint.constant = height;
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"commentTable"])
    {
        self.commentTableViewController = (CommentTableViewController *)segue.destinationViewController;
        self.commentTableViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"input"])
    {
        self.inputTextViewController = (InputTextViewController *)segue.destinationViewController;
        self.inputTextViewController.delegate = self;
    }
}
@end
