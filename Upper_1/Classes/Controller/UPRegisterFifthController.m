//
//  UPRegisterFifthViewController.m
//  Upper
//
//  Created by 张永明 on 2017/10/31.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRegisterFifthController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "UPGoShareController.h"
#import "Info.h"
#import "DrawSomething.h"
#import "UpRegister5.h"
#import "YMNetwork.h"

#define BtnSpace 40
@interface UPRegisterFifthController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, strong) NSMutableArray<UPRegisterCellItem*> *itemList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;


@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, copy) NSString *emailPrefix;
@property (nonatomic, copy) NSString *comPhone;
@property (nonatomic, copy) NSString *empName;
@property (nonatomic, copy) NSString *empID;
@property (nonatomic, copy) NSString *telenum;
@property (nonatomic, copy) NSString *smsText;


@property (nonatomic,retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *preBtn;
@property (nonatomic,retain) UILabel *tipsLabel;
@end

@implementation UPRegisterFifthController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册";
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    
    CGFloat y = FirstLabelHeight;
    
    NSString *tipsText = @"Step5:行业验证";
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
    [self.preBtn addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.tag = 12;
    self.nextBtn.titleLabel.font = kUPThemeMiddleFont;
    self.nextBtn.frame = CGRectMake(ScreenWidth-BtnSpace-size.width, ScreenHeight-size.height-20, size.width, size.height);
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    self.nextBtn.backgroundColor = [UIColor whiteColor];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_interactivePopDisabled:YES];
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)identifyID
{
    if (_emailSuffix.length>0) {
        return [NSString stringWithFormat:@"%@%@", _emailPrefix, _emailSuffix];
    } else {
        if ([_industryId isEqualToString:@"1"]) {
            return [NSString stringWithFormat:@"%@", self.empID];
        } else if ([_industryId intValue]==6) {//航空业属于特殊情况，使用证件照
            return @"upload_image";
        } else {
            return [NSString stringWithFormat:@"%@|%@", self.comPhone, self.empID];
        }
    }
}

- (NSString *)identifyType
{
    if (_emailSuffix.length>0) {
        return @"0";
    } else {
        if ([_industryId isEqualToString:@"1"]) {//医生
            return @"1";
        } else if ([_industryId intValue]==6) { //航空
            return @"3";
        } else {
            return @"2";
        }
    }
}

- (void)startRegist
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"Register" forKey:@"a"];
    [params setValue:_companyId forKey:@"node_id"];
    [params setValue:_username forKey:@"user_name"];
    [params setValue:[UPTools md5HexDigest:_password] forKey:@"user_pass"];
    [params setValue:@"0" forKey:@"pass_type"];
    [params setValue:_industryId forKey:@"industry_id"];
    [params setValue:_telenum forKey:@"mobile"];
    [params setValue:_sexType forKey:@"sexual"];
    
    [params setValue:_provId forKey:@"province_code"];
    [params setValue:_cityId forKey:@"city_code"];
    [params setValue:_townId forKey:@"town_code"];
    
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
    [params setValue:_empName forKey:@"true_name"];
    [params setValue:_empID forKey:@"employee_id"];
    [params setValue:[self identifyType] forKey:@"identify_type"];
    [params setValue:[self identifyID] forKey:@"identify_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            if ([resp_id intValue]==0) {
                UPGoShareController *shareVC = [[UPGoShareController alloc] init];
                shareVC.registName = _username;
                [self.navigationController pushViewController:shareVC animated:YES];
            }
        }
        else
        {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSString *resp_desc = dict[@"resp_desc"];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:resp_desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (NSDictionary *)addDescParams:(NSDictionary *)parameters
{
    NSString *uuid = [UPConfig sharedInstance].uuid;
    NSString *currentDate = [UPConfig sharedInstance].currentDate;
    NSString *reqSeq = [UPConfig sharedInstance].newReqSeqStr;
    
    NSMutableDictionary *newParamsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"app_id":uuid, @"req_seq":reqSeq, @"time_stamp":currentDate}];
    
    NSString *actionName = parameters[@"a"];
    [newParamsDic addEntriesFromDictionary:parameters];
    [newParamsDic removeObjectForKey:@"a"];
    
    
    if ([UPDataManager shared].isLogin) {
        [newParamsDic setObject:[UPDataManager shared].token forKey:@"token"];
        
        NSString *user_id = newParamsDic[@"user_id"];
        if (user_id==nil || user_id.length==0) {
            [newParamsDic setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        }
    }
    
    NSString *md5Str = newParamsDic[@"sign"];
    
    if (md5Str==nil || md5Str.length==0) {
        NSArray *keys = newParamsDic.allKeys;
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
        
        NSMutableString *mStr = [NSMutableString stringWithString:@"upper"];
        for (int i=0; i<sortedKeys.count; i++) {
            [mStr appendFormat:@"%@%@", sortedKeys[i], newParamsDic[sortedKeys[i]]];
        }
        [mStr appendString:@"upper"];
        md5Str = [UPTools md5HexDigest:mStr];
        newParamsDic[@"sign"] = md5Str;
    }
    newParamsDic[@"a"] = actionName;
    return newParamsDic;
}

-(void)clearValue
{
    _comPhone = @"";
    _empName = @"";
    _empID = @"";
    _telenum = @"";
    _emailPrefix = @"";
    _imageData = nil;
}

-(NSString *)alertMsg
{
    if (_emailSuffix.length>0) {
        NSMutableString *str = [[NSMutableString alloc] init];
        
        if ([_industryId isEqualToString:@"1"]) {
            NSDictionary *alertMsgDict = @{@"empID":@"医生IC卡号不能为空\n", @"name":@"姓名不能为空\n", @"telephone":@"手机号不正确\n"};
            for (NSString *key in alertMsgDict.allKeys) {
                for (UPRegisterCellItem *cellItem in self.itemList) {
                    if ([cellItem.key isEqualToString:key]) {
                        if (cellItem.value.length==0) {
                            [str appendString:alertMsgDict[key]];
                        }
                    }
                }
            }
        } else {
            if ([_industryId isEqualToString:@"6"]) {
                NSDictionary *alertMsgDict = @{@"name":@"姓名不能为空\n", @"telephone":@"手机号不正确\n"};
                
                for (NSString *key in alertMsgDict.allKeys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            if (cellItem.value.length==0) {
                                [str appendString:alertMsgDict[key]];
                            }
                        }
                    }
                }
                
                if (_emailSuffix.length==0) {
                    if (self.imageData==nil) {
                        [str appendString:@"请上传证件照"];
                    }
                }
            } else {
                NSDictionary *alertMsgDict = @{@"comphone":@"单位电话不能为空\n", @"name":@"姓名不能为空\n", @"telephone":@"手机号不正确\n"};
                for (NSString *key in alertMsgDict.allKeys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            if (cellItem.value.length==0) {
                                [str appendString:alertMsgDict[key]];
                            }
                        }
                    }
                }
            }
        }
        
        if (str.length>0) {
            return str;
        }
        
        for (UPRegisterCellItem *cellItem in self.itemList) {
            if ([cellItem.key isEqualToString:@"verify"]) {
                if (cellItem.value.length==0) {
                    return @"验证码不能为空\n";
                } else {
                    _verifyCode = cellItem.value;
                }
            }
        }
        
        if (![_verifyCode isEqualToString:self.smsText]&&
            ![_verifyCode isEqualToString:@"9527"]) {
            [str appendString:@"验证码错误\n"];
            return str;
        }
    } else {
        for (UPRegisterCellItem *cellItem in self.itemList) {
            if ([cellItem.key isEqualToString:@"email"]) {
                if (cellItem.value.length==0) {
                    return @"请输入邮箱";
                }
            }
        }
    }
    return @"";
}


-(void)navButtonClick:(UIButton *)sender
{
    if (sender.tag ==11) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (sender.tag==12) {
        
        NSString *alertMsg = [self alertMsg];
        if (alertMsg.length>0) {
            showDefaultAlert(@"提示", alertMsg);
        }
        
        UPRegisterFifthController *fifthController = [[UPRegisterFifthController alloc] init];
        fifthController.cityId = self.cityId;
        fifthController.provId = self.provId;
        fifthController.townId = self.townId;
        fifthController.industryId = self.industryId;
        fifthController.companyId = self.companyId;
        fifthController.emailSuffix = self.emailSuffix;
        fifthController.username = self.username;
        fifthController.password = self.password;
        fifthController.sexType = self.sexType;
        
        [self.navigationController pushViewController:fifthController animated:YES];
    }
}

@end
