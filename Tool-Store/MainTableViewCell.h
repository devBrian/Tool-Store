//
//  MainTableViewCell.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@interface MainTableViewCell : UITableViewCell
-(void)setCellData:(Tool *)data;
@end
