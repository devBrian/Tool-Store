//
//  Rental.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/13/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tool, User;

@interface Rental : NSManagedObject

@property (nonatomic, retain) NSDate * due_date;
@property (nonatomic, retain) NSDate * rent_date;
@property (nonatomic, retain) Tool *tool;
@property (nonatomic, retain) User *user;
@end
