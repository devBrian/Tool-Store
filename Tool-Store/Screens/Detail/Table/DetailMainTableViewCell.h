//
//  DetailMainTableViewCell.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@protocol DetailMainTableViewCellDelegate <NSObject>
@required
-(void)rentAction:(id)sender;
@end

@interface DetailMainTableViewCell : UITableViewCell
-(void)setCellData:(id)data;
@property (weak, nonatomic) id <DetailMainTableViewCellDelegate> delegate;
@end
