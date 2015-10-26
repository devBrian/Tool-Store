//
//  InputViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/19/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "InputTextViewController.h"

#define MAX_HEIGHT 150.0f

@interface InputTextViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic) CGFloat inputHeight;
@end

@implementation InputTextViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = @"";
}
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
            if ([self.delegate respondsToSelector:@selector(textViewHeightUpdate:)])
            {
                [self.view setNeedsUpdateConstraints];
                [self.view updateConstraintsIfNeeded];
                NSLog(@"height: %f",height);
                self.inputHeight = height;
                [self.delegate textViewHeightUpdate:height];
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
