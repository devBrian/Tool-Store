//
//  OptionViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 11/1/15.
//  Copyright © 2015 Brian Sinnicke. All rights reserved.
//

#import "OptionViewController.h"

@interface OptionViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation OptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (int index=0; index < 20; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"Hello World" forState:UIControlStateNormal];
        [self.containerView addSubview:button];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
