//
//  MainTableViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rental.h"

@protocol MainTableViewControllerDelegate <NSObject>
@required
-(void)returnRental:(Rental *)rental;
-(void)moreRental:(Rental *)rental;
@end


@interface MainTableViewController : UITableViewController
@property (weak, nonatomic) id <MainTableViewControllerDelegate> mainTableDelegate;
-(void)fetchDataWithCompletion:(void (^)(NSError *error))completion;
@end
