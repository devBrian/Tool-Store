//
//  User.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/13/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rental;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSDate * joined_date;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSSet *rental;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRentalObject:(Rental *)value;
- (void)removeRentalObject:(Rental *)value;
- (void)addRental:(NSSet *)values;
- (void)removeRental:(NSSet *)values;

@end
