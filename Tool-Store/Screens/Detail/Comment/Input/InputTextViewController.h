//
//  InputViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 10/19/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextViewControllerDelegate <NSObject>
@required
-(void)sendInputText:(NSString *)text;
-(void)textViewHeightUpdate:(CGFloat)height;
@end

@interface InputTextViewController : UIViewController
@property (weak, nonatomic) id <InputTextViewControllerDelegate> delegate;
@end
