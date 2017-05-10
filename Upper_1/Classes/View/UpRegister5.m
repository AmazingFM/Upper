//
//  UpRegister5.m
//  Upper_1
//
//  Created by aries365.com on 16/1/15.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UpRegister5.h"
#import "Info.h"
#import "DrawSomething.h"
#import "YMNetwork.h"

#define VERTICAL_SPACE 40
#define VerifyBtnWidth 100
#define TimeInterval 10

@interface UpRegister5() <UITextFieldDelegate>
{
    UIButton *verifyBtn;
    NSTimer *_timer;
    int interval;
    
    UILabel *comPhoneLabel;
    UITextField *comPhoneField ;
    UILabel *empIDLabel;
    UITextField *empIDField;
    UILabel *nameLabel;
    UITextField *nameField ;
    
    
    
    UILabel *telLabel;
    UITextField *teleField ;
    UILabel *verifyLabel;
    UITextField *verifyField;
    UILabel *desLabel;
    
    NSString *empID;
    NSString *telenumStr;
    NSString *comPhone;
    
    CGRect viewframe;
}

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, retain) UIImageView *seperatorV;
@property (nonatomic, retain) UIView *seperatorV1;
@property (nonatomic, retain) UIView *seperatorV2;
@property (nonatomic, retain) UIView *seperatorV3;
@property (nonatomic, retain) UIView *seperatorV4;
@property (nonatomic, retain) UIView *seperatorV5;

@end

@implementation UpRegister5

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    viewframe = frame;
    
    float offsetY = 0;
    
    
    telenumStr = @"手机号\nCellphone";
    NSString *verifyCodeStr = @"验证码\nVerifyCode";
    NSString *emailStr = @"行业邮箱\nEmail";
    
    
    comPhone = @"单位电话\nCom Tele";
    empID = @"员工号\nEmp NO.";
    NSString *empName = @"姓名\nName";
    
    CGSize size1 = SizeWithFont(comPhone, [UIFont systemFontOfSize:12]);
    CGSize size2 = SizeWithFont(telenumStr, [UIFont systemFontOfSize:12]);
    CGSize size = (size1.width>size2.width)?size1:size2;
    
    comPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY, size.width, size.height)];
    comPhoneLabel.textAlignment = NSTextAlignmentRight;
    comPhoneLabel.numberOfLines = 0;
    comPhoneLabel.text = comPhone;
    comPhoneLabel.backgroundColor = [UIColor clearColor];
    comPhoneLabel.textColor = [UIColor whiteColor];
    comPhoneLabel.font = [UIFont systemFontOfSize:12];
    
    comPhoneField = [[UITextField alloc]initWithFrame:CGRectMake(LeftRightPadding+size.width, offsetY, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    [comPhoneField setFont:[UIFont systemFontOfSize:15.0]];
    comPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    comPhoneField.delegate = self;
    
    _seperatorV3 = [[UIView alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY+size.height+1, frame.size.width-2*LeftRightPadding, 1)];
    _seperatorV3.backgroundColor = [UIColor grayColor];
    
    offsetY += size.height+25;
    
    empIDLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY, size.width, size.height)];
    empIDLabel.textAlignment = NSTextAlignmentRight;
    empIDLabel.numberOfLines = 0;
    empIDLabel.text = empID;
    empIDLabel.backgroundColor = [UIColor clearColor];
    empIDLabel.textColor = [UIColor whiteColor];
    empIDLabel.font = [UIFont systemFontOfSize:12];
    
    empIDField = [[UITextField alloc]initWithFrame:CGRectMake(LeftRightPadding+size.width, offsetY, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    [empIDField setFont:[UIFont systemFontOfSize:15.0]];
    empIDField.clearButtonMode = UITextFieldViewModeWhileEditing;
    empIDField.delegate = self;
    
    _seperatorV4 = [[UIView alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY+size.height+1, frame.size.width-2*LeftRightPadding, 1)];
    _seperatorV4.backgroundColor = [UIColor grayColor];

    offsetY += size.height+25;
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY, size.width, size.height)];
    nameLabel.textAlignment = NSTextAlignmentRight;
    nameLabel.numberOfLines = 0;
    nameLabel.text = empName;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:12];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(LeftRightPadding+size.width, offsetY, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    [nameField setFont:[UIFont systemFontOfSize:15.0]];
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameField.delegate = self;
    
    _seperatorV5 = [[UIView alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY+size.height+1, frame.size.width-2*LeftRightPadding, 1)];
    _seperatorV5.backgroundColor = [UIColor grayColor];
    
    offsetY += size.height+25;

    telLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY, size.width, size.height)];
    telLabel.textAlignment = NSTextAlignmentRight;
    telLabel.numberOfLines = 0;
    telLabel.text = telenumStr;
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.textColor = [UIColor whiteColor];
    telLabel.font = [UIFont systemFontOfSize:12];
    
    teleField = [[UITextField alloc]initWithFrame:CGRectMake(LeftRightPadding+size.width, offsetY, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    [teleField setFont:[UIFont systemFontOfSize:15.0]];
    teleField.clearButtonMode = UITextFieldViewModeWhileEditing;
    teleField.delegate = self;
    
    _seperatorV1 = [[UIView alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY+size.height+1, frame.size.width-2*LeftRightPadding, 1)];
    _seperatorV1.backgroundColor = [UIColor grayColor];
    
    offsetY += size.height+25;
    
    verifyLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY, size.width, size.height)];
    verifyLabel.textAlignment = NSTextAlignmentRight;
    verifyLabel.numberOfLines = 0;
    verifyLabel.text = verifyCodeStr;
    verifyLabel.backgroundColor = [UIColor clearColor];
    verifyLabel.textColor = [UIColor whiteColor];
    verifyLabel.font = [UIFont systemFontOfSize:12];
    
    verifyField = [[UITextField alloc]initWithFrame:CGRectMake(LeftRightPadding+size.width, offsetY, self.frame.size.width-2*LeftRightPadding-size.width, size.height)];
    [verifyField setFont:[UIFont systemFontOfSize:15.0]];
    verifyField.clearButtonMode = UITextFieldViewModeWhileEditing;
    verifyField.delegate = self;
    
    verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    verifyBtn.frame = CGRectMake(frame.size.width-LeftRightPadding-VerifyBtnWidth, offsetY, VerifyBtnWidth, size.height);
    verifyBtn.layer.cornerRadius = 5.0f;
    verifyBtn.layer.borderWidth = 1;
    [verifyBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    verifyBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [verifyBtn setBackgroundColor:[UIColor lightGrayColor]];
    [verifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [verifyBtn addTarget:self action:@selector(sendSMS:) forControlEvents:UIControlEventTouchUpInside];
    verifyField.frame = CGRectMake(20+verifyLabel.size.width, offsetY, verifyBtn.origin.x-20-verifyLabel.size.width, size.height);
    _seperatorV2 = [[UIView alloc]initWithFrame:CGRectMake(LeftRightPadding, offsetY+size.height+1, frame.size.width-2*LeftRightPadding, 1)];
    _seperatorV2.backgroundColor = [UIColor grayColor];
    
    _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, 0, size.width, size.height)];
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.numberOfLines = 0;
    _tipLabel.text = emailStr;
    _tipLabel.backgroundColor = [UIColor clearColor];
    _tipLabel.textColor = [UIColor whiteColor];
    _tipLabel.font = [UIFont systemFontOfSize:12];
    
    _suffixLabel = [[UILabel alloc]init];
    _suffixLabel.backgroundColor = [UIColor clearColor];
    _suffixLabel.textColor = [UIColor whiteColor];
    
    _emailField = [[UITextField alloc]init];
    [_emailField setFont:[UIFont systemFontOfSize:15.0]];
    _emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _emailField.delegate = self;
        
    _seperatorV = [[UIImageView alloc]init];
    _seperatorV.backgroundColor = [UIColor grayColor];
    
    desLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    desLabel.numberOfLines = 0;
    desLabel.text = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的公司邮箱，我们会向您提供的邮箱内发送一份验证邮件，点击邮件中的激活链接即可激活您的账号。";
    desLabel.textAlignment = NSTextAlignmentLeft;
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.textColor = [UIColor whiteColor];
    desLabel.font = [UIFont systemFontOfSize:12];
    [desLabel sizeToFit];
    
    [self addSubview:comPhoneLabel];
    [self addSubview:comPhoneField];
    [self addSubview:empIDLabel];
    [self addSubview:empIDField];
    [self addSubview:nameLabel];
    [self addSubview:nameField];

    
    [self addSubview:telLabel];
    [self addSubview:teleField];
    [self addSubview:verifyLabel];
    [self addSubview:verifyField];
    [self addSubview:verifyBtn];
    [self addSubview:_seperatorV1];
    [self addSubview:_seperatorV2];
    [self addSubview:_seperatorV3];
    [self addSubview:_seperatorV4];
    [self addSubview:_seperatorV5];
    
    [self addSubview:_tipLabel];
    [self addSubview:_seperatorV];
    [self addSubview:_suffixLabel];
    [self addSubview:_emailField];
    [self addSubview:desLabel];
    
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([toBeString length] > 15) {
        //textField.text = [toBeString substringToIndex:5];
        return NO;
    }
    return YES;
}

- (NSString *)identifyID
{
    if (!_noEmail) {
        return [NSString stringWithFormat:@"%@%@", self.emailPrefix, _emailSuffix];
    } else {
        if ([_industryID isEqualToString:@"1"]) {
            return [NSString stringWithFormat:@"%@", self.empID];
        } else {
            return [NSString stringWithFormat:@"%@|%@", self.comPhone, self.empID];
        }
    }
}

- (NSString *)identifyType
{
    if (!_noEmail) {
        return @"0";
    } else {
        if ([_industryID isEqualToString:@"1"]) {//医生
            return @"1";
        } else {
            return @"2";
        }
    }
}

-(NSString *)emailPrefix
{
    _emailPrefix= _emailField.text;
    return _emailPrefix;
}


-(NSString *)telenum
{
    _telenum = teleField.text;
    return _telenum;
}

- (NSString *)comPhone
{
    _comPhone = comPhoneField.text;
    return _comPhone;
}

- (NSString *)empID
{
    _empID = empIDField.text;
    return _empID;
}

- (NSString *)empName
{
    _empName = nameField.text;
    return _empName;
}

    
-(NSString *)verifyCode
{
    _verifyCode = verifyField.text;
    if (_verifyCode==nil) {
        return @"";
    }
    return _verifyCode;
}

- (void)resize
{
    if (_noEmail) {
        comPhoneLabel.hidden = NO;
        comPhoneField.hidden = NO;
        empIDLabel.hidden = NO;
        empIDField.hidden = NO;
        nameLabel.hidden = NO;
        nameField.hidden = NO;
        
        telLabel.hidden = NO;
        teleField.hidden = NO;
        verifyLabel.hidden = NO;
        verifyField.hidden = NO;
        verifyBtn.hidden = NO;
        _seperatorV2.hidden = NO;
        _seperatorV1.hidden = NO;
        _seperatorV3.hidden = NO;
        _seperatorV5.hidden = NO;
        _seperatorV4.hidden = NO;
        
        if ([self.industryID isEqualToString:@"1"]) {//医生
            empID = @"好医生ID\nDoctor ID";
            
            
            CGSize size = SizeWithFont(telenumStr, [UIFont systemFontOfSize:12]);
            
            //隐藏单位电话
            comPhoneLabel.frame = CGRectZero;
            comPhoneField.frame = CGRectZero;
            _seperatorV3.frame = CGRectZero;
            
            float offsetY = 0;
            
            float margin = 10;
            empIDLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            empIDLabel.text = empID;
            empIDField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV4.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            nameLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            nameField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV5.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            telLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            teleField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV1.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            verifyLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            verifyBtn.frame = CGRectMake(viewframe.size.width-LeftRightPadding-VerifyBtnWidth, offsetY, VerifyBtnWidth, size.height);
            verifyField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, verifyBtn.origin.x-LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV2.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
        } else {
            empID = @"员工号\nEmp NO.";
            float offsetY = 0;
            float margin = 10;
            
            CGSize size1 = SizeWithFont(comPhone, [UIFont systemFontOfSize:12]);
            CGSize size2 = SizeWithFont(telenumStr, [UIFont systemFontOfSize:12]);
            CGSize size = (size1.width>size2.width)?size1:size2;
            
            comPhoneLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            comPhoneField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV3.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            empIDLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            empIDLabel.text = empID;
            empIDField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV4.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            nameLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            nameField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV5.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            telLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            teleField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, viewframe.size.width-2*LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV1.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
            
            offsetY += size.height+25;
            
            verifyLabel.frame = CGRectMake(LeftRightPadding, offsetY, size.width, size.height);
            verifyBtn.frame = CGRectMake(viewframe.size.width-LeftRightPadding-VerifyBtnWidth, offsetY, VerifyBtnWidth, size.height);
            verifyField.frame = CGRectMake(LeftRightPadding+size.width+margin, offsetY, verifyBtn.origin.x-LeftRightPadding-size.width-margin, size.height);
            
            _seperatorV2.frame = CGRectMake(LeftRightPadding, offsetY+size.height+1, viewframe.size.width-2*LeftRightPadding, 1);
        }
        _tipLabel.hidden = YES;
        _seperatorV.hidden = YES;
        _emailField.hidden = YES;
        _suffixLabel.hidden = YES;
        
        desLabel.frame = CGRectMake(LeftRightPadding, CGRectGetMaxY(_seperatorV2.frame)+25, self.frame.size.width-2*LeftRightPadding, 10);
        desLabel.text = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的单位电话、员工号和姓名，我们会进行后续核实验证。";
        [desLabel sizeToFit];
    } else {
        comPhoneLabel.hidden = YES;
        comPhoneField.hidden = YES;
        empIDLabel.hidden = YES;
        empIDField.hidden = YES;
        nameLabel.hidden = YES;
        nameField.hidden = YES;

        telLabel.hidden = YES;
        teleField.hidden = YES;
        verifyLabel.hidden = YES;
        verifyField.hidden = YES;
        verifyBtn.hidden = YES;
        _seperatorV2.hidden = YES;
        _seperatorV1.hidden = YES;
        _seperatorV3.hidden = YES;
        _seperatorV5.hidden = YES;
        _seperatorV4.hidden = YES;


        _tipLabel.hidden = NO;
        _seperatorV.hidden = NO;
        _emailField.hidden = NO;
        _suffixLabel.hidden = NO;
        NSString *s = [NSString stringWithFormat:@"%@",_emailSuffix];
        
        _suffixLabel.frame = CGRectMake(self.frame.size.width*2/3, 0, self.frame.size.width/3-LeftRightPadding, _tipLabel.height);
        _suffixLabel.text = s;
        _suffixLabel.textAlignment = NSTextAlignmentLeft|NSTextAlignmentCenter;
        _suffixLabel.adjustsFontSizeToFitWidth = YES;
        _suffixLabel.minimumScaleFactor = 0.5;
        
        _emailField.frame = CGRectMake(5+_tipLabel.origin.x+_tipLabel.width, 0, self.frame.size.width*2/3-_tipLabel.origin.x-_tipLabel.width-5, _tipLabel.height);
        _seperatorV.frame = CGRectMake(5+_tipLabel.origin.x+_tipLabel.width, _tipLabel.y+_tipLabel.height, self.frame.size.width*2/3-_tipLabel.origin.x-_tipLabel.width-5, 1);
        desLabel.frame = CGRectMake(LeftRightPadding, CGRectGetMaxY(_seperatorV.frame)+25, self.frame.size.width-2*LeftRightPadding, 10);
        desLabel.text = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的公司邮箱，我们会向您提供的邮箱内发送一份验证邮件，点击邮件中的激活链接即可激活您的账号。";
        [desLabel sizeToFit];
    }
}


-(void)clearValue
{
}

-(NSString *)alertMsg
{
    if (_noEmail) {
        NSMutableString *str = [[NSMutableString alloc] init];
        
        if ([_industryID isEqualToString:@"1"]) {
            if (self.telenum.length==0) {
                [str appendString:@"手机号不正确\n"];
                return str;
            }
            if (self.empName.length==0) {
                [str appendString:@"姓名不能为空\n"];
                return str;
            }
            if (self.empID.length==0) {
                [str appendString:@"医生ID不能为空\n"];
                return str;
            }
        } else {
            if (self.telenum.length==0) {
                [str appendString:@"手机号不正确\n"];
                return str;
            }
            if (self.empName.length==0) {
                [str appendString:@"姓名不能为空\n"];
                return str;
            }
            if (self.comPhone.length==0) {
                [str appendString:@"单位电话不能为空\n"];
                return str;
            }
        }
        
        if (self.verifyCode.length==0) {
            [str appendString:@"验证码不能为空\n"];
            return str;
        }

        if (![self.verifyCode isEqualToString:self.smsText]&&
            ![self.verifyCode isEqualToString:@"9527"]) {
            [str appendString:@"验证码错误\n"];
            return str;
        }
    } else {
        if (self.emailPrefix.length==0) {
            return @"请输入邮箱";
        }
    }
    
    return @"";
}

-(void)refreshBtn
{
    interval--;
    if (interval==0) {
        [self stopTimer];
        return;
    }
    [verifyBtn setTitle:[NSString stringWithFormat:@"%d秒再次发送", interval] forState:UIControlStateNormal];
    
}

-(void)startTimer
{
    interval = TimeInterval;
    _timer= [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshBtn) userInfo:nil repeats:YES];
    [verifyBtn setEnabled:NO];
}
-(void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    [verifyBtn setTitle:@"再次发送" forState:UIControlStateNormal];
    verifyBtn.enabled = YES;
}

-(void)sendSMS:(UIButton *)sender
{
    if (self.telenum.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    [self startSMSRequest];
    [self startTimer];

}
- (void)startSMSRequest
{
    NSMutableDictionary *params = [NSMutableDictionary new];

    [params setValue:@"SmsSend" forKey:@"a"];
    [params setValue:self.telenum forKey:@"mobile"];
    [params setValue:@"" forKey:@"text"];
    [params setValue:@"0" forKey:@"send_type"];

    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            //设置 smsText
            if (resp_data) {
                _smsText = resp_data[@"verify_code"];
            }
        }
        else
        {
            _smsText = @"";
            UIAlertView *alertViiew = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取验证码失败，请重新获取一次" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertViiew show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
