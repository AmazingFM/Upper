//
//  GetPasswordController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "GetPasswordController.h"
#import "MainController.h"
#import "YMImageButton.h"
#import "YMNetwork.h"

@interface GetPasswordController ()
{
    NSInteger type;
    
    UIScrollView *mainScrollView;
    
    UIView *stepOneView;
    UIView *stepTwoView;
    UIView *stepThreeView;
    
    UITextField *mailField;
    UITextField *codeField;
    UIButton *codeBtn;
    
    NSTimer *_timer;
    int interval;
    NSString *verifyCode;
}
@end

@implementation GetPasswordController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"找回密码";
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    mainScrollView.contentSize = CGSizeMake(3*ScreenWidth, 0);
    mainScrollView.pagingEnabled = YES;
    mainScrollView.scrollEnabled = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.backgroundColor = [UIColor whiteColor];
    
    [self configStepOneView];
    [self configStepTwoView];
    [self configStepThreeView];
    
    [mainScrollView addSubview:stepOneView];
    [mainScrollView addSubview:stepTwoView];
    [mainScrollView addSubview:stepThreeView];
    
    [self.view addSubview:mainScrollView];
}

- (void)configStepOneView
{
    if (stepOneView!=nil) {
        return;
    }
    stepOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    UIButton *mailBtn = [self createButton:CGRectMake(ScreenWidth/2-100, 40, 80, 120) imageName:@"icon_password_mail" title:@"邮箱找回"];
    [mailBtn setTitleEdgeInsets:UIEdgeInsetsMake(mailBtn.imageView.size.height+10, -mailBtn.imageView.size.width, 0, 0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [mailBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, mailBtn.titleLabel.bounds.size.height, mailBtn.titleLabel.bounds.size.width)];;//图片距离右边框距离减少图片的宽度，其它不边
    [mailBtn addTarget:self action:@selector(channelClick:) forControlEvents:UIControlEventTouchUpInside];
    mailBtn.tag = 100;
    
    UIButton *telephoneBtn = [self createButton:CGRectMake(ScreenWidth/2+20, 40, 80, 120) imageName:@"icon_password_mail" title:@"手机号找回"];
    [telephoneBtn setTitleEdgeInsets:UIEdgeInsetsMake(telephoneBtn.imageView.size.height+10, -telephoneBtn.imageView.size.width, 0, 0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [telephoneBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, telephoneBtn.titleLabel.bounds.size.height, telephoneBtn.titleLabel.bounds.size.width)];;//图片距离右边框距离减少图片的宽度，其它不边
    [telephoneBtn addTarget:self action:@selector(channelClick:) forControlEvents:UIControlEventTouchUpInside];
    telephoneBtn.tag = 101;
    [stepOneView addSubview:mailBtn];
    [stepOneView addSubview:telephoneBtn];
}

- (void)configStepTwoView
{
    float paddingY = 20;
    if (stepTwoView==nil) {
        stepTwoView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-FirstLabelHeight)];

        NSString *descStr = @"温馨提醒：请输入您注册时填写的行业邮箱地址，系统在验证该邮箱后会发送验证码到该邮箱。";
//        NSString *descStr = @"温馨提醒：请输入您注册时填写的手机号，系统在验证该手机号后会发送验证码到该手机。";
        CGSize size = [UPTools sizeOfString:descStr withWidth:ScreenWidth-20 font:[UIFont systemFontOfSize:15.f]];
        UILabel *descLabel = [self createLabel:CGRectMake(10, 20, ScreenWidth-20, size.height) title:descStr];
        descLabel.numberOfLines = 0;
        
        size = [UPTools sizeOfString:@"行业邮箱：" withWidth:ScreenWidth-20 font:[UIFont systemFontOfSize:15.f]];
        UILabel *mailLabel = [self createLabel:CGRectMake(20, CGRectGetMaxY(descLabel.frame)+paddingY, size.width, size.height) title:@"行业邮箱："];
        mailField = [self createField:CGRectMake(CGRectGetMaxX(mailLabel.frame)+5, mailLabel.origin.y, ScreenWidth-20-CGRectGetMaxX(mailLabel.frame), size.height)];
        UIView *mailLine = [[UIView alloc] initWithFrame:CGRectMake(mailField.origin.x, CGRectGetMaxY(mailField.frame), mailField.width, 0.6)];
        mailLine.backgroundColor = kUPThemeLineColor;
        
        UILabel *codeLabel = [self createLabel:CGRectMake(20, CGRectGetMaxY(mailLabel.frame)+paddingY, size.width, size.height) title:@"验证码："];
        codeField = [self createField:CGRectMake(CGRectGetMaxX(codeLabel.frame)+5, codeLabel.origin.y, ScreenWidth-20-CGRectGetMaxX(codeLabel.frame)-45, size.height)];
        UIView *codeLine = [[UIView alloc] initWithFrame:CGRectMake(codeField.origin.x, CGRectGetMaxY(codeField.frame), codeField.width, 0.6)];
        codeLine.backgroundColor = kUPThemeLineColor;
        codeBtn = [self createButton:CGRectMake(ScreenWidth-20-40, codeLabel.origin.y, 40, size.height) imageName:nil title:@"获取"];
        codeBtn.backgroundColor = kUPThemeMainColor;
        [codeBtn addTarget:self action:@selector(getVerify:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *nextStep = [self createButton:CGRectMake(ScreenWidth-20-40, codeLabel.origin.y, 40, size.height) imageName:nil title:@"下一步"];
        nextStep.backgroundColor = kUPThemeMainColor;
        [nextStep addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        
        [stepTwoView addSubview:descLabel];
        [stepTwoView addSubview:mailLabel];
        [stepTwoView addSubview:mailField];
        [stepTwoView addSubview:mailLine];
        
        [stepTwoView addSubview:codeLabel];
        [stepTwoView addSubview:codeField];
        [stepTwoView addSubview:codeLine];
        [stepTwoView addSubview:codeBtn];
        [stepTwoView addSubview:nextStep];
    }
 
}

- (void)configStepThreeView
{
    float paddingY = 20;
    if (stepTwoView==nil) {
        stepThreeView = [[UIView alloc] initWithFrame:CGRectMake(2*ScreenWidth, 0, ScreenWidth, ScreenHeight-FirstLabelHeight)];
        CGSize size = [UPTools sizeOfString:@"确认密码：" withWidth:ScreenWidth-20 font:[UIFont systemFontOfSize:15.f]];
        UILabel *newPassLabel = [self createLabel:CGRectMake(20, paddingY, size.width, size.height) title:@"新密码："];
        UITextField *newPassField = [self createField:CGRectMake(CGRectGetMaxX(newPassLabel.frame)+5, newPassLabel.origin.y, ScreenWidth-20-CGRectGetMaxX(newPassLabel.frame), size.height)];
        UIView *newPassLine = [[UIView alloc] initWithFrame:CGRectMake(newPassField.origin.x, CGRectGetMaxY(newPassField.frame), newPassField.width, 0.6)];
        newPassLine.backgroundColor = kUPThemeLineColor;
        
        UILabel *confirmPassLabel = [self createLabel:CGRectMake(20, CGRectGetMaxY(newPassLabel.frame)+paddingY, size.width, size.height) title:@"确认密码："];
        UITextField *confirmPassField = [self createField:CGRectMake(CGRectGetMaxX(confirmPassLabel.frame)+5, confirmPassLabel.origin.y, ScreenWidth-20-CGRectGetMaxX(confirmPassLabel.frame), size.height)];
        UIView *confirmPassLine = [[UIView alloc] initWithFrame:CGRectMake(confirmPassField.origin.x, CGRectGetMaxY(confirmPassField.frame), confirmPassField.width, 0.6)];
        confirmPassLine.backgroundColor = kUPThemeLineColor;
        
        [stepThreeView addSubview:newPassLabel];
        [stepThreeView addSubview:newPassField];
        [stepThreeView addSubview:newPassLine];
        
        [stepThreeView addSubview:confirmPassLabel];
        [stepThreeView addSubview:confirmPassField];
        [stepThreeView addSubview:confirmPassLine];
    }
}

- (UITextField *)createField:(CGRect)frame
{
    UITextField *field = [[UITextField alloc]initWithFrame:frame];
    [field setFont:[UIFont systemFontOfSize:18.0]];
    [field setTextColor:[UIColor blackColor]];
    field.delegate = self;
    [field setAutocorrectionType:UITextAutocorrectionTypeNo];
    [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    return field;
}

- (UILabel *)createLabel:(CGRect)frame title:(NSString *)title
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.f];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UIButton *)createButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return btn;
}

- (void)channelClick:(UIButton*)sender
{
    type = sender.tag-100;
    mainScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    
    [self reConfigStepTwoView];
}

- (void)reConfigStepTwoView
{
    
}

- (void)getVerify:(UIButton *)sender
{
    if (type==0) {
        NSString *mailStr = mailField.text;
        if (mailStr.length==0 || [mailStr componentsSeparatedByString:@"@"].count!=2) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入正确的邮箱号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        [self startVerifyCodeRequest];
    } else if (type==1) {
        NSString *telenumStr = mailField.text;
        NSCharacterSet *invertedCS = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        if (telenumStr.length!=11 || [telenumStr componentsSeparatedByCharactersInSet:invertedCS].count>1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        [self startVerifyCodeRequest];
    }
    

    [self startTimer];
}

- (void)nextStep:(UIButton *)sender
{
    NSString *code = codeField.text;
    if ([code isEqualToString:verifyCode]&&verifyCode.length!=0) {
        mainScrollView.contentOffset = CGPointMake(2*ScreenWidth, 0);
    } else {
        UIAlertView *alertViiew = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertViiew show];
    }
}

- (void)startVerifyCodeRequest
{
    NSString *mailStr = mailField.text;
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setValue:@"MailSend" forKey:@"a"];
    [params setValue:mailStr forKey:@"mobile"];
    [params setValue:@"" forKey:@"text"];
    [params setValue:@"1" forKey:@"send_type"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            //设置 smsText
            if (resp_data) {
                verifyCode = resp_data[@"verify_code"];
            }
        }
        else
        {
            verifyCode = @"";
            UIAlertView *alertViiew = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败，请重新获取一次" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertViiew show];
            [self stopTimer];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)startSMSRequest
{
    NSString *telenum = mailField.text;
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setValue:@"SmsSend" forKey:@"a"];
    [params setValue:telenum forKey:@"mobile"];
    [params setValue:@"" forKey:@"text"];
    [params setValue:@"1" forKey:@"send_type"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            //设置 smsText
            if (resp_data) {
                verifyCode = resp_data[@"verify_code"];
            }
        }
        else
        {
            verifyCode = @"";
            UIAlertView *alertViiew = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败，请重新获取一次" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertViiew show];
            [self stopTimer];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)refreshBtn
{
    interval--;
    if (interval==0) {
        [self stopTimer];
        return;
    }
    [codeBtn setTitle:[NSString stringWithFormat:@"%dS", interval] forState:UIControlStateNormal];
    
}

-(void)startTimer
{
    interval = 10;
    _timer= [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshBtn) userInfo:nil repeats:YES];
    [codeBtn setEnabled:NO];
}

-(void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    [codeBtn setTitle:@"验证" forState:UIControlStateNormal];
    codeBtn.enabled = YES;
}

@end

