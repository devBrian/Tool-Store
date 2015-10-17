//
//  CommentTableViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@protocol CommentTableViewControllerDelegate <NSObject>
@required
-(void)deleteComment:(Comment *)comment;
@end

@interface CommentTableViewController : UITableViewController
-(void)refreshTableData:(NSMutableArray *)data;
@property (weak, nonatomic) id <CommentTableViewControllerDelegate> delegate;
@end
