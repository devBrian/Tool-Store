//
//  UserManager.m
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "UserManager.h"

@interface UserManager()
@property (strong, nonatomic) User *currentUser;
@end

@implementation UserManager
#pragma mark - Public
+(UserManager *)sharedInstance
{
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[UserManager alloc] init];
        // Do any other initialization stuff here
    });
    return sharedInstance;
}
- (User *)getCurrentUser
{
    // TODO: Change this to fetch the user?
    return self.currentUser;
}
-(void)signInUser:(User *)user
{
    self.currentUser = user;
}
-(void)signOutUser:(User *)user
{
    self.currentUser = nil;
}
//-(User *)getSavedUser:(User *)user
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@ AND password = %@ AND fb_id = %@ AND google_id = %@ AND isDeleted = %i",user.email,user.password,user.fb_id,user.google_id,0];
//    RLMResults *results = [User objectsWithPredicate:predicate];
//    User *savedUser = (User *)[results firstObject];
//    return savedUser;
//}
//-(BOOL)userExists:(User *)user
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@ AND password = %@ AND fb_id = %@ AND google_id = %@ AND isDeleted = %i",user.email,user.password,user.fb_id,user.google_id,0];
//    RLMResults *results = [User objectsWithPredicate:predicate];
//    return (results.count > 0);
//}
//-(BOOL)userExistsWithEmail:(NSString *)email andPassword:(NSString *)password
//{
//   NSPredicate *pred = [NSPredicate predicateWithFormat:@"email = %@ AND password = %@ AND isDeleted = %i",email,password,0];
//   RLMResults *results = [User objectsWithPredicate:pred];
//   return (results.count > 0);
//}
@end
