//
//  QuantityViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 5/8/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@protocol QuantityViewControllerDelegate <NSObject>
@required
-(void)qtyDone:(int)qty;
@end

@interface QuantityViewController : UIViewController
@property (strong, nonatomic) Tool *loadedToolData;
@property (nonatomic, weak) id <QuantityViewControllerDelegate> delegate;
@end
