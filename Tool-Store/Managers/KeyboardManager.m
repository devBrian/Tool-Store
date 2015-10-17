//
//  KeyboardManager.m
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/18/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "KeyboardManager.h"

@interface KeyboardManager()
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIView *view;
@property (nonatomic, assign) BOOL isKeyboardVisible;
@end

@implementation KeyboardManager
#pragma mark - Public
+(KeyboardManager *)sharedInstance
{
    static KeyboardManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KeyboardManager alloc] init];
        sharedInstance.isKeyboardVisible = NO;
        // Do any other initialization stuff here
        [sharedInstance registerForKeyboardNotifications];
    });
    return sharedInstance;
}
-(void)setScrollViewContainer:(UIScrollView *)scrollView
{
    self.view = scrollView;
    self.scrollView = scrollView;
    
    // Register Tap gesture to hide keyboard on taps outside textfields/textviews
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tapGesture];
    
    // Reset the scrollview contentOffset to zero
    if (self.scrollView.contentOffset.x != 0 || self.scrollView.contentOffset.y != 0)
    {
        [self.scrollView setContentOffset:CGPointZero];
    }
}
- (BOOL)isKeyboardVisible
{
    return self.isKeyboardVisible;
}
-(void)hideKeyboard
{
    [self.scrollView setContentOffset:CGPointZero];
    [[self activeFirstResponderView] resignFirstResponder];
    self.isKeyboardVisible = NO;
}
#pragma mark - Private
-(void)dealloc
{
    [self removeKeyboardNotifications];
}
-(void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
-(void)keyboardWasShown:(NSNotification *)notification
{
    self.isKeyboardVisible = YES;
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [self adjustScrollViewToShowKeyViews:keyboardFrame];
}
-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    [self hideKeyboard];
}
-(void)adjustScrollViewToShowKeyViews:(CGRect)keyboardFrame
{
    CGRect keyPadFrame = [[UIApplication sharedApplication].keyWindow convertRect:keyboardFrame fromView:self.view];
    CGSize kbSize = keyPadFrame.size;
    
    CGRect activeRect = [self.view convertRect:[self activeFirstResponderView].frame fromView:[self activeFirstResponderView].superview];
    activeRect = CGRectMake(activeRect.origin.x, activeRect.origin.y + activeRect.size.height, activeRect.size.width, activeRect.size.height); // Plus height of view
    
    CGRect visibleRect = self.view.bounds;
    visibleRect.size.height -= (kbSize.height);
    
    CGPoint origin = activeRect.origin;
    origin.y -= self.scrollView.contentOffset.y;
    
    if (CGRectContainsPoint(visibleRect, origin) == NO) // if under keyboard we shift up.
    {
        CGPoint scrollPoint = CGPointMake(0.0,CGRectGetMaxY(activeRect)-(visibleRect.size.height));
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}
-(UIView *)activeFirstResponderView
{
    for (UIView *view in self.view.subviews)
    {
        if ([view isFirstResponder])
        {
            return view;
        }
    }
    return nil;
}
@end
