//
//  ToolsTableViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/2/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@protocol ToolsTableViewControllerDelegate <NSObject>
@required
-(void)selectedTool:(Tool *)tool;
-(void)moreTool:(Tool *)tool;
@end

@interface ToolsTableViewController : UITableViewController
@property (weak, nonatomic) id <ToolsTableViewControllerDelegate> toolsDelegate;
-(void)searchForText:(NSString *)text completion:(void (^)(NSError *error))completion;
@end
