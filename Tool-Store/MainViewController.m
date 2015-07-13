//
//  ViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 7/1/15.
//  Copyright (c) 2015 Brian Sinnicke. All rights reserved.
//

#import "MainViewController.h"
#import "UserManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", [[UserManager sharedInstance] getCurrentUser].email);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
