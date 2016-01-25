//
//  WebViewController.m
//  Tool-Store
//
//  Created by Brian Sinnicke on 1/2/16.
//  Copyright © 2016 Brian Sinnicke. All rights reserved.
//

#import "WebViewController.h"
#import "Functions.h"

@interface WebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadUrlWithUrlString:@"http://www.apple.com"];
    self.title = @"Policy";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark - UIWebviewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.activityIndicatorView startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityIndicatorView stopAnimating];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityIndicatorView stopAnimating];
    [Functions showErrorWithMessage:error.localizedDescription forViewController:self];
}
-(void)loadUrlWithUrlString:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
@end
