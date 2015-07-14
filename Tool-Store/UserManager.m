//
//  UserManager.m
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "UserManager.h"
#import "AppDelegate.h"

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
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        sharedInstance.currentUser = [[User alloc] initWithEntity:entity insertIntoManagedObjectContext:nil];
        // Do any other initialization stuff here
    });
    return sharedInstance;
}
-(User *)getCurrentUser
{
    return self.currentUser;
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
