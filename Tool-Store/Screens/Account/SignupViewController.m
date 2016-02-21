//
//  SignupViewController.m
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "SignupViewController.h"
#import "User.h"
#import "UserManager.h"
#import "KeyboardManager.h"
#import "Constants.h"
#import "Functions.h"
#import "AppDelegate.h"

@interface SignupViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *formFields;
@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - IBActions
-(IBAction)submitAction:(id)sender
{
    if ([self formValidation:YES])
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        User *user = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        user.email = self.emailTextField.text;
        user.company = self.companyTextField.text;
        user.password = self.passwordTextField.text;
        user.joined_date = [NSDate date];
        [[UserManager sharedInstance] insertUser:user completion:^(NSError *error) {
            if (error)
            {
                [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark - UITextfield Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [self.companyTextField becomeFirstResponder];
    }
    else if (textField == self.companyTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
    {
        [self submitAction:nil];
    }
    else
    {
        [self.view endEditing:YES];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)formValidation:(BOOL)showError
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;

    if (email.length < 3)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"It appears your email falls short. (min 3)" forViewController:self];
        }
        return NO;
    }
    if (NSStringIsValidEmail(email, YES) == NO)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"It appears your email is not valid." forViewController:self];
        }
        return NO;
    }
    if (password.length < 3)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"It appears your password falls short. (min 3)" forViewController:self];
        }
        return NO;
    }
    if ([[UserManager sharedInstance] userExistsWithEmail:email])
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Invalid email or password." forViewController:self];
        }
        return NO;
    }
    return YES;
}
@end
