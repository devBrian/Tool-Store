//
//  User+CoreDataProperties.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"
#import "Comment.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *company;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSDate *joined_date;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSSet<Rental *> *rental;
@property (nullable, nonatomic, retain) NSSet<Comment *> *comments;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addRentalObject:(Rental *)value;
- (void)removeRentalObject:(Rental *)value;
- (void)addRental:(NSSet<Rental *> *)values;
- (void)removeRental:(NSSet<Rental *> *)values;

- (void)addCommentsObject:(Comment *)value;
- (void)removeCommentsObject:(Comment *)value;
- (void)addComments:(NSSet<Comment *> *)values;
- (void)removeComments:(NSSet<Comment *> *)values;

@end

NS_ASSUME_NONNULL_END
