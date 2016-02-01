//
//  MainTableViewCell.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rental.h"
#import "Tool.h"

@protocol MainTableViewCellDelegate <NSObject>
@optional
-(void)returnRental:(Rental *)rental;
@end

@interface MainTableViewCell : UITableViewCell
@property (weak,nonatomic) id <MainTableViewCellDelegate> delegate;
@property(nonatomic, readwrite) id activeData;
-(void)setCellData:(Rental *)data;
@end
