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
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
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
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if ([results count] == 1)
    {
        User *user = results.firstObject;
        self.currentUser = user;
    }
    return [results count] == 1 || self.currentUser.email;
}
-(void)insertUser:(User *)user completion:(void (^)(NSError *error))completion
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context insertObject:user];
    NSError *error;
    if (![context save:&error])
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    if (![context save:&error])
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
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email == %@)",email];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    return (results && results.count > 0);
}
-(BOOL)userExistsWithEmail:(NSString *)email andPassword:(NSString *)password
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(email == %@) AND (password == %@)",email,password];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if (results && results.count > 0)
    {
        self.currentUser = [results firstObject];
    }
    return (results && results.count > 0);
}
@end
