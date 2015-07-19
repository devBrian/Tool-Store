//
//  Functions.m
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "Functions.h"
#import "User.h"
#import "Tool.h"

@implementation Functions
BOOL NSStringIsValidEmail(NSString* checkString, BOOL useStrictFilter)
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = useStrictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+ (void)preloadObjectModels:(NSManagedObjectContext *)context
{
    [Functions loadTools:[Functions toolsFromJSON] andContext:context];
    [Functions loadUsers:[Functions usersFromJSON] andContext:context];
}
+ (void)loadTools:(NSArray *)tools andContext:(NSManagedObjectContext *)context
{
    [tools enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Tool *tool = [NSEntityDescription insertNewObjectForEntityForName:@"Tool" inManagedObjectContext:context];
        tool.condition = [obj objectForKey:@"condition"];
        tool.image = [obj objectForKey:@"image"];
        tool.manufacturer = [obj objectForKey:@"manufacturer"];
        tool.name = [obj objectForKey:@"name"];
        tool.origin = [obj objectForKey:@"origin"];
        tool.overdue_fee = [NSNumber numberWithFloat:[[obj objectForKey:@"overdue_fee"] floatValue]];
        tool.rent_duration = [NSNumber numberWithInt:[[obj objectForKey:@"rent_duration"] intValue] ];
        tool.rent_price = [NSNumber numberWithFloat:[[obj objectForKey:@"rent_price"] floatValue]];
        tool.stock = [NSNumber numberWithInt:[[obj objectForKey:@"stock"] intValue]];
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }];
}
+ (void)loadUsers:(NSArray *)users andContext:(NSManagedObjectContext *)context
{
    [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.email = [obj objectForKey:@"email"];
        user.company = [obj objectForKey:@"company"];
        user.password = [obj objectForKey:@"password"];
        user.joined_date = [Functions getDateFromJSONString:[obj objectForKey:@"joined_date"]];
        NSError *error;
        if (![context save:&error])
        {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
    }];
}
+ (NSArray *)toolsFromJSON
{
    NSError *error = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Tools" ofType:@"json"];
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&error];
}
+ (NSArray *)usersFromJSON
{
    NSError *error = nil;
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"Users" ofType:@"json"];
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:kNilOptions error:&error];
}
+ (NSDate *)getDateFromJSONString:(NSString *)dateString
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}
@end
