//
//  UPAgreementViewController.m
//  Upper
//
//  Created by 张永明 on 2017/8/7.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPAgreementViewController.h"

@interface UPAgreementViewController ()
{
    UIWebView *webView;
}
@end

@implementation UPAgreementViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户协议";
    self.view.backgroundColor = [UIColor whiteColor];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    [self.view addSubview:webView];
}
- (void)viewWillAppear:(BOOL)animated
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *htmlPath = [bundle pathForResource:@"agreement" ofType:@"rtf"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]];
    [webView loadRequest:request];
}
@end
