//
//  InputViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/19/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextViewControllerDelegate <NSObject>
@optional
-(void)sendInputText:(NSString *)text;
-(void)updateContainerHeight:(CGFloat)height;
-(void)updateContainerPosition:(CGFloat)posX andPosY:(CGFloat)posY;
@end

@interface InputTextViewController : UIViewController
@property (weak, nonatomic) id <InputTextViewControllerDelegate> delegate;
@end
