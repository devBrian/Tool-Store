//
//  OptionViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 11/1/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "OptionViewController.h"

@interface OptionViewController ()

@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define GROW_DURATION 0.25f
-(void)animateBubble:(UIButton *)button block:(void (^)(void))completion
{
    [UIView animateWithDuration:GROW_DURATION delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options: UIViewAnimationOptionCurveEaseIn animations:^{
        button.transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:GROW_DURATION delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            button.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            if (completion)
            {
                completion();
            }
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
