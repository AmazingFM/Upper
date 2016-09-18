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
#import "ChatController.h"

#import "UPDataManager.h"

#define TopViewHeight 200


@implementation OtherUserData

- (NSDictionary *)attributeMapDictionary {
    return @{ @"ID" : @"id",};
}
@end

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
    
    NSLog(@"Index:%d--Query_id:%@", self.index, self.user.ID);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)letsChat:(UIButton *)sender
{
    ChatController *chatController = [[ChatController alloc] init];
    chatController.otherUserData = self.user;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.zkSegment zk_itemClickByIndex:self.index];
    
    [self userInfoRequest];
}

- (void)userInfoRequest
{
    NSString *user_id = [UPDataManager shared].userInfo.ID;
    NSString *query_id = self.user.ID;
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"UserQuery"forKey:@"a"];
    
    [params setObject:user_id forKey:@"user_id"];
    [params setObject:query_id forKey:@"qry_usr_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json){
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            //处理
            OtherUserData *user = [self.user initWithDict:dict[@"resp_data"]];
            
            PersonInfoController *personController = self.childViewControllers[0];
            [personController setUserData:user];
        }
        
    }failture:^(id error) {
        
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
    UIButton *headButton = [[UIButton alloc]init];
    headButton.frame = CGRectMake(headerX, 50, headerW, hederH);
    
    NSString *headImgStr = self.user.user_icon;
    if (headImgStr) {
        NSData *_decodedImgData = [[NSData alloc] initWithBase64EncodedString:headImgStr options:NSDataBase64DecodingIgnoreUnknownCharacters];
        [headButton setBackgroundImage:[UIImage imageWithData:_decodedImgData] forState:UIControlStateNormal];
    } else {
        [headButton setBackgroundImage:[UIImage imageNamed:@"head"] forState:UIControlStateNormal];
    }

    headButton.layer.masksToBounds = YES;
    [headButton.layer setCornerRadius:headerW/2]; //设置矩形四个圆角半径
    headButton.layer.borderColor   = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    headButton.self.layer.borderWidth   = 1;
    [headerView addSubview:headButton];
    
    
    
    //3.添加头像下面的文字
    UILabel *labelStr=[[UILabel alloc]init];
    labelStr.text=self.user.nick_name;
    labelStr.font=[UIFont systemFontOfSize:16];
    CGFloat labelY=CGRectGetMaxY(headButton.frame)+5;
    labelStr.textAlignment=NSTextAlignmentCenter;
    labelStr.textColor=[UIColor whiteColor];
    labelStr.frame=CGRectMake(0, labelY, self.view.width, 25);
    [headerView addSubview:labelStr];
    
    UIButton *chatBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, headerW, 30)];
    chatBtn.center = CGPointMake(headButton.center.x+100, headButton.center.y);
    [chatBtn setTitle:@"和他聊天" forState:UIControlStateNormal];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    chatBtn.backgroundColor = [UIColor whiteColor];
    chatBtn.alpha = 0.5;
    [chatBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    chatBtn.layer.cornerRadius = 5.0f;
    chatBtn.layer.masksToBounds = YES;
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
    vc2.userData = _user;

    UPHerParticipatedActivityController *vc3 = [[UPHerParticipatedActivityController alloc]init];
    vc3.userData = _user;
    
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
    
//    UIViewController *vc = self.childViewControllers[index];
//    if (vc.view.superview) {
//        return;
//    }
    
//    vc.view.frame = scrollView.bounds;
//    [self.bigScroll addSubview:vc.view];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击头像视图的事件
-(void)headerTap
{
    
}

@end
