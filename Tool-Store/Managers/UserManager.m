//
//  UserManager.m
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "UserManager.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface UserManager()
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation UserManager
#pragma mark - Public
+(UserManager *)sharedInstance
{
    static UserManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // Do any other initialization stuff here
        sharedInstance = [[UserManager alloc] init];
        // Allocates a currentUser for Core Data.
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        sharedInstance.context = [appDelegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:sharedInstance.context];
        if (sharedInstance.currentUser == nil)
        {
            sharedInstance.currentUser = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        }
    });
    return sharedInstance;
}
-(User *)getCurrentUser
{
    return self.currentUser;
}
-(BOOL)isLoggedIn  
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"email == '%@'",[[NSUserDefaults standardUserDefaults] stringForKey:LAST_EMAIL_KEY]]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if ([results count] == 1)
    {
        User *user = results.firstObject;
        self.currentUser = user;
    }
    return [results count] == 1 || self.currentUser.email;
}
-(void)insertUser:(User *)user completion:(void (^)(NSError *error))completion
{
    [self.context insertObject:user];
    NSError *error;
    if (![self.context save:&error])
    {
        if (completion)
        {
            completion(error);
        }
    }
    else
    {
        if (completion)
        {
            self.currentUser = user;
            completion(nil);
        }
    }
}
-(void)saveUser:(User *)user completion:(void (^)(NSError *error))completion
{
    NSError *error;
    if (![self.context save:&error])
    {
        if (completion)
        {
            completion(error);
        }
    }
    else
    {
        if (completion)
        {
            self.currentUser = user;
            completion(nil);
        }
    }
}
-(void)signOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LAST_EMAIL_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.currentUser = nil;
}
-(BOOL)userExistsWithEmail:(NSString *)email
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email == %@)",email];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    return (results && results.count > 0);
}
-(BOOL)userExistsWithEmail:(NSString *)email andPassword:(NSString *)password
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email == %@) AND (password == %@)",email,password];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    
    if (results && results.count > 0)
    {
        self.currentUser = [results firstObject];
    }
    return (results && results.count > 0);
}
@end
