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

#pragma mark - Public
BOOL NSStringIsValidEmail(NSString* checkString, BOOL useStrictFilter)
{
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = useStrictFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
+ (void)preloadUsers:(NSManagedObjectContext *)context
{
    [Functions loadUsers:[Functions usersFromJSON] andContext:context];
}
+ (void)preloadTools:(NSManagedObjectContext *)context
{
    [Functions loadTools:[Functions toolsFromJSON] andContext:context];
}
+ (void)deleteAllForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *fetchAllObjects = [[NSFetchRequest alloc] init];
    [fetchAllObjects setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:context]];
    [fetchAllObjects setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchAllObjects error:&error];
    for (NSManagedObject *obj in results)
    {
        [context deleteObject:obj];
    }
    NSError *saveError = nil;
    [context save:&saveError];
}
+ (NSInteger)differenceInDays:(NSDate *)fromDate toDate:(NSDate *)toDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return difference.day;
}
+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *df = [NSDateFormatter new]; 
    [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
    return [df stringFromDate:date];
}
+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df dateFromString:string];
}
+ (BOOL)isDateOverDue:(NSDate *)date
{
    NSInteger days = [Functions differenceInDays:[NSDate date] toDate:date];
    return (days < 1);
}
+ (NSString *)countDownMessageForDays:(NSInteger)days
{
    NSString *message = [NSString new];
    if (days < 0)
    {
        message = @"Overdue";
    }
    else if (days < 1)
    {
        message = @"< 24 hours";
    }
    else if (days == 1)
    {
        message = @"1 day left";
    }
    else
    {
        message = [NSString stringWithFormat:@"%li days left",days];
    }
    return message;
}
+ (UIColor *)colorForDays:(NSInteger)days
{
    UIColor *color = [UIColor clearColor];
    
    if (days < 0)
    {
        color = [UIColor purpleColor];
    }
    else if (days < 1)
    {
        color = [UIColor redColor];
    }
    else if (days == 1)
    {
        color = [UIColor orangeColor];
    }
    else if (days < 30)
    {
        color = [UIColor orangeColor];
    }
    else
    {
        color = [UIColor blackColor];
    }
    return color;
}
+ (void)showErrorWithMessage:(NSString *)message forViewController:(UIViewController *)viewController
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Oops" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    [viewController presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - Private
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoaded"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)loadUsers:(NSArray *)users andContext:(NSManagedObjectContext *)context
{
    [users enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        user.email = [obj objectForKey:@"email"];
        user.company = [obj objectForKey:@"company"];
        user.password = [obj objectForKey:@"password"];
        user.joined_date = (NSDate *)[Functions getDateFromJSONString:[obj objectForKey:@"joined_date"]];
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
+ (NSDate *)getDateFromJSONString:(NSString *)string
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [df dateFromString:string];
}
@end
