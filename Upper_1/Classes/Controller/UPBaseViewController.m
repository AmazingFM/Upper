//
//  UPBaseViewController.m
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "MainController.h"
#import "MessageCenterController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface UPBaseViewController ()
{
    
}

@end

@implementation UPBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;
    UIView *back = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.view addSubview:back];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    //
}

- (void)keyboardWillHide:(NSNotification *)note
{
    //
}

- (void)refresh{}
- (void)willShowSlideView{};

- (void)checkNetStatus{
}
@end

@implementation UPBaseTableViewController
@end

@interface UPBaseWebViewController()
{
    UIWebView *webView;
}

@end

@implementation UPBaseWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setFd_interactivePopDisabled:YES];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"去登陆" style:UIBarButtonItemStylePlain target:self action:@selector(goToLogin)];
    
    UIButton *refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"icon_refresh"] forState:UIControlStateNormal];
    refreshBtn.frame=CGRectMake(0, 0, 35, 35);
    [refreshBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshBtn];
}

- (void)refreshAction
{
    UIBarButtonItem *refreshItem=self.navigationItem.leftBarButtonItem;
    UIButton *refreshBtn=(UIButton *)[refreshItem customView];
    
    if(refreshBtn!=nil){
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        rotationAnimation.duration = 0.5;
        rotationAnimation.repeatCount = 1;
        rotationAnimation.cumulative = NO;
        rotationAnimation.removedOnCompletion = NO;
        rotationAnimation.fillMode = kCAFillModeForwards;
        [refreshBtn.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    }
    
    [webView reload];
}

- (void)goToLogin
{
    [[UPDataManager shared] cleanUserDafult];
    [g_appDelegate setRootViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadWithURLString:self.urlString];
}

- (void)loadWithURLString:(NSString *)urlString
{
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

@end
