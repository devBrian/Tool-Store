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
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) CGFloat inputHeight;
@property (nonatomic, assign) BOOL isBottomOpen;
@end

@implementation InputTextViewController
#pragma mark - Life
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = @"";
    [KeyboardManager sharedInstance].delegate = self;
}
#pragma mark - Keyboard Delegates
-(void)keyboardShown:(CGFloat)height
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(updateContainerPosition:andPosY:)])
        {
            [self.delegate updateContainerPosition:0 andPosY:(height + 50)];
        }
    }
}
-(void)keyboardDidHide
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(updateContainerPosition:andPosY:)])
        {
            [self.delegate updateContainerPosition:0 andPosY:0];
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
-(IBAction)otherAction:(id)sender
{
    if (self.delegate != nil)
    {
        if (self.isBottomOpen == YES)
        {
            if ([self.delegate respondsToSelector:@selector(closeBottom:)])
            {
                self.isBottomOpen = NO;
                [self.delegate closeBottom:100.0f];
            }
        }
        else
        {
            if ([self.delegate respondsToSelector:@selector(openBottom:)])
            {
                self.isBottomOpen = YES;
                [self.delegate openBottom:100.0f];
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
- (void)textViewDidChange:(UITextView *)textView
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
                self.inputHeight = height;
                [self.delegate updateContainerHeight:height];
            }
        }
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView.text = @"";
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self sendAction:nil];
}
@end
