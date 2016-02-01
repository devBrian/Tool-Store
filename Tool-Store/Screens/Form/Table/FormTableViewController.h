//
//  FormTableViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/31/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Form.h"

@protocol FormTableViewControllerDelegate <NSObject>
@optional
-(void)formSubmitted:(Form *)formData;
@end

@interface FormTableViewController : UITableViewController
@property (nonatomic, weak) id <FormTableViewControllerDelegate> delegate;
-(void)refreshTableData:(NSMutableArray *)data;
@end
