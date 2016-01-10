//
//  Rental.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/16/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tool, User;

NS_ASSUME_NONNULL_BEGIN

@interface Rental : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (NSString *)day;
@end

NS_ASSUME_NONNULL_END

#import "Rental+CoreDataProperties.h"
