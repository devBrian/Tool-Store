//
//  WalletViewController.h
//  Tool-Store
//
//  Created by Brian Sinnicke on 4/16/17.
//  Copyright © 2017 Brian Sinnicke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalletViewControllerDelegate <NSObject>
@optional
-(void)finishedTransaction;
@end

@interface WalletViewController : UIViewController
@property (nonatomic, weak) id <WalletViewControllerDelegate> delegate;
@end
