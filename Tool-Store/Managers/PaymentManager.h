//
//  PaymentManager.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payment.h"

@interface PaymentManager : NSObject
+(PaymentManager *)sharedInstance;
-(void)createPayment:(NSString *)type amount:(float)amount andTool:(NSString *)tool;
@end
