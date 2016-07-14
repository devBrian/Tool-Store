//
//  Payment+CoreDataProperties.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/13/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Payment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Payment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *tool_name;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
