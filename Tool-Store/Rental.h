//
//  Rental.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/1/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Rental : NSManagedObject

@property (nonatomic, retain) NSDate * due_date;

@end
