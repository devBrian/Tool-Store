//
//  CommentViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/23/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@protocol CommentViewControllerDelegate <NSObject>
@optional
-(void)commentsUpdated;
@end

@interface CommentViewController : UIViewController
@property (strong, nonatomic) Tool *loadedToolData;
@property (weak, nonatomic) id <CommentViewControllerDelegate> delegate;
@end
