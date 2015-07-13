//
//  KeyboardManager.h
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/18/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface KeyboardManager : NSObject
+ (KeyboardManager*)sharedInstance;
- (void)setScrollViewContainer:(UIScrollView *)scrollView;
- (void)hideKeyboard;
@end
