//
//  KeyboardManager.h
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/18/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol KeyboardManagerDelegate <NSObject>
@optional
-(void)keyboardShown:(CGFloat)height;
-(void)keyboardDidHide;
@end

@interface KeyboardManager : NSObject
+ (KeyboardManager*)sharedInstance;
- (void)setScrollViewContainer:(UIScrollView *)scrollView;
- (void)hideKeyboard;
- (BOOL)isKeyboardVisible;
@property (weak, nonatomic) id <KeyboardManagerDelegate> delegate;
@end
