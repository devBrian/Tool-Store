//
//  MainTableViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MainTableViewControllerDelegate <NSObject>
@required
-(void)selectedRentTool:(NSString *)tool;
@end


@interface MainTableViewController : UITableViewController
@property (weak, nonatomic) id <MainTableViewControllerDelegate> mainTableDelegate;
-(void)refreshTableWithData:(NSMutableArray *)data;
@end
