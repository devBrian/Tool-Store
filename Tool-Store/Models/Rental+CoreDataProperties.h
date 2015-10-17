//
//  Rental+CoreDataProperties.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/16/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Rental.h"

NS_ASSUME_NONNULL_BEGIN

@interface Rental (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *due_date;
@property (nullable, nonatomic, retain) NSDate *rent_date;
@property (nullable, nonatomic, retain) NSNumber *quantity;
@property (nullable, nonatomic, retain) Tool *tool;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
