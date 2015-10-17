//
//  CommentTableViewCell.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentTableViewCell : UITableViewCell
-(void)setCellData:(Comment *)comment;
@end
