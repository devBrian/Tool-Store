//
//  Functions.h
//  SignInSignUpExample
//
//  Created by Brian Sinnicke on 6/17/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@import CoreData;
@import UIKit;

@interface Functions : NSObject
extern BOOL NSStringIsValidEmail(NSString *checkString, BOOL useStrictFilter);
+ (void)preloadUsers:(NSManagedObjectContext *)context;
+ (void)preloadTools:(NSManagedObjectContext *)context;
+ (void)deleteAllForEntity:(NSString *)entityName andContext:(NSManagedObjectContext *)context;
+ (NSInteger)differenceInDays:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)string;
+ (void)showErrorWithMessage:(NSString *)message forViewController:(UIViewController *)viewController;
+ (NSString *)countDownMessageForDays:(NSInteger)days;
+ (UIColor *)colorForDays:(NSInteger)days;
+ (BOOL)isDateOverDue:(NSDate *)date;
+ (NSString *)chatStringFromDate:(NSDate *)date;
+ (UIColor *)colorForCondition:(NSString *)condition;
+ (NSInteger)indexForSegmentedControlForCondition:(NSString *)condition;
+ (NSString *)timeStringFromDate:(NSDate *)date;
@end
