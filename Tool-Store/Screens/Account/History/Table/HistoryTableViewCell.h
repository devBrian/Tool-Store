//
//  HistoryTableViewCell.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell
@property(nonatomic, readwrite) id activeData;
-(void)setCellData:(id)data;
@end
