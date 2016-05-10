//
//  ToolManager.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/26/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "ToolManager.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface ToolManager()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation ToolManager
+(ToolManager *)sharedInstance
{
    static ToolManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ToolManager alloc] init];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        sharedInstance.context = [appDelegate managedObjectContext];
    });
    return sharedInstance;
}
-(void)updateExistingTool:(Tool *)tool withQty:(int)qty
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tool"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", tool];
    request.predicate = predicate;
    
    NSError *error;
    Tool *temp = [[self.context executeFetchRequest:request error:&error] lastObject];
    temp.stock = [NSNumber numberWithInt:[tool.stock intValue] + qty];
    
    if (![self.context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
-(void)saveExistingTool:(Tool *)tool withQty:(int)qty
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Tool"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", tool];
    request.predicate = predicate;
    
    NSError *error;
    Tool *temp = [[self.context executeFetchRequest:request error:&error] lastObject];
    temp.stock = [NSNumber numberWithInt:[tool.stock intValue] - qty];
    
    if (![self.context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
-(BOOL)toolRentalExists:(Tool *)tool withQty:(int)qty
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Rental"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"tool == %@", tool];
    request.predicate = predicate;
    
    NSError *error;
    if ([[self.context executeFetchRequest:request error:&error] count] > 0)
    {
        Rental *rental = [[self.context executeFetchRequest:request error:&error] lastObject];
        if([[NSCalendar currentCalendar] isDate:rental.rent_date inSameDayAsDate:[NSDate date]] == YES)
        {
            rental.quantity = [NSNumber numberWithInt:[rental.quantity intValue] + qty];
            [self saveExistingTool:tool withQty:qty];
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}
@end
