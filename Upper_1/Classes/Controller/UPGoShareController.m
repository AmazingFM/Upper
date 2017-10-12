//

//  UPGoShareController.m
//  Upper
//
//  Created by 张永明 on 16/11/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPGoShareController.h"
#import "WXApiManager.h"
#import "UPGlobals.h"
#import "CRNavigationBar.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UPAwardGuideController.h"
@interface UPGoShareController () <UIActionSheetDelegate>
{
    NSString *_title;
    NSMutableArray *_btnArr;
}
@end

@implementation UPGoShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册成功";
    
    _btnArr = [NSMutableArray new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *successImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-success"]];
    successImageV.frame = CGRectMake(ScreenWidth/2-20, FirstLabelHeight+30, 40, 40);
    successImageV.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:successImageV];
    
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(successImageV.frame)+20, ScreenWidth, 30)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont boldSystemFontOfSize:24];
    descLabel.textColor = [UIColor blackColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.text = @"恭喜您成功注册UPPER账户";
    [self.view addSubview:descLabel];
    
    UILabel *descLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(descLabel.frame)+5, ScreenWidth, 30)];
    descLabel1.backgroundColor = [UIColor clearColor];
    descLabel1.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18];
    descLabel1.textColor = [UIColor blackColor];
    descLabel1.textAlignment = NSTextAlignmentCenter;
    descLabel1.text = @"验证通过后，您会收到激活邮件/短信";
    [self.view addSubview:descLabel1];

    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(descLabel1.frame)+30, ScreenWidth, 30)];
    tipsLabel.backgroundColor = [UIColor clearColor];
    tipsLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:24];
    tipsLabel.textColor = [UIColor blackColor];
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    tipsLabel.text = @"哪个分享标题是你的风格";
    [self.view addSubview:tipsLabel];

    
    NSArray *titles = @[@"UPPER，只有3%的人有资格注册",
                        @"专业人士专属的社交工具",
                        @"专业人士专属，让你放心\"约\"",
                        @"每个APP都想用户多多益善，这一个却不接受太多",
                        @"一个很挑剔的社交应用，敢不敢试试"];
    
    float offsetx = 20;
    float offsety = CGRectGetMaxY(tipsLabel.frame)+30;
    for (int i=0; i<titles.count; i++) {
        CGRect btnFrame = CGRectMake(offsetx, offsety, ScreenWidth-2*offsetx, 36);
        UIButton *btn = [self createButton:btnFrame imageName:@"" title:titles[i]];
        btn.tag = 100+i;
        offsety += 50;
        [self.view addSubview:btn];
        
        [_btnArr addObject:btn];
    }

    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(showAwardGuide)];
}

- (void)showAwardGuide
{
    UPAwardGuideController *awardGuideController = [[UPAwardGuideController alloc] init];
    awardGuideController.registName = self.registName;
    [self.navigationController pushViewController:awardGuideController animated:YES];
}

- (void)goToLogin
{
    [[UPDataManager shared] cleanUserDafult];
    [g_appDelegate setRootViewController];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_interactivePopDisabled:YES];
    
    CRNavigationBar *navigationBar = (CRNavigationBar *)self.navigationController.navigationBar;
    navigationBar.barTintColor = kUPThemeMainColor;
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (UIButton *)createButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = frame;
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"icon_wx_session"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"icon_wx_session"] forState:UIControlStateHighlighted];
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    return shareBtn;
}


- (void)share:(UIButton *)sender
{
    _title = sender.titleLabel.text;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给朋友", @"分享到朋友圈", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [[WXApiManager sharedManager] sendLinkURL:kShareURL TagName:@"UPPER上行" Title:_title Description:@"一款专注高端人群的社交活动平台，仅面向选定的高技能行业开放。在这里，用户通过发起活动和参加活动的方式来拓展社交空间。" ThumbImageName:@"Icon-57" InScene:WXSceneSession];
    } else if (buttonIndex==1) {
        [[WXApiManager sharedManager] sendLinkURL:kShareURL TagName:@"UPPER上行" Title:_title Description:@"一款专注高端人群的社交活动平台，仅面向选定的高技能行业开放。在这里，用户通过发起活动和参加活动的方式来拓展社交空间。" ThumbImageName:@"Icon-57" InScene:WXSceneTimeline];
    } else {
        return;
    }
    [self goToLogin];
}

@end
