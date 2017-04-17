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
- (BOOL)isLoggedIn;
- (void)signOut;
- (BOOL)userExistsWithEmail:(NSString *)email;
- (BOOL)userExistsWithEmail:(NSString *)email andPassword:(NSString *)password;
- (void)saveUser:(User *)user completion:(void (^)(NSError *error))completion;
- (void)insertUser:(User *)user completion:(void (^)(NSError *error))completion;
- (void)updateBalance:(float)amount andType:(NSString *)type;
@end
