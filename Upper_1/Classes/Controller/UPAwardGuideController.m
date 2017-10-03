//
//  UPAwardGuideController.m
//  Upper
//
//  Created by 张永明 on 2017/10/2.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPAwardGuideController.h"
#import "WXApiManager.h"

#define kBoarderMargin 15

@interface UPAwardGuideController () <WXApiManagerDelegate>

@end

@implementation UPAwardGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"分享赢取精美礼品";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBoarderMargin, FirstLabelHeight+20, ScreenWidth-2*kBoarderMargin, 30)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont boldSystemFontOfSize:24];
    descLabel.textColor = [UIColor blackColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.adjustsFontSizeToFitWidth = YES;
    descLabel.text = @"不想炫耀，那也帮我们宣传一下";
    [self.view addSubview:descLabel];

    UILabel *descLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(descLabel.frame)+15, ScreenWidth, 30)];
    descLabel1.backgroundColor = [UIColor clearColor];
    descLabel1.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:18];
    descLabel1.textColor = [UIColor blackColor];
    descLabel1.textAlignment = NSTextAlignmentCenter;
    descLabel1.text = @"毕竟更大的用户群体将带给您更丰富的活动体验";
    descLabel1.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:descLabel1];
    
    UIImage *awardImage = [UIImage imageNamed:@"awardsList"];
    CGSize imageSize = awardImage.size;
    CGFloat imageWidth =  ScreenWidth-2*kBoarderMargin;
    CGFloat imageHeight = ceilf(imageWidth*imageSize.height/imageSize.width);
    UIImageView *awardImageView = [[UIImageView alloc] initWithImage:awardImage];
    awardImageView.frame = CGRectMake(kBoarderMargin, CGRectGetMaxY(descLabel1.frame)+5, imageWidth, imageHeight);
    awardImageView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:awardImageView];
    
    UIButton *shareBtn = [self createButton:CGRectMake(kBoarderMargin, CGRectGetMaxY(awardImageView.frame)+25, ScreenWidth-2*kBoarderMargin, 30) imageName:@"" title:@"分享到朋友圈"];
    [self.view addSubview:shareBtn];
    
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goToLogin)];
}

- (UIButton *)createButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = frame;
    shareBtn.backgroundColor = [UPTools colorWithHex:0xE44F4A];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareToWX) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return shareBtn;
}

- (void)shareToWX
{
    [WXApiManager sharedManager].delegate = self;
    [[WXApiManager sharedManager] sendLinkURL:kShareURL TagName:@"UPPER上行" Title:@"UPPER，高技能行业活动社交" Description:@"一款专注高端人群的社交活动平台，仅面向选定的高技能行业开放。在这里，用户通过发起活动和参加活动的方式来拓展社交空间。" ThumbImageName:@"Icon-57" InScene:WXSceneTimeline];
}

- (void)goToLogin
{
    [[UPDataManager shared] cleanUserDafult];
    [g_appDelegate setRootViewController];
}



- (void)managerDidRecvMessageResponse:(SendMessageToWXResp *)response {
//    NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
//    NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
//    UIAlertView *view = [[UIAlertView alloc] initWithTitle:strTitle
//                                                   message:strMsg
//                                                  delegate:nil
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"确认", nil];
//    [view show];
    if (response.errCode==0) {
        //打开跳转页面
        UPBaseWebViewController *webController = [[UPBaseWebViewController alloc] init];
        webController.title = @"抽奖";
        webController.urlString = @"http://www.uppercn.com";
//        [webController loadWithURLString:@"https://www.baidu.com"];
        [self.navigationController pushViewController:webController animated:YES];
    }
}


@end
