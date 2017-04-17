//
//  Payment+CoreDataProperties.h
//  
//
//  Created by Brian Sinnicke on 4/16/17.
//
//

#import "Payment.h"

NS_ASSUME_NONNULL_BEGIN

@interface Payment (CoreDataProperties)

+ (NSFetchRequest<Payment *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSNumber *amount;
@property (nullable, nonatomic, copy) NSDate *createdAt;
@property (nullable, nonatomic, copy) NSString *tool_name;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
