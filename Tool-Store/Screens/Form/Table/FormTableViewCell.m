//
//  FormTableViewCell.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "FormTableViewCell.h"

@interface FormTableViewCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *formTextfield;
@end

@implementation FormTableViewCell

-(void)setCellData:(id)data
{
    Form *formData = (Form *)data;
    self.activeData = formData;
    self.formTextfield.keyboardType = formData.keyboardType;
    self.formTextfield.placeholder = formData.formPlaceholder;
    self.formTextfield.text = formData.formText;
    self.formTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    self.formTextfield.delegate = self;
    self.formTextfield.secureTextEntry = formData.isSecure;
    self.formTextfield.tag = formData.form_id;
    self.formTextfield.returnKeyType = formData.returnKeyType;
    if (formData.form_id == 1)
    {
        [self.formTextfield becomeFirstResponder];
    }
}
-(void)formSubmitted:(Form *)formData
{
    if (self.delegate != nil)
    {
        if ([self.delegate respondsToSelector:@selector(formSubmitted:)])
        {
            [self.delegate formSubmitted:formData];
        }
    }
}
#pragma mark - UITextfield Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    Form *data = (Form *)self.activeData;
    data.formText = textField.text;
    [self formSubmitted:data];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    Form *data = (Form *)self.activeData;
    data.formText = textField.text;
    [self formSubmitted:data];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [self.superview viewWithTag:nextTag];
    UITextField *cell = (UITextField *) nextResponder;
    if (cell)
    {
        [cell becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
    }
    return NO;
}
@end
