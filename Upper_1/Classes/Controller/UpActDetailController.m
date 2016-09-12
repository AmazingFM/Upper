//
//  UpActDetailController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UpActDetailController.h"
#import "QRCodeController.h"
#import "UPCommentController.h"
#import "MainController.h"
#import "Info.h"
#import "UPTheme.h"
#import "UPDataManager.h"
#import "ZouMaDengView.h"
#import "MBProgressHUD+MJ.h"
#import "LaunchActivityController.h"
#import "EnrollPeopleController.h"
#import "UPActivityCell.h"
#import "UPTools.h"
#import "DrawSomething.h"

#define LabelHeight 17
#define AlertTagEdit    0
#define AlertTagCancel  1

@interface UpActDetailController () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    int loveCount;
    
    UIView *_actContentV;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    
    UIView *_bottomView;
    UIButton *_loveB;
    UIButton *_bubbleB;
    
    UIButton *_joinB;
    UIButton *_quitB;
    
    NSArray<UIButton *> *btnArr;
    
    NSArray *_cellIdArr;
}

@property (nonatomic, retain) UIScrollView *activitiesScro;

- (void)leftClick;

@end

@implementation UpActDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    loveCount = 3;
    
    self.title = @"活动详情";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_cover_gaussian"]];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight,ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=80000
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#endif
    [self.view addSubview:_tableView];
    
    //:@"策划人" ,@"活动时间", @"活动地点", @"人数上限", @"活动类型", @"报名状态",
    _cellIdArr = @[@"image", @"actTitle", @"actDesc", @"cellID", @"cellID", @"cellID", @"cellID", @"cellID", @"cellID", @"submit"];
    
//    CGFloat btnHeight =30;
//    UIButton *reviewBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,FirstLabelHeight, 50, btnHeight)];
//    UIButton *quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(100,FirstLabelHeight, 50, btnHeight)];
//    UIButton *commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(200,FirstLabelHeight, 50, btnHeight)];
//    UIButton *signBtn = [[UIButton alloc] initWithFrame:CGRectMake(300,FirstLabelHeight, 50, btnHeight)];
//    
//    reviewBtn.tag = DetailBtnTypeReview;
//    [reviewBtn setTitle:@"回顾" forState:UIControlStateNormal];
//    quitBtn.tag = DetailBtnTypeComment;
//    [quitBtn setTitle:@"评论" forState:UIControlStateNormal];
//    commentBtn.tag = DetailBtnTypeQuit;
//    [commentBtn setTitle:@"退出" forState:UIControlStateNormal];
//    signBtn.tag = DetailBtnTypeSign;
//    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
//    btnArr = @[reviewBtn, quitBtn, commentBtn, signBtn];
//    for (UIButton *btn in btnArr) {
//        btn.backgroundColor=[UIColor whiteColor];
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//        btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//        [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//    }
//    
//    CGFloat offsety = FirstLabelHeight+btnHeight;
//    self.activitiesScro = [[UIScrollView alloc] initWithFrame:CGRectMake(LeftRightPadding,offsety, ScreenWidth-LeftRightPadding*2, ScreenHeight-offsety)];
//    self.activitiesScro.showsHorizontalScrollIndicator = NO;
//    self.activitiesScro.showsVerticalScrollIndicator = NO;
//    self.activitiesScro.scrollEnabled = YES;
//    CGFloat scroWidth = self.activitiesScro.width;
//    
//    _headImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroWidth, scroWidth*3/4)];
//    _timeLocationV = [[UPTimeLocationView alloc] initWithFrame:CGRectZero];
//
//    _whenwhereV = [[UIView alloc]initWithFrame:CGRectMake(0, _headImageV.height-LabelHeight, 145, LabelHeight)];
//    _whenwhereV.backgroundColor = [UIColor redColor];
//    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, LabelHeight)];
//    _timeLabel.text = @"2015.06.20";
//    _timeLabel.textAlignment = NSTextAlignmentCenter;
//    _timeLabel.backgroundColor = [UIColor clearColor];
//    _timeLabel.textColor = [UIColor whiteColor];
//    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
//    _whereButton = [[UIButton alloc]initWithFrame:CGRectMake(_timeLabel.width, 0, 65, LabelHeight)];
//    [_whereButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
//    [_whereButton setTitle:@"London" forState:UIControlStateNormal];
//    _whereButton.backgroundColor=[UIColor clearColor];
//    _whereButton.titleLabel.textColor = [UIColor whiteColor];
//    _whereButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    
    // 设置间距
//    _whereButton.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
//
//    [_whenwhereV addSubview:_timeLabel];
//    [_whenwhereV addSubview:_whereButton];
    
//    CGFloat actTitleVHeight = LabelHeight*2;
//    _actContentV = [[UIView alloc]init];
//    [_actContentV setWidth:scroWidth];
//    _actContentV.y = CGRectGetMaxY(_headImageV.frame);
//    _actContentV.backgroundColor = [UIColor whiteColor];
//    
//    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, scroWidth*3/2, actTitleVHeight)];
//    _titleLabel.textAlignment = NSTextAlignmentLeft;
//    _titleLabel.text = @"大堡礁奢华游轮派对";
//    _titleLabel.font = [UIFont systemFontOfSize:16.0f];
//    _titleLabel.backgroundColor = [UIColor clearColor];
//    _titleLabel.textColor = [UIColor blackColor];
//    _loveB = [[UIButton alloc]initWithFrame:CGRectMake(scroWidth-actTitleVHeight*2, 0, actTitleVHeight, actTitleVHeight)];
//    _loveB.tag = DetailBtnTypeLove;
//    [_loveB setImage:[UIImage imageNamed:@"love"] forState:UIControlStateNormal];
//    NSString *s = [NSString stringWithFormat:@"%d", loveCount];
//    [_loveB setTitle:s forState:UIControlStateNormal];
//    _loveB.backgroundColor=[UIColor clearColor];
//    [_loveB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    _loveB.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    
//    _bubbleB = [[UIButton alloc]initWithFrame:CGRectMake(scroWidth-actTitleVHeight, 0, actTitleVHeight, actTitleVHeight)];
//    _bubbleB.tag = DetailBtnTypeComment;
//    [_bubbleB setImage:[UIImage imageNamed:@"bubble"] forState:UIControlStateNormal];
//    [_bubbleB setTitle:@"3" forState:UIControlStateNormal];
//    _bubbleB.backgroundColor=[UIColor clearColor];
//    [_bubbleB setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    _bubbleB.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//    // 设置按钮的内容左对齐
//    _loveB.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
//    _bubbleB.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
//    [_loveB addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bubbleB addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [_actContentV addSubview:_titleLabel];
//    [_actContentV addSubview:_loveB];
//    [_actContentV addSubview:_bubbleB];
//    
//    UIView *divider = [[UIView alloc]initWithFrame:CGRectMake(0, _titleLabel.height, scroWidth, 1)];
//    divider.backgroundColor = [UIColor grayColor];
//    [_actContentV addSubview:divider];
//    
//    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, divider.y+1, scroWidth-10, 100)];
//    _contentLabel.text = @"MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、MetBall时、";
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
//    _contentLabel.font = [UIFont systemFontOfSize:13];
//    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    _contentLabel.numberOfLines = 0;
//    _contentLabel.textColor = [UIColor grayColor];
//    _contentLabel.backgroundColor = [UIColor clearColor];
//    [_actContentV addSubview:_contentLabel];
//    
//    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _contentLabel.y+_contentLabel.height, scroWidth, 30*6)];
//    
//    //后续需要改动，写成一个方法
//    NSArray *keyArray = [NSArray arrayWithObjects:@"策划人" ,@"活动时间", @"活动地点", @"人数上限", @"活动类型", @"报名状态", nil];
//
//    NSArray *valueArray = [NSArray arrayWithObjects:@"Joseph Altuzarra", @"2015年05月27日18:00", @"伦敦大都会博物馆服装艺术学院", @"1500名", @"烧烤", @"未报名", nil];
//    for (int i=0; i<keyArray.count; i++) {
//        [self setupBtnWithIcon:@"sidebar_ad" title:keyArray[i] value:valueArray[i] index:i];
//    }
//    
//    //1。创建按钮
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(scroWidth/2, 30*3, scroWidth/2, 30)];
//    [btn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
//    [btn setTitle:@"查看已报名用户" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    btn.backgroundColor = [UIColor clearColor];
//    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
//    btn.contentEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 0);
//    btn.tag = DetailBtnTypeEnroll;
//    [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:btn];
//    
//    UIView *divider1 = [[UIView alloc]initWithFrame:CGRectMake(0, _bottomView.y+_bottomView.height, scroWidth, 1)];
//    divider1.backgroundColor = [UIColor grayColor];
//    [_actContentV addSubview:divider1];
//    
//    CGRect viewFrame = CGRectMake(LeftRightPadding, divider1.y+1, _actContentV.width-LeftRightPadding*2, 30);
//    [self initButtonsWithFrame:viewFrame];
//
//    [_actContentV addSubview:_bottomView];
//    [_actContentV addSubview:divider1];
//    _actContentV.height= _bottomView.height+_contentLabel.height+_titleLabel.height+1+30+1;
//    
//    [self.activitiesScro addSubview:_headImageV];
//    [self.activitiesScro addSubview:_timeLocationV];
//    [self.activitiesScro addSubview:_actContentV];
//    [self.activitiesScro setContentSize:CGSizeMake(0, _headImageV.height+_actContentV.height)];
//
////    [self.view addSubview:tipsLabel];
//    [self.view addSubview:self.activitiesScro];
}

//- (void)initButtonsWithFrame:(CGRect)viewFrame
//{
//    if (self.style==UPItemStyleActNone||self.style&UPItemStyleActLaunch) {
//        _joinB = createSubmitButton(15.0);
//        [_joinB setTitle:@"参加活动" forState:UIControlStateNormal];
//        [_joinB setTitleColor: [UIColor redColor]  forState:UIControlStateNormal];
//        _joinB.frame = viewFrame;
//        [_joinB addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        _joinB.tag = DetailBtnTypeJoin;
//        _joinB.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//        UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
//        arrow.center = CGPointMake(_joinB.width-100, _joinB.height/2);
//        [_joinB addSubview:arrow];
//        [_actContentV addSubview:_joinB];
//    } else if (self.style&UPItemStyleActJoin) {
//        _quitB = createSubmitButton(15.0);
//        [_quitB setTitle:@"退出活动" forState:UIControlStateNormal];
//        [_quitB setTitleColor: [UIColor redColor]  forState:UIControlStateNormal];
//        _quitB.frame = viewFrame;
//        [_quitB addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        _quitB.tag = DetailBtnTypeQuit;
//        _quitB.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//        UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
//        arrow.center = CGPointMake(_quitB.width-100, _quitB.height/2);
//        [_quitB addSubview:arrow];
//        [_actContentV addSubview:_quitB];
//    }
//    
//        
//}

- (void)onButtonClick:(UIButton *)sender
{

    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case DetailBtnTypeSubmit:
        {
            if (self.sourceType == SourceTypeWoCanyu) {
                //取消参加
                [self modifyActiviy:ActivityQuit];

            } else {
                [self joinActivity];
            }
        }
            break;
        case DetailBtnTypeEnroll:
        {
            //查看报名人数
            EnrollPeopleController *enrollController = [[EnrollPeopleController alloc]init];
            enrollController.activityId = self.actData.ID;
            [self.navigationController pushViewController:enrollController animated:YES];
        }
            break;
        case DetailBtnTypeReview:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"发布回顾" otherButtonTitles:@"编辑活动",@"取消活动", nil];
            alertView.tag = AlertTagEdit;
            [alertView show];
        }
            break;
        case DetailBtnTypeComment:
        {
            //弹窗评论窗口
            UPCommentController *commentController = [[UPCommentController alloc]init];
            commentController.actID = self.actData.ID;
            commentController.title=@"我要评论";
            commentController.type = 1;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
            [nav.navigationBar setTintColor:[UIColor whiteColor]];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
            nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
            //2.设置导航栏barButton上面文字的颜色
            UIBarButtonItem *item=[UIBarButtonItem appearance];
            [item setTintColor:[UIColor whiteColor]];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
            [nav.navigationBar setTranslucent:YES];
            [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:nav animated:YES completion:nil];
//            [self.navigationController pushViewController:commentController animated:YES];
        }
            break;
//        case DetailBtnTypeSign:
//        {
//            QRCodeController *qrSignController = [[QRCodeController alloc] init];
//            qrSignController.actId = self.actData.ID;
//            [self.navigationController pushViewController:qrSignController animated:YES];
//        }
        
    }
}
- (void)modifyActiviy:(RequestType)type
{
    
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:self.view];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityJoinModify"forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:self.actData.ID forKey:@"activity_id"];
    
    NSString *userStatus;
    if (type==ActivityQuit) {
        userStatus = @"2";
    } else if (type==ActivityComment) {
        userStatus = @"5";
    }
    [params setObject:userStatus forKey:@"user_status"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failture:^(id error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)cancelActivity
{
    
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:self.view];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityModify"forKey:@"a"];
    
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:self.actData.ID forKey:@"activity_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failture:^(id error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)joinActivity
{
    
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:self.view];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityJoin"forKey:@"a"];
    
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:self.actData.ID forKey:@"activity_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }

    } failture:^(id error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == AlertTagEdit) {
        if (buttonIndex==0) {
            //发布回顾
            UPCommentController *commentController = [[UPCommentController alloc]init];
            commentController.actID = self.actData.ID;
            commentController.title=@"我要回顾";
            commentController.type = 0;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
            [nav.navigationBar setTintColor:[UIColor whiteColor]];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
            nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
            //2.设置导航栏barButton上面文字的颜色
            UIBarButtonItem *item=[UIBarButtonItem appearance];
            [item setTintColor:[UIColor whiteColor]];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
            [nav.navigationBar setTranslucent:YES];
            [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:nav animated:YES completion:nil];

            
        } else if (buttonIndex==1) {
            //编辑
            LaunchActivityController *editActivityController = [[LaunchActivityController alloc] init];
            editActivityController.actData = self.actData;
            [self.navigationController pushViewController:editActivityController animated:YES];
        } else if (buttonIndex==2) {
            //取消
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认取消活动" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = AlertTagCancel;
            [alert show];
        }
        return;
    }
    if (alertView.tag == AlertTagCancel) {
        if (buttonIndex==1) {
            //取消活动
            [self cancelActivity];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellIdArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_cellIdArr[indexPath.row] isEqualToString:@"image"]) {
        return (ScreenWidth-kUPCellHorizontalPadding*2)*3/4+2*kUPCellVerticalPadding;
    }
    if ([_cellIdArr[indexPath.row] isEqualToString:@"actDesc"]) {
        NSString *actDesc = _actData.activity_desc;
        
        CGSize size = [UPTools sizeOfString:actDesc withWidth:(ScreenWidth-2*kUPCellHorizontalPadding) font:kUPThemeSmallFont];
        float height =size.height+2*kUPCellVerticalPadding;
        if (height<kUPCellDefaultHeight) {
            return kUPCellDefaultHeight;
        } else {
            return height;
        }
    }
    
    return kUPCellDefaultHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = _cellIdArr[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cellId isEqualToString:@"image"]) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kUPCellHorizontalPadding, kUPCellVerticalPadding, ScreenWidth-2*kUPCellHorizontalPadding, (ScreenWidth-kUPCellHorizontalPadding*2)*3/4-2*kUPCellVerticalPadding)];
            imgView.tag = 1001;
            [cell addSubview:imgView];
            
            NSString *time = [UPTools dateStringTransform:_actData.start_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy.MM.dd"];
            NSString *location = _actData.activity_place;
            NSString *mergeStr = [NSString stringWithFormat:@"%@AAA%@", time, location];
            
            CGSize size = SizeWithFont(mergeStr, kUPThemeSmallFont);
            
            UPTimeLocationView *_timeLocationV = [[UPTimeLocationView alloc] initWithFrame:CGRectMake(0, imgView.size.height-size.height, size.width, size.height)];
            [_timeLocationV setTime:time andLocation:location];
            [imgView addSubview:_timeLocationV];

        } else if ([cellId isEqualToString:@"actTitle"]) {
            UILabel *titleLabel  = [[UILabel alloc] initWithFrame:CGRectMake(kUPCellHorizontalPadding, 0, ScreenWidth-2*kUPCellHorizontalPadding, kUPCellDefaultHeight)];
            titleLabel.tag = 2001;
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = kUPThemeNormalFont;
            titleLabel.textColor = [UIColor blackColor];
            [cell addSubview:titleLabel];
        } else if ([cellId isEqualToString:@"actDesc"]) {
            UILabel *descLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
            descLabel.tag = 3001;
            descLabel.numberOfLines = 0;
            descLabel.backgroundColor = [UIColor clearColor];
            descLabel.font = kUPThemeSmallFont;
            descLabel.textColor = [UIColor blackColor];
            [cell addSubview:descLabel];
        } else if ([cellId isEqualToString:@"cellID"]) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.imageView setImage:[UPTools imageWithColor:[UIColor redColor] size:CGSizeMake(5, 20)]];
            
        } else if ([cellId isEqualToString:@"submit"]) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUPCellHorizontalPadding, kUPCellVerticalPadding, ScreenWidth-2*kUPCellHorizontalPadding, kUPCellDefaultHeight-2*kUPCellVerticalPadding)];
            btn.backgroundColor=[UIColor redColor];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = kUPThemeNormalFont;
            btn.tag = DetailBtnTypeSubmit;
            [btn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:btn];
        }
    }
    
    if ([cellId isEqualToString:@"image"]) {
        UIImageView *imgV = [cell viewWithTag:1001];
        [imgV sd_setImageWithURL:[NSURL URLWithString:_actData.activity_image] placeholderImage:[UIImage imageNamed:@"me"]];
    } else if ([cellId isEqualToString:@"actTitle"]) {
        UILabel *titleLabel = [cell viewWithTag:2001];
        titleLabel.text = _actData.activity_name;
    } else if ([cellId isEqualToString:@"actDesc"]) {
        UILabel *descLabel = [cell viewWithTag:3001];
        
        NSString *actDesc = _actData.activity_desc;
        CGSize size = SizeWithFont(actDesc, kUPThemeSmallFont);
        
        float height =size.height+2*kUPCellVerticalPadding;
        descLabel.frame = CGRectMake(kUPCellHorizontalPadding, kUPCellVerticalPadding, ScreenWidth-2*kUPCellHorizontalPadding, height);
        descLabel.text = actDesc;
        
    } else if ([cellId isEqualToString:@"cellID"]) {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = kUPThemeNormalFont;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryView = nil;

        if (indexPath.row==3) {
            cell.textLabel.text = @"策划人";
            cell.detailTextLabel.text = _actData.nick_name;
        } else if (indexPath.row==4) {
            cell.textLabel.text = @"活动时间";
            
            NSString *dateString = [UPTools dateStringTransform:_actData.start_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy-MM-dd"];
            cell.detailTextLabel.text = dateString;
            
        } else if (indexPath.row==5) {
            cell.textLabel.text = @"活动地点";
            cell.detailTextLabel.text = _actData.activity_place;
        } else if (indexPath.row==6) {
            cell.textLabel.text = @"人数上限";
            cell.detailTextLabel.text = _actData.limit_count;
            
            CGSize size = SizeWithFont(@"查看已报名用户", kUPThemeSmallFont);
            
            UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width+40, 30)];
            [searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
            [searchBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [searchBtn setTitle:@"查看已报名用户" forState:UIControlStateNormal];
            [searchBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            searchBtn.titleLabel.font = kUPThemeSmallFont;
            searchBtn.backgroundColor = [UIColor clearColor];
            searchBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
            searchBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 0);
            searchBtn.tag = DetailBtnTypeEnroll;
            [searchBtn addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = searchBtn;
        } else if (indexPath.row==7) {
            cell.textLabel.text = @"活动类型";
            
            NSArray *types = @[@"不限", @"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动",@"郊游、徒步"];
            int index = [_actData.activity_class intValue];
            cell.detailTextLabel.text = types[index];
            
        }else if (indexPath.row==8) {
            cell.textLabel.text = @"报名状态";
            NSArray *types = @[@"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动",@"郊游、徒步"];
            int index = [_actData.activity_status intValue];
            cell.detailTextLabel.text = types[index];
        }
    } else if ([cellId isEqualToString:@"submit"]) {
        UIButton *submit = [cell viewWithTag:(DetailBtnTypeSubmit)];
        
        if (self.sourceType==SourceTypeWoCanyu) {
            [submit setTitle:@"退出活动" forState:UIControlStateNormal];
        } else if (self.sourceType==SourceTypeWoFaqi|| self.sourceType==SourceTypeDaTing){
            [submit setTitle:@"参加活动" forState:UIControlStateNormal];
        }
    }

    return cell;
}

@end
