//
//  Rental.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/16/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "Rental.h"
#import "Tool.h"
#import "User.h"

@implementation Rental

// Insert code here to add functionality to your managed object subclass
- (NSString *)day
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
    return [dateFormatter stringFromDate:self.rent_date];
}

@end
