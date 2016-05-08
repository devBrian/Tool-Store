//
//  DetailTableViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailTableViewControllerDelegate  <NSObject>
@required
-(void)rentAction:(id)sender;
@end

@interface DetailTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *tableData;
-(void)refreshTableData:(NSMutableArray *)data;
@property (weak, nonatomic) id <DetailTableViewControllerDelegate> delegate;
@end
