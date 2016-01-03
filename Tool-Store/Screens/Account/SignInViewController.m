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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([[UserManager sharedInstance] isLoggedIn] == YES)
    {
        [self performSegueWithIdentifier:@"main" sender:self];
    }
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
            [Functions showErrorWithMessage:@"Email too short. (3)" forViewController:self];
        }
        return NO;
    }
    if (NSStringIsValidEmail(email, YES) == NO)
    {
        if (showError)
        {[Functions showErrorWithMessage:@"Email format not valid." forViewController:self];
          
        }
        return NO;
    }
    if (password.length < 3)
    {
        if (showError)
        {
            [Functions showErrorWithMessage:@"Password too short. (3)" forViewController:self];
        }
        return NO;
    }
    if (![[UserManager sharedInstance] userExistsWithEmail:email andPassword:password])
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
