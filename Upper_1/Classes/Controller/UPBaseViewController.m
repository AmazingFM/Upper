//
//  UPBaseViewController.m
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "MainController.h"
#import "MessageCenterController.h"

static int kMsgCount = 0;

@interface UPBaseViewController ()
{
    UIBarButtonItem *messageItem;
}

@end

@implementation UPBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets=YES;
    }else {
        self.wantsFullScreenLayout=YES;
    }
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    messageItem = [self barBtnWithIcon:@"message"];
    messageItem.badgeValue = kMsgCount==0?@"":[NSString stringWithFormat:@"%d", kMsgCount];
    messageItem.badgeBGColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem=messageItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)addBadgeValue:(NSNotification *)notification
{
    NSArray *msgArr = notification.object;
    long addCount = msgArr.count;
    kMsgCount += addCount;

    messageItem.badgeValue = [NSString stringWithFormat:@"%d", kMsgCount];
}

- (void)setBadgeValue:(int)newValue
{
    messageItem.badgeValue = newValue==0?@"":[NSString stringWithFormat:@"%d", newValue];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    //
}

- (void)keyboardWillHide:(NSNotification *)note
{
    //
}

-(UIBarButtonItem*)barBtnWithIcon:(NSString*)iconName{
    UIBarButtonItem* barItem=nil;//createBarItem(iconName, self, @selector(showSideController));
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0,0,32,32);
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    barItem.badgeOriginX=25;
    barItem.badgeOriginY=5;
    return barItem;
}

- (void)checkNetStatus{
//    if ([XWBaseMethod connectionInternet]==NO) {
//        [XWBaseMethod showErrorWithStr:@"网络断开了" toView:self.view];
//    }
}

-(void)rightClick
{
    MessageCenterController *msgCenterController = [[MessageCenterController alloc] init];
    [self.navigationController pushViewController:msgCenterController animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
