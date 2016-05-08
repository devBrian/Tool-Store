//
//  InputViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/19/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "InputTextViewController.h"
#import "KeyboardManager.h"

#define MAX_HEIGHT 150.0f

@interface InputTextViewController () <UITextViewDelegate, KeyboardManagerDelegate>
@property (nonatomic) CGFloat inputHeight;
@end

@implementation InputTextViewController
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [KeyboardManager sharedInstance].delegate = self;
}
#pragma mark - Keyboard Delegates
-(void)keyboardShown:(CGFloat)height
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(updateContainerPosition:)])
        {
            [self.delegate updateContainerPosition:(height)];
        }
    }
}
-(void)keyboardDidHide
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(updateContainerPosition:)])
        {
            [self.delegate updateContainerPosition:0];
        }
    }
}
#pragma mark - IBActions
- (IBAction)sendAction:(id)sender
{
    if ([self textViewHasText])
    {
        if (self.delegate != nil)
        {
            if ([self.delegate respondsToSelector:@selector(sendInputText:)])
            {
                NSString *text = self.textView.text;
                self.textView.text = @"";
                [self.textView resignFirstResponder];
                [self.delegate sendInputText:text];
            }
        }
    }
}
#pragma mark - Private
-(BOOL)textViewHasText
{
    return (self.textView.text.length > 0);
}
#pragma mark - TextView Delegate
-(void)textViewDidChange:(UITextView *)textView // TODO: make this work and grow the text view as needed.
{
    CGFloat height = [self.textView sizeThatFits:CGSizeMake(textView.frame.size.width, CGFLOAT_MAX)].height + 8 + 8;
    if (height != self.inputHeight && self.inputHeight < MAX_HEIGHT)
    {
        if (self.delegate != nil)
        {
            if ([self.delegate respondsToSelector:@selector(updateContainerHeight:)])
            {
                [self.view setNeedsUpdateConstraints];
                [self.view updateConstraintsIfNeeded];
                NSLog(@"height: %f",height);
                self.inputHeight = height;
                [self.delegate updateContainerHeight:height];
            }
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) // Send message on return
    {
        if (textView.text.length > 1)
        {
            if (self.delegate != nil)
            {
                if ([self.delegate respondsToSelector:@selector(sendInputText:)])
                {
                    NSString *text = self.textView.text;
                    self.textView.text = @"";
                    [self.textView resignFirstResponder];
                    [self.delegate updateContainerHeight:50.0f];
                    [self.delegate sendInputText:text];
                }
            }
            return NO;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
}
@end
