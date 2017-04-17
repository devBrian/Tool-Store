//
//  Payment+CoreDataProperties.m
//  
//
//  Created by Brian Sinnicke on 4/16/17.
//
//

#import "Payment+CoreDataProperties.h"

@implementation Payment (CoreDataProperties)

+ (NSFetchRequest<Payment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Payment"];
}

@dynamic amount;
@dynamic createdAt;
@dynamic tool_name;
@dynamic type;
@dynamic user;

@end
