//
//  RentalManager.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/26/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rental.h"

@interface RentalManager : NSObject
+(RentalManager *)sharedInstance;
-(NSString *)returnRental:(Rental *)rental;
-(void)deleteRental:(Rental *)rental;
-(void)createRentalForTool:(Tool *)tool andUser:(User *)user;
@end
