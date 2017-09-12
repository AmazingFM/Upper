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

#import "UPCustomField.h"

#define VERTICAL_SPACE 40
#define VerifyBtnWidth 100
#define TimeInterval 10

@implementation UPRegisterCellItem

@end

@interface UPRegisterCell()

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UPUnderLineField *field;
@property (nonatomic, strong) UIButton *actionButton;

@end
@implementation UPRegisterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.descLabel = [self createLabelWithFont:[UIFont systemFontOfSize:15.f]];
        self.descLabel.numberOfLines = 0;
        
        self.titleLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12.f]];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        self.emailLabel = [self createLabelWithFont:[UIFont systemFontOfSize:15.f]];
        self.emailLabel.adjustsFontSizeToFitWidth = YES;
        self.emailLabel.minimumScaleFactor = 0.5;
        
        self.field = [self createField];
        
        self.actionButton = [self createButton];
        
        [self addSubview:self.descLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.emailLabel];
        [self addSubview:self.field];
        [self addSubview:self.actionButton];
    }
    return self;
}

- (void)setCellItem:(UPRegisterCellItem *)cellItem
{
    _cellItem = cellItem;
    
    switch (cellItem.cellStyle) {
        case UPRegisterCellStyleText:
        {
            self.descLabel.hidden = NO;
            
            self.titleLabel.hidden = YES;
            self.emailLabel.hidden = YES;
            self.field.hidden = YES;
            
            self.actionButton.hidden = YES;
        }
            break;
        case UPRegisterCellStyleEmail:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = NO;
            self.emailLabel.hidden = NO;
            self.field.hidden = NO;
            
            self.actionButton.hidden = NO;
        }
            break;
        case UPRegisterCellStyleButton:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = YES;
            self.emailLabel.hidden = YES;
            self.field.hidden = YES;
            
            self.actionButton.hidden = NO;
        }
            break;
        default:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = YES;
            self.emailLabel.hidden = YES;
            self.field.hidden = YES;
            
            self.actionButton.hidden = YES;
        }
            break;
    }
}

- (UILabel *)createLabelWithFont:(UIFont *)font
{
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    return label;
}

- (UPUnderLineField *)createField
{
    UPUnderLineField *field = [[UPUnderLineField alloc]initWithFrame:CGRectZero];
    [field setFont:[UIFont systemFontOfSize:15.0]];
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    return field;
}

- (UIButton *)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"xxx" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    
}
@end

@interface UpRegister5() <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
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
    
    UIButton *viewChangeBtn;
}

@property (nonatomic, copy) NSString *verifyCode;

@property (nonatomic, retain) UILabel *tipLabel;
@property (nonatomic, retain) UIImageView *seperatorV;
@property (nonatomic, retain) UIView *seperatorV1;
@property (nonatomic, retain) UIView *seperatorV2;
@property (nonatomic, retain) UIView *seperatorV3;
@property (nonatomic, retain) UIView *seperatorV4;
@property (nonatomic, retain) UIView *seperatorV5;

@property (nonatomic, strong) NSMutableArray<UPRegisterCellItem*> *itemList;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UpRegister5

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    viewframe = frame;
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self addSubview:_tableView];
//----------------------------------
    float offsetY = 0;
    
    UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
    descItem.key = @"desc";
    descItem.cellStyle = UPRegisterCellStyleText;
    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的公司邮箱，我们会向您提供的邮箱内发送一份验证邮件，点击邮件中的激活链接即可激活您的账号。";
    
    UPRegisterCellItem *emailItem = [[UPRegisterCellItem alloc] init];
    emailItem.key = @"email";
    emailItem.cellStyle = UPRegisterCellStyleEmail;
    emailItem.title = @"行业邮箱\nEmail";
    
    UPRegisterCellItem *comPhoneItem = [[UPRegisterCellItem alloc] init];
    comPhoneItem.key = @"comPhone";
    comPhoneItem.cellStyle = UPRegisterCellStyleNumField;
    comPhoneItem.title = @"单位电话\nCom Tele";
    
    UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
    empIdItem.key = @"empID";
    empIdItem.cellStyle = UPRegisterCellStyleField;
    empIdItem.title = @"员工号\nEmp NO.";

    UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
    nameItem.key = @"name";
    nameItem.cellStyle = UPRegisterCellStyleField;
    nameItem.title = @"姓名\nName";
    
    UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
    telephoneItem.key = @"telephone";
    telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
    telephoneItem.title = @"手机号\nCellphone";
    
    __weak typeof(self) weakSelf = self;
    telephoneItem.actionBlock = ^{
        [weakSelf startSMSRequest];
    };
    
    UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
    noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
    noEmailBtnItem.title = @"没有公司邮箱?";
    noEmailBtnItem.actionBlock = ^{
        [weakSelf resize];
    };

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
    comPhoneField.autocorrectionType = UITextAutocorrectionTypeNo;
    comPhoneField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    teleField.keyboardType = UIKeyboardTypeNumberPad;
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
    verifyField.keyboardType = UIKeyboardTypeNumberPad;
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
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.autocorrectionType = UITextAutocorrectionTypeNo;
    _emailField.autocapitalizationType = UITextAutocapitalizationTypeNone;
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
    
    viewChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    viewChangeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [viewChangeBtn setTitle:@"没有公司邮箱?" forState:UIControlStateNormal];
    [viewChangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    viewChangeBtn.highlighted = NO;
    viewChangeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [viewChangeBtn addTarget:self action:@selector(changeViewType:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    return self;
}

- (NSMutableArray<UPRegisterCellItem*> *)itemList
{
    if (_itemList==nil) {
        _itemList = [NSMutableArray new];
    }
    return _itemList;
}

- (void)reloadItems
{
    [self.tableView reloadData];
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
        if ([self.industryID isEqualToString:@"1"]) {//医生
            [self.itemList removeAllObjects];
            
            UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
            descItem.key = @"desc";
            descItem.cellStyle = UPRegisterCellStyleText;
            descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的姓名、好医生ID和手机号，我们会进行后续核实验证。";
            
            UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
            empIdItem.key = @"doctorID";
            empIdItem.cellStyle = UPRegisterCellStyleField;
            empIdItem.title = @"好医生ID\nDoctor ID";
            
            UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
            nameItem.key = @"name";
            nameItem.cellStyle = UPRegisterCellStyleField;
            nameItem.title = @"姓名\nName";
            
            UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
            telephoneItem.key = @"telephone";
            telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
            telephoneItem.title = @"手机号\nCellphone";
            __weak typeof(self) weakSelf = self;
            telephoneItem.actionBlock = ^{
                [weakSelf startSMSRequest];
            };
            
            UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
            verifyItem.key = @"verify";
            verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
            verifyItem.title = @"验证码\nVerifyCode";
            
            [self.itemList addObject:descItem];
            [self.itemList addObject:empIdItem];
            [self.itemList addObject:nameItem];
            [self.itemList addObject:telephoneItem];
            [self.itemList addObject:verifyItem];
        } else {
            [self.itemList removeAllObjects];
            UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
            descItem.key = @"desc";
            descItem.cellStyle = UPRegisterCellStyleText;
            descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的单位电话、员工号和姓名，我们会进行后续核实验证。";
            
            __weak typeof(self) weakSelf = self;
            if([self.industryID isEqualToString:@"1"]) {//航空) {
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"没有公司邮箱?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf resize];
                    [weakSelf reloadItems];
                };
                [self.itemList addObject:noEmailBtnItem];
            }
            
            UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
            empIdItem.key = @"empID";
            empIdItem.cellStyle = UPRegisterCellStyleField;
            empIdItem.title = @"员工号\nEmp NO.";
            
            UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
            nameItem.key = @"name";
            nameItem.cellStyle = UPRegisterCellStyleField;
            nameItem.title = @"姓名\nName";
            
            UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
            telephoneItem.key = @"telephone";
            telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
            telephoneItem.title = @"手机号\nCellphone";
            telephoneItem.actionBlock = ^{
                [weakSelf startSMSRequest];
            };
            
            UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
            verifyItem.key = @"verify";
            verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
            verifyItem.title = @"验证码\nVerifyCode";
            
            [self.itemList addObject:descItem];
            [self.itemList addObject:empIdItem];
            [self.itemList addObject:nameItem];
            [self.itemList addObject:telephoneItem];
            [self.itemList addObject:verifyItem];
        }
    } else {
        [self.itemList removeAllObjects];
        UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
        descItem.key = @"desc";
        descItem.cellStyle = UPRegisterCellStyleText;
        descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的公司邮箱，我们会向您提供的邮箱内发送一份验证邮件，点击邮件中的激活链接即可激活您的账号。";
        
        UPRegisterCellItem *emailItem = [[UPRegisterCellItem alloc] init];
        emailItem.key = @"email";
        emailItem.cellStyle = UPRegisterCellStyleEmail;
        emailItem.title = @"行业邮箱\nEmail";
        
        [self.itemList addObject:descItem];
        [self.itemList addObject:emailItem];
        
        __weak typeof(self) weakSelf = self;
        if([self.industryID isEqualToString:@"1"]) {//航空) {
            UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
            noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
            noEmailBtnItem.title = @"没有公司邮箱?";
            noEmailBtnItem.actionBlock = ^{
                [weakSelf resize];
                [weakSelf reloadItems];
            };
            [self.itemList addObject:noEmailBtnItem];
        }
    }
    
    [self.itemList enumerateObjectsUsingBlock:^(UPRegisterCellItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.cellWidth = viewframe.size.width;
        
        if ([obj.key isEqualToString:@"desc"]) {
            NSString *titleStr = obj.title;
            CGRect rect = [titleStr boundingRectWithSize:CGSizeMake(obj.cellWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} context:nil];
            obj.cellHeight = rect.size.height;
        } else {
            obj.cellHeight = 44;
        }
    }];
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
            [self stopTimer];
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

- (void)singleTap:(UIGestureRecognizer *)gesture
{
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            [subView resignFirstResponder];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPRegisterCellItem *cellItem = self.itemList[indexPath.row];
    return cellItem.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UPRegisterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UPRegisterCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UPRegisterCellItem *cellItem = self.itemList[indexPath.row];
    cell.cellItem = cellItem;
    
    return cell;
}
@end
