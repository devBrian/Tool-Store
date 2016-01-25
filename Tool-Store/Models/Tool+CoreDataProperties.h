//
//  Tool+CoreDataProperties.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/24/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tool.h"
#import "Comment.h"
#import "Rental.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tool (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) NSString *image_url;
@property (nullable, nonatomic, retain) NSString *manufacturer;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *origin;
@property (nullable, nonatomic, retain) NSNumber *overdue_fee;
@property (nullable, nonatomic, retain) NSNumber *rent_duration;
@property (nullable, nonatomic, retain) NSNumber *rent_price;
@property (nullable, nonatomic, retain) NSNumber *stock;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comments;
@property (nullable, nonatomic, retain) NSSet<Rental *> *rental;

@end

@interface Tool (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet<Comment *> *)values;
- (void)removeComments:(NSSet<Comment *> *)values;

- (void)addRentalObject:(Rental *)value;
- (void)removeRentalObject:(Rental *)value;
- (void)addRental:(NSSet<Rental *> *)values;
- (void)removeRental:(NSSet<Rental *> *)values;

@end

NS_ASSUME_NONNULL_END
