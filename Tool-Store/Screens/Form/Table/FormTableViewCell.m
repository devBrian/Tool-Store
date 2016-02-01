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
@end
