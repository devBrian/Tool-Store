//
//  Payment+CoreDataProperties.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/13/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Payment+CoreDataProperties.h"

@implementation Payment (CoreDataProperties)

@dynamic amount;
@dynamic createdAt;
@dynamic tool_name;
@dynamic user;

@end
