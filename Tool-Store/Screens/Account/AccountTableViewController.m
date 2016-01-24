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

@interface AccountTableViewController ()
@property (weak, nonatomic) IBOutlet UITableViewCell *emailCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *companyCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *versionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *joinCell;
@end

@implementation AccountTableViewController

#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailCell.detailTextLabel.text = [UserManager sharedInstance].getCurrentUser.email;
    self.companyCell.detailTextLabel.text = [UserManager sharedInstance].getCurrentUser.company;
    self.versionCell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.joinCell.detailTextLabel.text = [Functions stringFromDate:[UserManager sharedInstance].getCurrentUser.joined_date];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit Email" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = [UserManager sharedInstance].getCurrentUser.email;
                    textField.keyboardType = UIKeyboardTypeEmailAddress;
                    textField.autocorrectionType = UITextAutocorrectionTypeNo;
                }];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *newEmail = alertController.textFields[0].text;
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
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if (indexPath.row == 1)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit Company" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = [UserManager sharedInstance].getCurrentUser.company;
                    textField.keyboardType = UIKeyboardTypeDefault;
                    textField.autocorrectionType = UITextAutocorrectionTypeNo;
                }];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    NSString *newCompany = alertController.textFields[0].text;
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
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else if (indexPath.row == 3)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Edit Password" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Password";
                    textField.secureTextEntry = YES;
                }];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"New Password";
                    textField.secureTextEntry = YES;
                }];
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.placeholder = @"Confirm New Password";
                    textField.secureTextEntry = YES;
                }];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    NSString *password = alertController.textFields[0].text;
                    if ([password isEqualToString:[UserManager sharedInstance].getCurrentUser.password])
                    {
                        NSString *newPassword = alertController.textFields[1].text;
                        NSString *confirmNewPassword = alertController.textFields[2].text;
                        
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
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
            }
        case 3:
        {
            if (indexPath.row == 0)
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sign out?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [[UserManager sharedInstance] signOut];
                    UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"signInViewController"];
                    [self.navigationController showViewController:navController sender:self];
                }]];
                [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            break;
        }
            
        default:
            break;
    }
}
@end
