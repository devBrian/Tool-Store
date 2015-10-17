//
//  Comment+CoreDataProperties.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Comment.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Comment (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSString *comment_text;
@property (nullable, nonatomic, retain) NSDate *post_date;
@property (nullable, nonatomic, retain) Tool *tool;
@property (nullable, nonatomic, retain) User *user;

@end

NS_ASSUME_NONNULL_END
