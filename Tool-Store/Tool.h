//
//  Tool.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/13/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Rental;

@interface Tool : NSManagedObject

@property (nonatomic, retain) NSNumber * stock;
@property (nonatomic, retain) NSNumber * rent_duration;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * rent_price;
@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * manufacturer;
@property (nonatomic, retain) NSString * origin;
@property (nonatomic, retain) NSNumber * overdue_fee;
@property (nonatomic, retain) Rental *rental;

@end
