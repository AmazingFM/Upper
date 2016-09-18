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

#import "Info.h"

#import "XWHttpTool.h"
#import "AFHTTPRequestOperationManager.h"

#import "UPGlobals.h"

#import "UserQueryModal.h"
#import "AFURLRequestSerialization.h"
#import "NSString+Base64.h"
#import "UPDataManager.h"
#import "UPTools.h"
#import "UserData.h"
#import "MBProgressHUD+MJ.h"

@interface UpLoginController () <UITextFieldDelegate, UIGestureRecognizerDelegate>
{
//    UIImage *_2weimaImage;
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
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    self.navigationItem.rightBarButtonItem= nil;
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, 22)];
    [leftButton setTitle:@"登陆 Login" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.tag = 0;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];

    
    CGFloat y = leftButton.frame.origin.y+leftButton.frame.size.height+5;

    NSString *tipsText = @"用户注册须知";
    CGSize tipsSize = [tipsText sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,20.0f) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, tipsSize.width, tipsSize.height)];

    tipsLabel.text = tipsText;
    tipsLabel.font = [UIFont systemFontOfSize:12];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.backgroundColor = [UIColor blackColor];
    

    NSString *userStr = @"用户名\nUsername";

    CGSize size = [userStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
        if ([toBeString length] > 10) {
            //textField.text = [toBeString substringToIndex:5];
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
//            [self.parentController OnAction:self withType:CHANGE_VIEW toView:GET_PASSWORD_VIEW withArg:nil];
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

    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setValue:@"UserLogin" forKey:@"a"];
    [params setValue:userName forKey:@"user_name"];
    [params setValue:[UPTools md5HexDigest:password] forKey:@"user_pass"];
    [params setValue:@"0" forKey:@"pass_type"];

    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        //隐藏HUD
        [MBProgressHUD hideHUDForView:self.view];
        _loginB.enabled = YES;


        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            [UPDataManager shared].isLogin = YES;
            
            UserData *userData = [[UserData alloc] initWithDict:resp_data];
            
            [UPDataManager shared].userInfo = userData;
            
            //写入配置
            [[UPDataManager shared] writeToDefaults:[UPDataManager shared].userInfo];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierLogin object:nil userInfo:nil];//发送登录成功通知
            
            [g_appDelegate setRootViewControllerWithMain];
        
            [self resetValue];
        }
        else
        {
            [UPDataManager shared].isLogin = NO;
            
            NSDictionary *dict = (NSDictionary *)json;
            NSString *resp_desc = dict[@"resp_desc"];
            NSLog(@"%@", resp_desc);
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:resp_desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            

        }
        
    } failture:^(id error) {
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

@end
