//
//  UpRegisterController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpRegisterController.h"
#import "UPGoShareController.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "UPRegisterView.h"
#import "UpRegister1.h"
#import "UpRegister2.h"
#import "UpRegister3.h"
#import "UpRegister4.h"
#import "UpRegister5.h"

#import "XWHttpTool.h"

#import "AFHTTPRequestOperationManager.h"
#import "UPDataManager.h"
#import "Info.h"
#import "UPTheme.h"
#import "UPGlobals.h"
#import "UPTools.h"
#import "DrawSomething.h"
#import "UPConfig.h"


#define BtnSpace 40
typedef enum register_enum
{
    CITY_REQ = 0,
    INDUSTRY_REQ=1,
    COMPANY_REQ=2,
    SMS_REQ=3,
    REGISTER_REQ=4
} RegType;

@interface UpRegisterController () <UPRegistV4Delegate>
{
    int tag;
    id parent;
    int whichStep;
    NSArray *steps;
    NSMutableArray<UPRegisterView *> *registerArr;
    
    UIBarButtonItem *leftBarItem;
    
    BOOL isLoading;
}


@property (nonatomic,retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *preBtn;
@property (nonatomic,retain) UpRegister1 *registerV1;
@property (nonatomic,retain) UpRegister2 *registerV2;
@property (nonatomic,retain) UpRegister3 *registerV3;
@property (nonatomic,retain) UpRegister4 *registerV4;
@property (nonatomic,retain) UpRegister5 *registerV5;
@property (nonatomic,retain) UILabel *tipsLabel;
@end

@implementation UpRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    whichStep = 0;
 
    self.navigationItem.title = @"注册";
    
    leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    
    isLoading = NO;
    
    steps = [[NSArray alloc]initWithObjects:@"Step1:选择城市", @"Step2:选择行业", @"Step3:选择公司", @"Step4:完善资料", @"Step5:行业验证", nil];
    
    CGFloat y = FirstLabelHeight;
    
    NSString *tipsText = [steps objectAtIndex:whichStep];
    CGSize tipsSize = SizeWithFont(tipsText, [UIFont systemFontOfSize:12]);

    self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, tipsSize.width+5, tipsSize.height)];
    
    self.tipsLabel.text = tipsText;
    self.tipsLabel.font = [UIFont systemFontOfSize:12];
    self.tipsLabel.textColor = [UIColor whiteColor];
    self.tipsLabel.backgroundColor = [UIColor blackColor];

    CGSize size = SizeWithFont(@"上一步",kUPThemeMiddleFont);
    size.width +=20;
    size.height += 10;
    
    self.preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preBtn.titleLabel.font = kUPThemeMiddleFont;
    self.preBtn.tag = 11;
    self.preBtn.frame = CGRectMake(BtnSpace, ScreenHeight-size.height-20, size.width, size.height);
    [self.preBtn.layer setMasksToBounds:YES];
    [self.preBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    self.preBtn.backgroundColor = [UIColor whiteColor];
    [self.preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.preBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.tag = 12;
    self.nextBtn.titleLabel.font = kUPThemeMiddleFont;
    self.nextBtn.frame = CGRectMake(ScreenWidth-BtnSpace-size.width, ScreenHeight-size.height-20, size.width, size.height);
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    self.nextBtn.backgroundColor = [UIColor whiteColor];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.registerV1 = [[UpRegister1 alloc]initWithFrame:CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20)];
    self.registerV1.tag = 0;
    self.registerV1.hidden=YES;
    
    self.registerV2 = [[UpRegister2 alloc]initWithFrame:CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20)];
    self.registerV2.tag = 1;
    self.registerV2.hidden=YES;

    
    self.registerV3 = [[UpRegister3 alloc]initWithFrame:CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20)];
    self.registerV3.tag = 2;
    self.registerV3.hidden=YES;

    
    self.registerV4 = [[UpRegister4 alloc]initWithFrame:CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20)];
    self.registerV4.tag = 3;
    self.registerV4.hidden=YES;
    self.registerV4.delegate=self;
    
    self.registerV5 = [[UpRegister5 alloc]initWithFrame:CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20)];
    self.registerV5.tag = 4;
    self.registerV5.hidden=YES;
    
    registerArr = [[NSMutableArray alloc]initWithObjects:_registerV1, _registerV2, _registerV3,_registerV4,_registerV5, nil];
    
    [self.view addSubview:_tipsLabel];
    [self.view addSubview:self.nextBtn];
    [self.view addSubview:self.preBtn];
    [self.view addSubview:self.registerV1];
    [self.view addSubview:self.registerV2];
    [self.view addSubview:self.registerV3];
    [self.view addSubview:self.registerV4];
    [self.view addSubview:self.registerV5];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showRegisterView:whichStep];
    [self.registerV1 loadAlphabetCitInfo];
}

- (void)leftClick
{
    if (whichStep==0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (whichStep==2) {
            self.registerV3.searchBar.showsCancelButton = NO;
            [self.registerV3.searchBar resignFirstResponder];
        }
        
        int toStep = whichStep-1;
        if (toStep==0) {
            [leftBarItem setTitle:@"返回"];
        } else {
            [leftBarItem setTitle:@"上一步"];
        }
        [self showRegisterView:toStep];
    }
}

-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag ==11) {
        [self showRegisterView:(whichStep-1)];
    }
    
    if (sender.tag==12) {
        NSString *alerMsg = [registerArr[whichStep] alertMsg];
        if (alerMsg.length!=0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:alerMsg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }
        
        //获取参数
        switch (whichStep) {
            case 0:
                _cityId = self.registerV1.cityId;
                _provCode = self.registerV1.provId;
                _cityCode = self.registerV1.cityId;
                _townCode = self.registerV1.townId;
                break;
            case 1:
                _industryId = self.registerV2.industryId;
                [self.registerV3 resetSubView];
                break;
            case 2:
                _companyId = self.registerV3.companyId;
                _emailSuffix = self.registerV3.emailSuffix;
                self.registerV3.searchBar.showsCancelButton = NO;
                [self.registerV3.searchBar resignFirstResponder];
                break;
            case 3:
                _name = self.registerV4.username;
                _password = self.registerV4.password;
                _sex = self.registerV4.sexType;
                break;
            case 4:
            {
                [self startRequest:REGISTER_REQ];
                return;
            }
                break;
            default:
                break;
        }
        [self showRegisterView:(whichStep+1)];
    }
}

- (void)showRegisterView:(int)idx
{
    if (idx==0) {
        [leftBarItem setTitle:@"返回"];
    } else {
        [leftBarItem setTitle:@"上一步"];
    }

    CGSize size = SizeWithFont(@"上一步", kUPThemeMiddleFont);
    size.width +=20;
    
    if (whichStep==idx-1&&idx!=4) {
        [self startRequest:idx];
    }
    
    _tipsLabel.text = [steps objectAtIndex:idx];

    if (idx==0) {
        self.preBtn.hidden=YES;
        [self.preBtn setTitle:@"上一步" forState:UIControlStateNormal];
        self.nextBtn.centerX = ScreenWidth/2;
    }
    else if(idx>=1&&idx<=3){
        self.preBtn.hidden=NO;
        self.preBtn.centerX = BtnSpace+size.width/2;
        self.nextBtn.centerX = ScreenWidth-BtnSpace-size.width/2;
        [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    else if(idx==4){
        if (_emailSuffix &&_emailSuffix.length>0) {
            self.registerV5.noEmail = NO;
            self.registerV5.emailSuffix = _emailSuffix;
        } else {
            self.registerV5.noEmail = YES;
        }
        
        self.registerV5.industryID = _industryId;
        
        [self.registerV5 resize];
        [self.nextBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    
    for (int i=0; i<5; i++) {
        ((UPRegisterView*)registerArr[i]).hidden=YES;
    }
    ((UPRegisterView*)registerArr[idx]).hidden=NO;
    
    whichStep = idx;
}


- (void)startRequest:(int)type
{
    [self checkNetStatus];

    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    
    switch (type) {
        case INDUSTRY_REQ:
            [params setValue:@"IndustryQuery" forKey:@"a"];
            [params setValue:_cityId forKey:@"cityId"];

            break;
        case COMPANY_REQ:
            [params setValue:@"NodeQuery" forKey:@"a"];
            [params setValue:_cityId forKey:@"city_code"];
            [params setValue:_industryId forKey:@"industry_id"];
            break;
            
        case REGISTER_REQ:
            [params setValue:@"Register" forKey:@"a"];
            [params setValue:_companyId forKey:@"node_id"];
            [params setValue:_name forKey:@"user_name"];
            [params setValue:[UPTools md5HexDigest:_password] forKey:@"user_pass"];
            [params setValue:@"0" forKey:@"pass_type"];
            [params setValue:_industryId forKey:@"industry_id"];
            [params setValue:self.registerV5.telenum forKey:@"mobile"];
            [params setValue:_sex forKey:@"sexual"];
            
            [params setValue:_provCode forKey:@"province_code"];
            [params setValue:_cityCode forKey:@"city_code"];
            [params setValue:_townCode forKey:@"town_code"];
            

            /**
             一、用户注册验证信息、激活方式、密码找回
             case 1：有企业邮箱的公司员工。
             验证信息：企业邮箱。
             其它输入项：无。
             激活方式：邮箱邮件激活链接。
             密码找回：通过邮箱重置密码。
             case 2： 医生
             验证信息：好医生id。
             其它输入项：手机号（必填），姓名（必填）。
             case 3：非医生，且无企业邮箱的员工
             验证信息：企业电话+手机号。
             其它输入项：姓名（必填），工号（选填，可能没有）
             
             注册校验：验证信息+验证方式全局唯一
             用户名全局唯一
             不为空的手机号全局唯一。
             1. 邮箱验证：identify_id 传邮箱值
             2. 职业id验证：identify_id传职业id
             identify_type传1
             3.人工复核：identify_id传“企业电话|工号”
             identify_type传2
             employee_id传工号
             mobile传手机
             */
            //需要根据行业进行条件判断
            [params setValue:self.registerV5.empName forKey:@"true_name"];
            [params setValue:self.registerV5.empID forKey:@"employee_id"];
            [params setValue:self.registerV5.identifyType forKey:@"identify_type"];
            [params setValue:self.registerV5.identifyID forKey:@"identify_id"];
            
            break;
        default:
            return;
    }

    [self loadDataForType:type withURL:kUPBaseURL parameters:params];
}

// ------公共方法
-(void)loadDataForType:(int)type withURL:(NSString *)url parameters:params
{
    if (isLoading) { //如果正在发送请求
        return;
    } else {
        isLoading = YES;
    }
    
    [XWHttpTool getDetailWithUrl:url parms:params success:^(id json) {
        isLoading = NO;
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            switch (type) {
                case CITY_REQ:
                {
                    break;
                }
                case INDUSTRY_REQ:
                {
                    [self.registerV2 loadIndustryData:resp_data];
                    break;
                }
                case COMPANY_REQ:
                {
                    [self.registerV3 loadCompanyData:resp_data];
                    break;
                }
                case REGISTER_REQ:
                {
                    NSString *resp_desc = dict[@"resp_desc"];
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册成功" message:resp_desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [alertView show];
                    
                    UPGoShareController *shareVC = [[UPGoShareController alloc] init];
                    [self.navigationController pushViewController:shareVC animated:YES];
                    
                    [self clearRegisterInfo];
                    
                    break;
                }
                default:
                    break;
            }
        }
        else
        {
            NSDictionary *dict = (NSDictionary *)json;
            NSString *resp_desc = dict[@"resp_desc"];

            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:resp_desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failture:^(id error) {
        isLoading = NO;
        
        NSLog(@"%@",error);
    }];
}

-(void)clearRegisterInfo
{
    whichStep = 0;
    for (UPRegisterView *view in registerArr) {
        [view clearValue];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.registerV5 stopTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UPRegisterV4

-(void)beginEditing:(CGFloat)height
{
    int offset = height+self.registerV4.origin.y-(self.view.frame.size.height-216.0);//键盘高度216
    if (offset>0) {
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        [UIView animateWithDuration:0.5f animations:^{
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

-(void)endEditing
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

@end
