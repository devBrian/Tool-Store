//
//  Tool+CoreDataProperties.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/16/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tool.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tool (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) id image;
@property (nullable, nonatomic, retain) NSString *manufacturer;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *origin;
@property (nullable, nonatomic, retain) NSNumber *overdue_fee;
@property (nullable, nonatomic, retain) NSNumber *rent_duration;
@property (nullable, nonatomic, retain) NSNumber *rent_price;
@property (nullable, nonatomic, retain) NSNumber *stock;
@property (nullable, nonatomic, retain) Rental *rental;

@end

NS_ASSUME_NONNULL_END
