//
//  DetailViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/17/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tool.h"

@interface DetailViewController : UIViewController
@property (strong, nonatomic) Tool *loadedToolData;
@end
