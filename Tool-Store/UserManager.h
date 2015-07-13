//
//  UserManager.h
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//
#import "User.h"
@interface UserManager : NSObject
+ (UserManager*)sharedInstance;
- (User *)getCurrentUser;
- (void)signInUser:(User *)user;
- (void)signOutUser:(User *)user;
@end
