//
//  SignupViewController.h
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SignupViewController : UIViewController
@property (nonatomic, assign) BOOL isChangingAccount;
@property (strong, nonatomic) User *loadedUserData;
@end
