//
//  ViewController.m
//  KeyboardExample
//
//  Created by Brian Sinnicke on 4/1/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "SignInViewController.h"
#import "User.h"
#import "UserManager.h"
#import "Functions.h"
#import "Constants.h"
#import "KeyboardManager.h"
#import "AppDelegate.h"

@interface SignInViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@end

@implementation SignInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Sign In";
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.emailTextField.text = @"";
    self.passwordTextField.text = @"";
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[KeyboardManager sharedInstance] setScrollViewContainer:self.scrollView];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.emailTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (textField == self.passwordTextField)
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
#pragma mark - IBActions
-(IBAction)submitAction:(id)sender
{
    if ([self formValidation:YES])
    {
        [self performSegueWithIdentifier:@"main" sender:self];
    }
}
#pragma mark - Form Validation
-(BOOL)formValidation:(BOOL)showError
{
    NSString *email = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;

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
    if (![[UserManager sharedInstance] userExistsWithEmail:email andPassword:password])
    {
        if (showError)
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"My records indicate that account does not exist." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        return NO;
    }
    return YES;
}
#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}
@end
