//
//  RentalManager.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/26/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "RentalManager.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "ToolManager.h"
#import "PaymentManager.h"

@interface RentalManager()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation RentalManager
+(RentalManager *)sharedInstance
{
    static RentalManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RentalManager alloc] init];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        sharedInstance.context = [appDelegate managedObjectContext];
    });
    return sharedInstance;
}
-(NSString *)returnRental:(Rental *)rental 
{
    NSString *errorMessage;
    if ([Functions isDateOverDue:rental.due_date])
    {
        errorMessage = [NSString stringWithFormat:@"Rental was overdue. You will be charged a $%.2f fee.", [rental.tool.overdue_fee floatValue]];
    }
    [[ToolManager sharedInstance] updateExistingTool:rental.tool withQty:1];
    if ([rental.quantity intValue] == 1)
    {
        [self deleteRental:rental];
    }
    else
    {
        rental.quantity = [NSNumber numberWithInt:[rental.quantity intValue] - 1];
    }
    return errorMessage;
}
-(void)deleteRental:(Rental *)rental
{
    [self.context deleteObject:rental];
    NSError *error;
    if (![self.context save:&error])
    {
       NSLog(@"Whoops, couldn't deleted: %@", [error localizedDescription]);
    }
}
-(void)createRentalForTool:(Tool *)tool andUser:(User *)user andQty:(int)qty
{
    Rental *rental = [NSEntityDescription insertNewObjectForEntityForName:@"Rental" inManagedObjectContext:self.context];
    rental.tool = tool;
    rental.user = user;
    rental.rent_date = [NSDate date];
    rental.quantity = [NSNumber numberWithInt:qty];
    float total = [tool.rent_price floatValue] * qty;
    [[PaymentManager sharedInstance] createPayment:@"rent" amount:total andTool:tool.name];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *due_date = [calendar dateByAddingUnit:NSCalendarUnitDay value:[tool.rent_duration intValue] toDate:[NSDate date] options:0];
    rental.due_date = due_date;
    NSError *error;
    if (![self.context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
@end
