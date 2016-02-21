//
//  CustomButton.m
//  UserSystem
//
//  Created by Brian Sinnicke on 8/13/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "DesignableButton.h"

@implementation DesignableButton
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.layer.borderColor = self.borderColor.CGColor;
    self.layer.borderWidth = self.borderWidth;
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.masksToBounds = YES;
}
@end
