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
@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[KeyboardManager sharedInstance] setScrollViewContainer:self.scrollView];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
        [[UserManager sharedInstance]insertUser:user completion:^(NSError *error) {
            if (error)
            {
                [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
        [[KeyboardManager sharedInstance] hideKeyboard]; // Addresses if textfield is under while hitting Next.
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else if (textField == self.confirmPasswordTextField)
    {
        [self submitAction:nil];
    }
    else
    {
        [[KeyboardManager sharedInstance] hideKeyboard];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Form Validation
-(BOOL)formValidation:(BOOL)showError
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    NSString *confirmPassword = self.confirmPasswordTextField.text;

    if (email.length < 3)
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"It appears your email falls short. (min 3)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return NO;
    }
    if (NSStringIsValidEmail(email, YES) == NO)
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"It appears your email is not valid." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return NO;
    }
    if (password.length < 3)
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"It appears your password falls short. (min 3)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return NO;
    }
    if (confirmPassword.length < 3)
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"It appears your comfirm password falls short. (min 3)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return NO;
    }
    if ([password isEqualToString:confirmPassword] == NO)
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"It appears your password and confirm password do not match." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return NO;
    }
    if ([[UserManager sharedInstance] userExistsWithEmail:email])
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"My records indicate that account exist already." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
