//
//  UpLoginController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "AppDelegate.h"

#import "UpLoginController.h"
#import "UpRegisterController.h"
#import "GetPasswordController.h"

#import "Info.h"

#import "YMNetwork.h"
#import "AFHTTPRequestOperationManager.h"

#import "UPGlobals.h"

#import "UserQueryModal.h"
#import "AFURLRequestSerialization.h"
#import "NSString+Base64.h"
#import "UPDataManager.h"
#import "UPTools.h"
#import "UserData.h"
#import "MBProgressHUD+MJ.h"
#import "CRNavigationBar.h"
#import "TTTAttributedLabel.h"
#import "UPTextAlertView.h"
#import "UIBarButtonItem+CH.h"
#import "UPCommentController.h"

@interface UpLoginController () <UITextFieldDelegate, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>
{
    NSString *userName;
    NSString *password;
    
    UITextField *_userNameT;
    UITextField *_passwordT;
    UIButton *_loginB;
}


@property (nonatomic, retain) UIAlertView *alert;

- (void)textField_DidEndOnExit:(id)sender;
- (void)handleSingleTap:(id)sender;
- (void)onBtnClick:(UIButton *)sender;

@end

@implementation UpLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"question"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(showFeedback:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, 22)];
    [leftButton setTitle:@"登陆 Login" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.tag = 0;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];

    
    CGFloat y = leftButton.frame.origin.y+leftButton.frame.size.height+5;

    NSString *tipsText = @"用户注册须知";
    CGSize tipsSize = [UPTools sizeOfString:tipsText withWidth:100.f font:[UIFont systemFontOfSize:12]];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, tipsSize.width, tipsSize.height)];

    tipsLabel.text = tipsText;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.backgroundColor = [UIColor blackColor];
    tipsLabel.hidden = YES;

    NSString *userStr = @"用户名\nUsername";
    CGSize size = [UPTools sizeOfString:userStr withWidth:100 font:[UIFont systemFontOfSize:12]];
    
    UILabel *user = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight*0.3, size.width, size.height)];
    user.textAlignment = NSTextAlignmentRight;
    user.numberOfLines = 0;
    user.text = userStr;
    user.backgroundColor = [UIColor clearColor];
    user.font = [UIFont systemFontOfSize:12];
    user.textColor = [UIColor whiteColor];

    _userNameT = [[UITextField alloc]initWithFrame:CGRectMake(25+size.width, user.origin.y, ScreenWidth-20-25-size.width, size.height)];
    [_userNameT setFont:[UIFont systemFontOfSize:18.0]];
    _userNameT.placeholder = @"请输入用户名";
    [_userNameT setTextColor:[UIColor whiteColor]];
    _userNameT.delegate = self;
    [_userNameT setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_userNameT setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    UIImageView * seperatorV = [[UIImageView alloc]initWithFrame:CGRectMake(20, user.frame.origin.y+size.height, ScreenWidth-20*2, 1)];
    seperatorV.backgroundColor = [UIColor grayColor];
    
    NSString *passStr= @"密码\nPassword";
    
    UILabel *passLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, ScreenHeight*2.5/5, size.width, size.height)];
    passLabel.textAlignment = NSTextAlignmentRight;
    passLabel.numberOfLines = 0;
    passLabel.text = passStr;
    passLabel.backgroundColor = [UIColor clearColor];
    passLabel.font = [UIFont systemFontOfSize:12];
    passLabel.textColor = [UIColor whiteColor];
    
    _passwordT = [[UITextField alloc]initWithFrame:CGRectMake(25+size.width, passLabel.origin.y, ScreenWidth-20-25-size.width, size.height)];
    [_passwordT setFont:[UIFont systemFontOfSize:18.0]];
    _passwordT.placeholder = @"请输入密码";
    [_userNameT setTextColor:[UIColor whiteColor]];
    _passwordT.secureTextEntry = YES;
    _passwordT.delegate = self;
    [_passwordT setAutocorrectionType:UITextAutocorrectionTypeNo];
    [_passwordT setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    
    UIImageView * seperatorV1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, passLabel.frame.origin.y+size.height, ScreenWidth-20*2, 1)];
    seperatorV1.backgroundColor = [UIColor grayColor];
    
    _loginB = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginB.frame = CGRectMake(20, ScreenHeight*3.5/5, ScreenWidth-40, 30);
    [_loginB.layer setMasksToBounds:YES];
    [_loginB.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [_loginB setTitle:@"登  陆" forState:UIControlStateNormal];
    _loginB.titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    _loginB.backgroundColor = [UIColor whiteColor];
    [_loginB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loginB.tag = 1;
    [_loginB addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *zhuce = [[UIButton alloc]initWithFrame:CGRectMake(90, ScreenHeight*3.5/5+35, ScreenWidth/2-90, 20)];
    [zhuce setSize:CGSizeMake(ScreenWidth/2-90, 20)];
    [zhuce setCenter:CGPointMake(ScreenWidth*1.25/4, ScreenHeight*3.5/5+50)];
    [zhuce setTitle:@"新用户注册" forState:UIControlStateNormal];
    zhuce.titleLabel.font = [UIFont systemFontOfSize:13.0];
    zhuce.backgroundColor = [UIColor clearColor];
    [zhuce setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    zhuce.tag = 2;
    [zhuce addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *wangjimima = [[UIButton alloc]init];
    [wangjimima setSize:CGSizeMake(ScreenWidth/2-90, 20)];
    [wangjimima setCenter:CGPointMake(ScreenWidth*2.75/4, ScreenHeight*3.5/5+50)];
    [wangjimima setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [wangjimima setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    wangjimima.backgroundColor = [UIColor clearColor];
    wangjimima.titleLabel.font = [UIFont systemFontOfSize:13.0];
    wangjimima.tag = 3;
    [wangjimima addTarget:self action:@selector(onBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    [self.view addSubview:leftButton];
    [self.view addSubview:tipsLabel];
    
    [self.view addSubview:user];
    [self.view addSubview:_userNameT];
    [self.view addSubview:seperatorV];
    
    [self.view addSubview:passLabel];
    [self.view addSubview:_passwordT];
    [self.view addSubview:seperatorV1];
    
    [self.view addSubview:_loginB];
    [self.view addSubview:zhuce];
    [self.view addSubview:wangjimima];
    
    TTTAttributedLabel *detailLabel = [self addTTAttributedLabel];
    [self.view addSubview:detailLabel];
}

- (void)showFeedback:(UIButton *)barItem
{
    //意见反馈
    UPCommentController *commentController = [[UPCommentController alloc]init];
    
    commentController.title = @"我的意见";
    commentController.type = UPCommentTypeFeedback;
    //    commentController.delegate = self;
    //2.设置导航栏barButton上面文字的颜色
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    [item setTintColor:[UIColor whiteColor]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    [self.navigationController pushViewController:commentController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    CRNavigationBar *navigationBar = (CRNavigationBar *)self.navigationController.navigationBar;
    navigationBar.barTintColor = [UIColor clearColor];
}

#pragma UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_userNameT == textField || _passwordT == textField)
    {
        if ([toBeString length] > 25) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameT) {
        [_passwordT becomeFirstResponder];
    } else if (textField == _passwordT) {
        [_passwordT resignFirstResponder];
        [_loginB sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{

        return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [_userNameT resignFirstResponder];
    [_passwordT resignFirstResponder];
}

- (void)onBtnClick:(UIButton *)sender
{
    int tag = (int)sender.tag;
    switch (tag) {
        case 1://登陆按钮
        {
            userName = _userNameT.text;
            password= _passwordT.text;
            
            if (userName.length==0 || password.length==0) {
                [[[UIAlertView alloc]initWithTitle:nil message:@"用户名和密码不能为空" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
            }
            else {
                sender.enabled = NO;
                [self startLoginRequest];
            }
            break;
        }
        case 2://注册
        {
            UpRegisterController *registerVC = [[UpRegisterController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
            break;
        }
        case 3://忘记密码
        {
            GetPasswordController *getPasswordController = [[GetPasswordController alloc] init];
            [self.navigationController pushViewController:getPasswordController animated:YES];
            break;
        }
        default:
            break;
    }
}

- (void)startLoginRequest
{
//    [self checkNetStatus];
    //添加一个遮罩，禁止用户操作
    [MBProgressHUD showMessage:@"正在登录...." toView:self.view];

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"UserLogin" forKey:@"a"];
    [params setValue:userName forKey:@"user_name"];
    [params setValue:[UPTools md5HexDigest:password] forKey:@"user_pass"];
    [params setValue:@"0" forKey:@"pass_type"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        //隐藏HUD
        [MBProgressHUD hideHUDForView:self.view];
        _loginB.enabled = YES;
        
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            [UPDataManager shared].isLogin = YES;
            
            UserData *userData = [[UserData alloc] initWithDict:resp_data];
            
            [UPDataManager shared].userInfo = userData;
            [UPDataManager shared].token = resp_data[@"token"];
            
            //写入配置
            [[UPDataManager shared] writeToDefaults];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierLogin object:nil userInfo:nil];//发送登录成功通知
            
            [g_appDelegate setRootViewControllerWithMain];
            
            [self resetValue];
        }
        else
        {
            [UPDataManager shared].isLogin = NO;
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSString *resp_desc = dict[@"resp_desc"];
            NSLog(@"%@", resp_desc);
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:resp_desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            
            
        }
        
    } failure:^(NSError *error) {
        //隐藏HUD
        [MBProgressHUD hideHUDForView:self.view];
        _loginB.enabled = YES;
        
        NSLog(@"%@",error);
    }];
}

- (void)resetValue
{
    _userNameT.text=@"";
    _passwordT.text=@"";
}

- (void)performDismiss:(NSTimer *)timer
{
    [self.alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (TTTAttributedLabel *)addTTAttributedLabel
{
    NSString *detailStr = @"登录即代表阅读及同意《用户协议》";
    CGSize size = [detailStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-2*LeftRightPadding,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    TTTAttributedLabel *detailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(LeftRightPadding, ScreenHeight-44, ScreenWidth-2*LeftRightPadding, size.height)];
    detailLabel.delegate = self;
    detailLabel.font = [UIFont systemFontOfSize:13.0];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailLabel.numberOfLines = 0;
    [detailLabel setText:detailStr];
    
    UIFont *boldSystemFont = [UIFont systemFontOfSize:13.0];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    //添加点击事件
    detailLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    detailLabel.delegate = self;
    detailLabel.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:RGBCOLOR(33, 129, 247)};
    detailLabel.activeLinkAttributes = nil;
    NSRange range1= [detailLabel.text rangeOfString:@"《用户协议》"];
    NSString* path = @"agreement";
    NSURL* url = [NSURL fileURLWithPath:path];
    [detailLabel addLinkToURL:url withRange:range1];
    
    return detailLabel;
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    NSString *title = @"用户协议";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@""];
    NSString *msgContent = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    UPTextAlertView *alertView = [[UPTextAlertView alloc] initWithTitle:title message:msgContent delegate:nil cancelButtonTitle:@"确定"];
    [alertView show];
}
@end
