//
//  AccountTableViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/2/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "AccountTableViewController.h"
#import "UserManager.h"
#import "Functions.h"
#import "SignInViewController.h"
#import "Form.h"
#import "FormViewController.h"

@interface AccountTableViewController () <FormViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *buildCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *joinCell;
@property (nonatomic, strong) NSMutableArray *formData;
@end

@implementation AccountTableViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailCell.detailTextLabel.text = [UserManager sharedInstance].getCurrentUser.email;
    self.companyCell.detailTextLabel.text = [UserManager sharedInstance].getCurrentUser.company;
    self.versionCell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.buildCell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.joinCell.detailTextLabel.text = [Functions stringFromDate:[UserManager sharedInstance].getCurrentUser.joined_date];
    self.tableView.tableFooterView = [UIView new];
    self.formData = [NSMutableArray new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                Form *form = [Form new];
                form.form_id = 1;
                form.formText = [UserManager sharedInstance].getCurrentUser.email;
                form.formTitle = @"Email";
                form.formPlaceholder = @"Email";
                form.keyboardType = UIKeyboardTypeEmailAddress;
                form.returnKeyType = UIReturnKeyDone;
                [self.formData removeAllObjects];
                [self.formData addObject:form];
                
                [self performSegueWithIdentifier:@"formSegue" sender:self];
            }
            else if (indexPath.row == 1)
            {
                
                Form *form = [Form new];
                form.form_id = 1;
                form.formText = [UserManager sharedInstance].getCurrentUser.company;
                form.formTitle = @"Company";
                form.formPlaceholder = @"Company";
                form.keyboardType = UIKeyboardTypeDefault;
                form.returnKeyType = UIReturnKeyDone;
                [self.formData removeAllObjects];
                [self.formData addObject:form];
                
                [self performSegueWithIdentifier:@"formSegue" sender:self];
            }
            else if (indexPath.row == 2)
            {
                Form *form = [Form new];
                form.form_id = 1;
                form.formText = @"";
                form.formTitle = @"Password";
                form.formPlaceholder = @"Password";
                form.keyboardType = UIKeyboardTypeDefault;
                form.returnKeyType = UIReturnKeyNext;
                form.isSecure = YES;
                
                Form *form1 = [Form new];
                form1.form_id = 2;
                form1.formText = @"";
                form1.formTitle = @"New Password";
                form1.formPlaceholder = @"New Password";
                form1.keyboardType = UIKeyboardTypeDefault;
                form1.returnKeyType = UIReturnKeyNext;
                form1.isSecure = YES;
                
                Form *form2 = [Form new];
                form2.form_id = 3;
                form2.formText = @"";
                form2.formTitle = @"Confirm new password";
                form2.formPlaceholder = @"Confirm new password";
                form2.keyboardType = UIKeyboardTypeDefault;
                form2.returnKeyType = UIReturnKeyDone;
                form2.isSecure = YES;
                
                [self.formData removeAllObjects];
                [self.formData addObjectsFromArray:@[form,form1,form2]];
                
                [self performSegueWithIdentifier:@"formSegue" sender:self];
                
            }
            break;
            }
        case 1:
        {
            if (indexPath.row == 2)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sign out?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Sign out" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[UserManager sharedInstance] signOut];
                    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"signInViewController"];
                    [self.navigationController showViewController:navController sender:self];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
        }
            
        default:
            break;
    }
}
-(void)formSubmitted:(NSMutableArray *)formData
{
    if ([formData count] == 1)
    {
        Form *form = (Form *)formData.firstObject;
        if ([form.formTitle isEqualToString:@"Email"] == YES)
        {
            NSString *newEmail = form.formText;
            if (NSStringIsValidEmail(newEmail, YES) == YES)
            {
                [UserManager sharedInstance].getCurrentUser.email = newEmail;
                [[UserManager sharedInstance] saveUser:[UserManager sharedInstance].getCurrentUser completion:^(NSError *error) {
                    if (error != nil)
                    {
                        [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
                    }
                    else
                    {
                        self.emailCell.detailTextLabel.text = newEmail;
                    }
                }];
            }
            else
            {
                [Functions showErrorWithMessage:@"Your email is in Bad format" forViewController:self];
            }
        }
        else if ([form.formTitle isEqualToString:@"Company"] == YES)
        {
            NSString *newCompany = form.formText;
            if (newCompany.length >= 3)
            {
                [UserManager sharedInstance].getCurrentUser.company = newCompany;
                [[UserManager sharedInstance] saveUser:[UserManager sharedInstance].getCurrentUser completion:^(NSError *error) {
                    if (error != nil)
                    {
                        [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
                    }
                    else
                    {
                        self.companyCell.detailTextLabel.text = newCompany;
                    }
                }];
            }
            else
            {
                [Functions showErrorWithMessage:@"Too short (3)" forViewController:self];
            }
        }
    }
    else
    {
        Form *form = (Form *)formData.firstObject;
        NSString *password = form.formText;
        if ([password isEqualToString:[UserManager sharedInstance].getCurrentUser.password])
        {
            Form *form1 = (Form *)formData[1];
            Form *form2 = (Form *)formData.lastObject;
            NSString *newPassword = form1.formText;
            NSString *confirmNewPassword = form2.formText;
            
            if ([newPassword isEqualToString:confirmNewPassword])
            {
                [UserManager sharedInstance].getCurrentUser.password = newPassword;
                [[UserManager sharedInstance] saveUser:[UserManager sharedInstance].getCurrentUser completion:^(NSError *error) {
                    //
                }];
            }
            else
            {
                [Functions showErrorWithMessage:@"Passwords do not match" forViewController:self];
            }
        }
        else
        {
            [Functions showErrorWithMessage:@"Password incorrect" forViewController:self];
        }
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"formSegue"])
    {
        FormViewController *vc = (FormViewController *)segue.destinationViewController;
        vc.delegate = self;
        vc.loadedFormData = self.formData;
    }
}
@end
