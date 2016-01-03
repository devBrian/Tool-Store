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
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *formFields;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *joinedLabel;
@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[KeyboardManager sharedInstance] setScrollViewContainer:self.scrollView];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.loadedUserData)
    {
        self.joinedLabel.text = [NSString stringWithFormat:@"Joined: %@",[Functions stringFromDate:self.loadedUserData.joined_date]];
        self.emailTextField.text = self.loadedUserData.email;
        self.companyTextField.text = self.loadedUserData.company;
        self.passwordTextField.placeholder = @"old Password";
        self.confirmPasswordTextField.placeholder = @"new password";
        
        self.cancelButton.hidden = NO;
        self.saveButton.hidden = NO;
        self.submitButton.hidden = YES;
        self.joinedLabel.hidden = NO;
    }
    [self.navigationController setNavigationBarHidden:NO];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(IBAction)saveAction:(id)sender
{
    if ([self saveFormValidation:YES])
    {
        if ([self accountCredentialsChanged])
        {
            self.loadedUserData.email = self.emailTextField.text;
            self.loadedUserData.company = self.companyTextField.text;
            if (self.confirmPasswordTextField.text.length > 0)
            {
               self.loadedUserData.password = self.confirmPasswordTextField.text;
            }
            else
            {
                self.loadedUserData.password = self.passwordTextField.text;
            }
            [[UserManager sharedInstance] saveUser:self.loadedUserData completion:^(NSError *error) {
                if (error)
                {
                    [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
                }
                else
                {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
-(IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        [[KeyboardManager sharedInstance] hideKeyboard]; // Addresses if textfield is under while hitting Next.
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordTextField)
    {
        if (self.loadedUserData)
        {
            [self saveAction:nil];
        }
        else
        {
           [self submitAction:nil];
        }
    }
    else
    {
        [[KeyboardManager sharedInstance] hideKeyboard];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)accountCredentialsChanged
{
    NSString *email = self.emailTextField.text;
    NSString *company = self.companyTextField.text;
    NSString *newPassword = self.confirmPasswordTextField.text;
    
    if (newPassword.length > 0)
    {
        return YES;
    }
    if (![email isEqualToString:self.loadedUserData.email])
    {
        return YES;
    }
    if (![company isEqualToString:self.loadedUserData.company])
    {
        return YES;
    }
    return NO;
}
#pragma mark - Form Validation
-(BOOL)saveFormValidation:(BOOL)showError
{
    NSString *email = self.emailTextField.text;
    NSString *oldPassword = self.passwordTextField.text;
    
    if (email.length < 3)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Email too short. (3)" forViewController:self];
        }
        return NO;
    }
    if (NSStringIsValidEmail(email, YES) == NO)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Email format is invalid." forViewController:self];
        }
        return NO;
    }
    if (oldPassword.length < 3)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Please specify your current password to continue." forViewController:self];
        }
        return NO;
    }
    if (![self.loadedUserData.password isEqualToString:oldPassword])
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Invalid Email or Password." forViewController:self];
        }
        return NO;
    }
    return YES;
}
-(BOOL)formValidation:(BOOL)showError
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;

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
    if (confirmPassword.length < 3)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Confirm password falls short. (3)" forViewController:self];
        }
        return NO;
    }
    if ([password isEqualToString:confirmPassword] == NO)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Passwords mismatch." forViewController:self];
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
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
