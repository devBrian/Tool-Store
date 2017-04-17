//
//  PaymentManager.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import "PaymentManager.h"
#import "AppDelegate.h"
#import "UserManager.h"

@interface PaymentManager()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation PaymentManager
+(PaymentManager *)sharedInstance
{
    static PaymentManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PaymentManager alloc] init];
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        sharedInstance.context = [appDelegate managedObjectContext];
    });
    return sharedInstance;
}
-(void)createPayment:(NSString *)type amount:(float)amount andTool:(NSString *)tool
{
    Payment *payment = [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:self.context];
    payment.type = type;
    payment.amount = [NSNumber numberWithFloat:amount];
    payment.tool_name = tool;
    payment.user = [[UserManager sharedInstance] getCurrentUser];
    payment.createdAt = [NSDate date];
    
    [[UserManager sharedInstance] updateBalance:amount andType:type];
    
    NSError *error;
    if (![self.context save:&error])
    {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}
@end
