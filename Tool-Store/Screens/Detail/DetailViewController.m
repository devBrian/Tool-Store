//
//  DetailViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "DetailViewController.h"
#import "CommentTableViewController.h"
#import "Functions.h"
#import "AppDelegate.h"
#import "Comment.h"
#import "UserManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DetailViewController () <CommentTableViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *manufactorLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *stockLabel;
@property (weak, nonatomic) IBOutlet UILabel *originLabel;
@property (strong, nonatomic) CommentTableViewController *commentTable;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.loadedToolData.name;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"post_date" ascending:NO];
    NSArray *sortedArray = [[self.loadedToolData.comments allObjects].mutableCopy sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.commentTable refreshTableData:sortedArray.mutableCopy];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.loadedToolData.image_url]];
    self.manufactorLabel.text = [NSString stringWithFormat:@"Made by: %@", self.loadedToolData.manufacturer];
    self.ratingLabel.text = [NSString stringWithFormat:@"Condition: %@", self.loadedToolData.condition];
    self.rentDurationLabel.text = [NSString stringWithFormat:@"%i days", [self.loadedToolData.rent_duration intValue]];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.loadedToolData.rent_price floatValue]];
    self.stockLabel.text = [NSString stringWithFormat:@"Stock: %i",  [self.loadedToolData.stock intValue]];
    self.originLabel.text = self.loadedToolData.origin;
}
- (IBAction)commentAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.loadedToolData.name message:@"Add a comment" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        UITextField *textField = alertController.textFields.firstObject;
        if (textField.text.length > 0)
        {
            [self createCommentWithText:textField.text];
        }
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"Comment";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
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
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"post_date" ascending:NO];
    NSArray *sortedArray = [[self.loadedToolData.comments allObjects].mutableCopy sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.commentTable refreshTableData:sortedArray.mutableCopy];
}
-(void)deleteComment:(Comment *)comment
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:comment];
    NSError *error;
    if (![context save:&error])
    {
        [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
    }
    [self.commentTable.tableView reloadData];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"commentTable"])
    {
        self.commentTable = (CommentTableViewController *)segue.destinationViewController;
        self.commentTable.delegate = self;
    }
}
@end
