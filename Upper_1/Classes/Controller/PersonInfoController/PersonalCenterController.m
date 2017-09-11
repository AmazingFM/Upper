//
//  PersonalCenterController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "PersonalCenterController.h"
#import "PersonInfoController.h"
#import "UPHerLaunchedActivityController.h"
#import "UPHerParticipatedActivityController.h"
#import "ZKSegment.h"
#import "Info.h"
#import "UPChatViewController.h"

#import "UserData.h"
#import "UPDataManager.h"
#import "YMNetwork.h"
#import "CRNavigationBar.h"

#define TopViewHeight 200

@interface PersonalCenterController () <UIScrollViewDelegate>

@property (nonatomic, retain) UIImageView *topView;
@property (nonatomic, retain) ZKSegment *zkSegment;
@property (nonatomic, assign) ZKSegmentStyle zkSegmentStyle;
@property (nonatomic, weak) UIScrollView *bigScroll;
@property (nonatomic, weak) UIView *headerView;
@end

@implementation PersonalCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TopViewHeight)];
    self.topView.image = [UIImage imageNamed:@"person_bg"];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"back" highIcon:@"" target:self action:@selector(leftClick)];
    
    [self.view addSubview:self.topView];
    
    [self addHeader];
    self.zkSegmentStyle = ZKSegmentLineStyle;
    [self resetSegment];
    
    [self setupScrollView];
}

- (void)letsChat:(UIButton *)sender
{
    UPChatViewController *chatController = [[UPChatViewController alloc] initWithUserID:self.user_id andUserName:self.nick_name andUserIcon:self.user_icon];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CRNavigationBar *navigationBar = (CRNavigationBar *)self.navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor clearColor];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self.zkSegment zk_itemClickByIndex:self.index];
    
    [self userInfoRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    CRNavigationBar *navigationBar = (CRNavigationBar *)self.navigationController.navigationBar;
    navigationBar.barTintColor = kUPThemeMainColor;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)userInfoRequest
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"UserQuery"forKey:@"a"];
    [params setObject:self.user_id forKey:@"qry_usr_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            //处理
            OtherUserData *user = [[OtherUserData alloc] initWithDict:dict[@"resp_data"]];
            
            [self showChatButton:user];
            PersonInfoController *personController = self.childViewControllers[0];
            [personController setUserData:user];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)addHeader
{
    //1.创建头像视图
    UIView *headerView=[[UIView alloc]init];
    headerView.x=0;
    headerView.width=self.view.width;
    headerView.height=TopViewHeight;
    headerView.y=0;
    [self.view addSubview:headerView];
    self.headerView=headerView;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTap)];
    [self.headerView addGestureRecognizer:tap];
    //2.添加头像到headerView

    CGFloat headerW=80;
    CGFloat hederH=headerW;
    CGFloat headerX=(headerView.width-headerW)*0.5;
    
    UIImageView *headIconView = [[UIImageView alloc] initWithFrame:CGRectMake(headerX, 50, headerW, hederH)];
    [headIconView sd_setImageWithURL:[NSURL URLWithString:self.user_icon] placeholderImage:[UIImage imageNamed:@"head"]];
    headIconView.contentMode = UIViewContentModeScaleToFill;
    headIconView.layer.masksToBounds = YES;
    headIconView.layer.cornerRadius = headerW/2;
    headIconView.layer.borderColor = kUPThemeLineColor.CGColor;
    headIconView.layer.borderWidth = 1.f;
    [headerView addSubview:headIconView];
    
    //3.添加头像下面的文字
    UILabel *labelStr=[[UILabel alloc]init];
    labelStr.text=self.nick_name;
    labelStr.font=[UIFont systemFontOfSize:16];
    CGFloat labelY=CGRectGetMaxY(headIconView.frame)+5;
    labelStr.textAlignment=NSTextAlignmentCenter;
    labelStr.textColor=[UIColor whiteColor];
    labelStr.frame=CGRectMake(0, labelY, self.view.width, 25);
    [headerView addSubview:labelStr];
    
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerW, 30)];
    chatBtn.center = CGPointMake(headIconView.center.x+100, headIconView.center.y);
    [chatBtn setTitle:@"和他聊天" forState:UIControlStateNormal];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    chatBtn.backgroundColor = [UIColor whiteColor];
    chatBtn.alpha = 0.5;
    [chatBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    chatBtn.layer.cornerRadius = 5.0f;
    chatBtn.layer.masksToBounds = YES;
    chatBtn.hidden = YES;
    chatBtn.tag = 100;
    [chatBtn addTarget:self action:@selector(letsChat:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:chatBtn];

}

- (void)setupScrollView
{
    UIScrollView *bigScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, TopViewHeight, ScreenWidth, (ScreenHeight-TopViewHeight))];
    bigScroll.showsHorizontalScrollIndicator = NO;
    bigScroll.delegate = self;
    [self.view addSubview:bigScroll];
    self.bigScroll = bigScroll;
    
    [self addController];
    
    CGFloat contentX = self.childViewControllers.count*[UIScreen mainScreen].bounds.size.width;
    self.bigScroll.contentSize = CGSizeMake(contentX, 0);
    self.bigScroll.pagingEnabled = YES;
    
    UIViewController *vc1 = self.childViewControllers[0];
    vc1.view.frame = CGRectMake(0, 0, self.bigScroll.width, self.bigScroll.height);
    
    UIViewController *vc2 = self.childViewControllers[1];
    vc2.view.frame = CGRectMake(ScreenWidth, 0, self.bigScroll.width, self.bigScroll.height);
    
    UIViewController *vc3 = self.childViewControllers[2];
    vc3.view.frame = CGRectMake(2*ScreenWidth, 0, self.bigScroll.width, self.bigScroll.height);
    
    [self.bigScroll addSubview:vc1.view];
    [self.bigScroll addSubview:vc2.view];
    [self.bigScroll addSubview:vc3.view];
}

- (void)addController
{
    //1
    PersonInfoController *vc1 = [[PersonInfoController alloc]init];
    
    //2
    UPHerLaunchedActivityController *vc2 = [[UPHerLaunchedActivityController alloc]init];
    vc2.user_id = self.user_id;
    vc2.clickBlock = ^(id item) {
        UPActivityCellItem *actCellItem = (UPActivityCellItem *)item;
        //跳转到详情页面
        UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
        actDetailController.actData = actCellItem.itemData;
        actDetailController.style = actCellItem.style;
        [self.navigationController pushViewController:actDetailController animated:YES];
    };

    UPHerParticipatedActivityController *vc3 = [[UPHerParticipatedActivityController alloc]init];
    vc3.user_id = self.user_id;
    vc3.clickBlock = ^(id item) {
        UPActivityCellItem *actCellItem = (UPActivityCellItem *)item;
        //跳转到详情页面
        UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
        actDetailController.actData = actCellItem.itemData;
        actDetailController.style = actCellItem.style;
        [self.navigationController pushViewController:actDetailController animated:YES];
    };
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    [self addChildViewController:vc3];
}

- (void)resetSegment
{
    if (self.zkSegment) {
        [self.zkSegment removeFromSuperview];
    }
    self.zkSegment = [ZKSegment zk_segmentWithFrame:CGRectMake(0, TopViewHeight-40, ScreenWidth, 40) style:self.zkSegmentStyle];

    __weak typeof(self) weakSelf = self;
    self.zkSegment.zk_itemClickBlock = ^(NSString *itemName, NSInteger itemIndex) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        CGFloat offsetX = itemIndex * strongSelf.bigScroll.frame.size.width;
        CGFloat offsetY = strongSelf.bigScroll.contentOffset.y;
        CGPoint offset = CGPointMake(offsetX, offsetY);
        [strongSelf.bigScroll setContentOffset:offset animated:YES];
    };

   [self.zkSegment zk_setItems:@[ @"基本资料", @"发起的活动", @"参与的活动"]];
    [self.view addSubview:self.zkSegment];
}
#pragma mark - ******************** scrollView代理方法
/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //获得索引
    NSUInteger index = scrollView.contentOffset.x/self.bigScroll.frame.size.width;
    
    [self.zkSegment zk_itemClickByIndex:index];
    self.index = index;
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击头像视图的事件
-(void)headerTap
{
    
}

- (void)showChatButton:(OtherUserData *)userData
{
    UIButton *chatButton = [self.headerView viewWithTag:100];
    if (chatButton!=nil) {
        chatButton.hidden = NO;
        int sexual = [userData.sexual intValue];
        NSString *title = (sexual==1)?@"和他聊天":@"和她聊天";
        [chatButton setTitle:title forState:UIControlStateNormal];
    }
}

@end
