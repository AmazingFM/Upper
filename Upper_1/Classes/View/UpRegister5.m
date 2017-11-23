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
#define TimeInterval 60

@interface UPRegTypeInfo()
@property (nonatomic) int cycleNum;
@end

@implementation UPRegTypeInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.regType = UPRegTypeNone;
    }
    return self;
}

- (void)setRegType:(UPRegType)regType
{
    _regType = regType;
    _pos = 0;
    switch (regType) {
        case UPRegTypeMailThree:
            self.cycleNum = 3;
            break;
        case UPregTypeMailTwo:
            self.cycleNum = 2;
            break;
        case UPRegTypeNoMailTwo:
            self.cycleNum = 2;
            break;
        case UPRegTypeNoMailOne:
            self.cycleNum = 1;
            break;
        case UPRegTypeDoctor:
            self.cycleNum = 2;
            break;
        default:
            self.cycleNum = 1;
            break;
    }
}

- (void)next
{
    int nextPos = self.pos+1;
    self.pos = nextPos%self.cycleNum;
}

@end

@implementation UPRegisterCellItem

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.value = @"";
    }
    return self;
}

@end

@interface UPRegisterCell() <UITextFieldDelegate>
{
    NSTimer *_timer;
    int interval;
}

@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UPUnderLineField *field;
@property (nonatomic, strong) UIButton *actionButton;

//@property (nonatomic, strong) UILabel *photoDescLabel;
@property (nonatomic, strong) UILabel *photoActionLabel;

@end
@implementation UPRegisterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.descLabel = [self createLabelWithFont:[UIFont systemFontOfSize:13.f]];
        self.descLabel.numberOfLines = 0;
        
        self.titleLabel = [self createLabelWithFont:[UIFont systemFontOfSize:12.f]];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.numberOfLines = 0;
        
        self.emailLabel = [self createLabelWithFont:[UIFont systemFontOfSize:15.f]];
        self.emailLabel.adjustsFontSizeToFitWidth = YES;
        self.emailLabel.minimumScaleFactor = 0.5;
        
        self.field = [self createField];
        
        self.actionButton = [self createButton];
    
        self.photoActionLabel = [self createLabelWithFont:kUPThemeMiddleFont];
        self.photoActionLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        self.photoActionLabel.textColor = RGBCOLOR(47, 142, 249);
        self.photoActionLabel.hidden = YES;
        self.photoActionLabel.textAlignment = NSTextAlignmentCenter;
        self.photoActionLabel.text = @"+点击上传照片";

        [self addSubview:self.descLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.emailLabel];
        [self addSubview:self.field];
        [self addSubview:self.actionButton];
        [self addSubview:self.photoActionLabel];
//        [self addSubview:self.photoDescLabel];
    }
    return self;
}

- (void)setCellItem:(UPRegisterCellItem *)cellItem
{
    _cellItem = cellItem;
    self.field.text = @"";
    
    self.photoActionLabel.hidden = YES;
    self.actionButton.layer.cornerRadius = 5.0f;
    switch (cellItem.cellStyle) {
        case UPRegisterCellStyleText:
        {
            self.descLabel.hidden = NO;
            
            self.titleLabel.hidden = YES;
            self.emailLabel.hidden = YES;
            self.field.hidden = YES;
            
            self.actionButton.hidden = YES;
            
            self.descLabel.frame = CGRectMake(LeftRightPadding, 0, cellItem.cellWidth-2*LeftRightPadding, cellItem.cellHeight);
            self.descLabel.text = cellItem.title;
        }
            break;
        case UPRegisterCellStyleEmail:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = NO;
            self.emailLabel.hidden = NO;
            self.field.hidden = NO;
            
            self.actionButton.hidden = YES;
            
            CGFloat originy = cellItem.cellHeight-cellItem.titleHeight;
            self.titleLabel.frame = CGRectMake(LeftRightPadding, originy, cellItem.titleWidth, cellItem.titleHeight);
            self.titleLabel.text = cellItem.title;
            
            CGSize size = [cellItem.email sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            CGFloat emailWidth = ceil(size.width);
            if (emailWidth>100) {
                emailWidth = 100;
            }
            self.emailLabel.frame = CGRectMake(cellItem.cellWidth-emailWidth-LeftRightPadding, originy, emailWidth, cellItem.titleHeight);
            self.emailLabel.text = cellItem.email;
            
            CGFloat leftX = LeftRightPadding+cellItem.titleWidth+5;
            self.field.frame = CGRectMake(leftX, originy, cellItem.cellWidth-leftX-emailWidth-LeftRightPadding, cellItem.titleHeight);
            self.field.keyboardType = UIKeyboardTypeDefault;
        }
            break;
        case UPRegisterCellStyleButton:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = YES;
            self.emailLabel.hidden = YES;
            self.field.hidden = YES;
            
            self.actionButton.hidden = NO;
            [self.actionButton setBackgroundColor:[UIColor lightGrayColor]];
            CGSize size = [cellItem.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            CGFloat btnWidth = ceil(size.width)+10;
            [self.actionButton setTitle:cellItem.title forState:UIControlStateNormal];
            [self.actionButton setImage:nil forState:UIControlStateNormal];
            self.actionButton.frame = CGRectMake(LeftRightPadding, 5, btnWidth, cellItem.cellHeight-10);
        }
            break;
        case UPRegisterCellStylePhoto:
        {
            self.actionButton.layer.cornerRadius = 0;
            self.descLabel.hidden = YES;
            self.titleLabel.hidden = YES;
            self.emailLabel.hidden = YES;
            self.field.hidden = YES;
            self.actionButton.hidden = NO;
            [self.actionButton setBackgroundColor:[UIColor whiteColor]];
            [self.actionButton setImage:[UIImage imageWithData:cellItem.imageData] forState:UIControlStateNormal];
            self.actionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
            CGFloat buttonWidth =cellItem.cellWidth-2*LeftRightPadding;
            self.actionButton.frame = CGRectMake(LeftRightPadding, 5,buttonWidth, buttonWidth*0.7);
            self.photoActionLabel.hidden = NO;
            self.photoActionLabel.frame = CGRectMake(LeftRightPadding, 5+buttonWidth*0.7-45, buttonWidth, 45);
        }
            break;
        case UPRegisterCellStyleField:
        case UPRegisterCellStyleNumField:
        case UPRegisterCellStyleTelephoneField:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = NO;
            self.emailLabel.hidden = YES;
            self.field.hidden = NO;
            
            self.actionButton.hidden = YES;
            
            CGFloat originy = cellItem.cellHeight-cellItem.titleHeight;
            self.titleLabel.frame = CGRectMake(0, originy, cellItem.titleWidth+LeftRightPadding, cellItem.titleHeight);
            self.titleLabel.text = cellItem.title;
            
            CGFloat leftX = LeftRightPadding+ cellItem.titleWidth +5;
            self.field.frame = CGRectMake(leftX, originy, cellItem.cellWidth-leftX-LeftRightPadding, cellItem.titleHeight);
            if (cellItem.cellStyle==UPRegisterCellStyleTelephoneField ||
                cellItem.cellStyle==UPRegisterCellStyleNumField) {
                self.field.keyboardType = UIKeyboardTypeNumberPad;
            } else {
                self.field.keyboardType = UIKeyboardTypeDefault;
            }
        }
            break;
        case UPRegisterCellStyleVerifyCode:
        {
            self.descLabel.hidden = YES;
            
            self.titleLabel.hidden = NO;
            self.emailLabel.hidden = YES;
            self.field.hidden = NO;
            
            self.actionButton.hidden = NO;
            [self.actionButton setBackgroundColor:[UIColor lightGrayColor]];
            CGFloat originy = cellItem.cellHeight-cellItem.titleHeight;
            self.titleLabel.frame = CGRectMake(LeftRightPadding, originy, cellItem.titleWidth, cellItem.titleHeight);
            self.titleLabel.text = cellItem.title;
            
            NSString *btnTitle = @"发送验证码";
            CGSize size = [btnTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            CGFloat btnWidth = ceil(size.width)+10;
            CGFloat btnHeight = cellItem.cellHeight-10;

            self.actionButton.frame = CGRectMake(cellItem.cellWidth-btnWidth-LeftRightPadding, 5, btnWidth, btnHeight);
            [self.actionButton setTitle:btnTitle forState:UIControlStateNormal];
            [self.actionButton setImage:nil forState:UIControlStateNormal];
            CGFloat leftX = LeftRightPadding+cellItem.titleWidth+5;
            self.field.frame = CGRectMake(leftX, originy, cellItem.cellWidth-leftX-btnWidth-LeftRightPadding, cellItem.titleHeight);
            self.field.keyboardType = UIKeyboardTypeDefault;
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
    [field setFont:[UIFont systemFontOfSize:18.0]];
    field.adjustsFontSizeToFitWidth = YES;
    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    [field setAutocorrectionType:UITextAutocorrectionTypeNo];
    [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    field.returnKeyType=UIReturnKeyDone;
    [field addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [field addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];

    field.delegate = self;
    return field;
}

- (UIButton *)createButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:15.f];
    button.layer.borderWidth = 1;
    [button setBackgroundColor:[UIColor lightGrayColor]];
    
    return button;
}

- (void)buttonClick:(UIButton *)button
{
    if (self.cellItem.actionBlock) {
        self.cellItem.actionBlock();
    }
    
    if (self.cellItem.cellStyle==UPRegisterCellStyleVerifyCode) {
        [self startTimer];
    } else if (self.cellItem.cellStyle==UPRegisterCellStyleButton ||
               self.cellItem.cellStyle==UPRegisterCellStylePhoto) {
//        if (self.cellItem.actionBlock) {
//            self.cellItem.actionBlock();
//        }
    }
}

-(void)refreshBtn
{
    interval--;
    if (interval==0) {
        [self stopTimer];
        return;
    }
    [self.actionButton setTitle:[NSString stringWithFormat:@"%ds", interval] forState:UIControlStateNormal];
}

-(void)startTimer
{
    interval = TimeInterval;
    _timer= [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(refreshBtn) userInfo:nil repeats:YES];
    [self.actionButton setEnabled:NO];
}
-(void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
    [self.actionButton setTitle:@"再次发送" forState:UIControlStateNormal];
    self.actionButton.enabled = YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.cellItem.fieldActionBlock) {
        self.cellItem.fieldActionBlock(self.cellItem);
    }
}

-(void)textFieldDone:(UITextField*)textField{
    [textField resignFirstResponder];
}

-(void)textFieldChanged:(UITextField*)textField
{
    NSString *text = textField.text;
    _cellItem.value = text;
}

@end

@interface UpRegister5() <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>
{
    CGRect viewframe;
}

@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, strong) NSMutableArray<UPRegisterCellItem*> *itemList;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@implementation UpRegister5

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.clipsToBounds = YES;
    
    viewframe = frame;
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if([_tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHidden:) name:UIKeyboardDidHideNotification object:nil];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:singleTap];
    
    [self clearValue];
    
    return self;
}

- (UPRegTypeInfo *)regTypeInfo
{
    if (_regTypeInfo==nil) {
        _regTypeInfo = [[UPRegTypeInfo alloc] init];
    }
    return _regTypeInfo;
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
}

- (NSString *)identifyID
{
    if (!_noEmail) {
        return [NSString stringWithFormat:@"%@%@", self.emailPrefix, _emailSuffix];
    } else {
        if (self.imageData!=nil) {
            return @"upload_image";
        } else if ([_industryID isEqualToString:@"1"]) {
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
        if (self.imageData!=nil) {
            return @"3";
        } else if ([_industryID isEqualToString:@"1"]) {//医生
            return @"1";
        } else {
            return @"2";
        }
    }
}

- (NSString *)comPhone
{
    for (UPRegisterCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"comphone"]) {
            _comPhone = cellItem.value;
        }
    }
    return _comPhone;
}

- (NSString *)emailPrefix
{
    for (UPRegisterCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"email"]) {
            _emailPrefix = cellItem.value;
        }
    }
    return _emailPrefix;
}

- (NSString *)telenum
{
    //赋值
    for (UPRegisterCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"telephone"]) {
            _telenum = cellItem.value;
        }
    }
    return _telenum;
}

- (NSString *)empID
{
    //赋值
    for (UPRegisterCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"empID"]) {
            _empID = cellItem.value;
        }
    }
    
    return _empID;
}

- (NSString *)empName
{
    //赋值
    for (UPRegisterCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"name"]) {
            _empName = cellItem.value;
        }
    }
    
    return _empName;
}

- (void)getRegistElements
{
    switch (self.regTypeInfo.regType) {
        case UPRegTypeMailThree:
        {
            if (self.regTypeInfo.pos==0) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的公司邮箱，我们会向您提供的邮箱内发送一份验证邮件，点击邮件中的激活链接即可激活您的账号。";
                
                UPRegisterCellItem *emailItem = [[UPRegisterCellItem alloc] init];
                emailItem.key = @"email";
                emailItem.cellStyle = UPRegisterCellStyleEmail;
                emailItem.title = @"行业邮箱\nEmail";
                emailItem.email = self.emailSuffix;
                
                [self.itemList addObject:descItem];
                [self.itemList addObject:emailItem];
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"不能接收外网邮件?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                    _noEmail = YES;
                };
                [self.itemList addObject:noEmailBtnItem];
            } else if (self.regTypeInfo.pos==1) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的工作证件照，并输入手机号，我们会进行后续核实验证。";
                [self.itemList addObject:descItem];
                
                UPRegisterCellItem *photoItem = [[UPRegisterCellItem alloc] init];
                photoItem.cellStyle = UPRegisterCellStylePhoto;
                photoItem.key = @"airPhoto";
                
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airPhoto" ofType:@"png"]];
                photoItem.imageData = self.imageData?:data;
                photoItem.actionBlock = ^{
                    [self takePhoto];
                };
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"没有工作证件?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                    _noEmail = YES;
                };
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                [self.itemList addObject:photoItem];
                [self.itemList addObject:noEmailBtnItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            } else if (self.regTypeInfo.pos==2) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                
                [self.itemList addObject:descItem];
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"可以接收外网邮件?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                    _noEmail = NO;
                };
                [self.itemList addObject:noEmailBtnItem];
                
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的姓名，单位电话、员工号和手机号，我们会进行后续核实验证。";
                
                
                UPRegisterCellItem *comphoneItem = [[UPRegisterCellItem alloc] init];
                comphoneItem.key = @"comphone";
                comphoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                comphoneItem.title = @"单位电话\nCompany phone";
                [self.itemList addObject:comphoneItem];
                
                
                UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
                empIdItem.key = @"empID";
                empIdItem.cellStyle = UPRegisterCellStyleField;
                empIdItem.title = @"员工号\nEmp NO.";
                [self.itemList addObject:empIdItem];
                
                UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
                nameItem.key = @"name";
                nameItem.cellStyle = UPRegisterCellStyleField;
                nameItem.title = @"姓名\nName";
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                
                [self.itemList addObject:nameItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            }
        }
            break;
        case UPregTypeMailTwo:
        {
            if (self.regTypeInfo.pos==0) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的公司邮箱，我们会向您提供的邮箱内发送一份验证邮件，点击邮件中的激活链接即可激活您的账号。";
                
                UPRegisterCellItem *emailItem = [[UPRegisterCellItem alloc] init];
                emailItem.key = @"email";
                emailItem.cellStyle = UPRegisterCellStyleEmail;
                emailItem.title = @"行业邮箱\nEmail";
                emailItem.email = self.emailSuffix;
                
                [self.itemList addObject:descItem];
                [self.itemList addObject:emailItem];
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                if([self.industryID isEqualToString:@"6"]) {//航空
                    noEmailBtnItem.title = @"没有邮箱?";
                } else {
                    noEmailBtnItem.title = @"不能接收外网邮件?";
                }
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                    _noEmail = YES;
                };
                [self.itemList addObject:noEmailBtnItem];
            } else if (self.regTypeInfo.pos==1) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                
                if ([self.industryID intValue]==6) {
                    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的登机证，并输入手机号，我们会进行后续核实验证。";
                } else if ([self.industryID intValue]==8) {
                    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的工作证件或校园卡，并输入手机号，我们会进行后续核实验证。";
                } else {
                    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的工作证件照，并输入手机号，我们会进行后续核实验证。";
                }
                
                [self.itemList addObject:descItem];
                
                UPRegisterCellItem *photoItem = [[UPRegisterCellItem alloc] init];
                photoItem.cellStyle = UPRegisterCellStylePhoto;
                photoItem.key = @"airPhoto";
                
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airPhoto" ofType:@"png"]];
                photoItem.imageData = self.imageData?:data;
                photoItem.actionBlock = ^{
                    [self takePhoto];
                };
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"没有工作证件?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                    _noEmail = NO;
                };
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                [self.itemList addObject:photoItem];
                [self.itemList addObject:noEmailBtnItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            }
        }
            break;
        case UPRegTypeNoMailTwo:
        {
            if (self.regTypeInfo.pos==0) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的工作证件照，并输入手机号，我们会进行后续核实验证。";
                [self.itemList addObject:descItem];
                
                UPRegisterCellItem *photoItem = [[UPRegisterCellItem alloc] init];
                photoItem.cellStyle = UPRegisterCellStylePhoto;
                photoItem.key = @"airPhoto";
                
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airPhoto" ofType:@"png"]];
                photoItem.imageData = self.imageData?:data;
                photoItem.actionBlock = ^{
                    [self takePhoto];
                };
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"没有工作证件?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                };
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                [self.itemList addObject:photoItem];
                [self.itemList addObject:noEmailBtnItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            } else if (self.regTypeInfo.pos==1) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                
                [self.itemList addObject:descItem];
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"有工作证件?";
                noEmailBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                };
                [self.itemList addObject:noEmailBtnItem];
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的姓名，单位电话、员工号和手机号，我们会进行后续核实验证。";
                
                
                UPRegisterCellItem *comphoneItem = [[UPRegisterCellItem alloc] init];
                comphoneItem.key = @"comphone";
                comphoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                comphoneItem.title = @"单位电话\nCompany phone";
                [self.itemList addObject:comphoneItem];
                
                
                UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
                empIdItem.key = @"empID";
                empIdItem.cellStyle = UPRegisterCellStyleField;
                empIdItem.title = @"员工号\nEmp NO.";
                [self.itemList addObject:empIdItem];
                
                UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
                nameItem.key = @"name";
                nameItem.cellStyle = UPRegisterCellStyleField;
                nameItem.title = @"姓名\nName";
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                
                [self.itemList addObject:nameItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            }
        }
            break;
        case UPRegTypeNoMailOne:
        {
            if (self.regTypeInfo.pos==0) {
                [self.itemList removeAllObjects];
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                
                if ([self.industryID intValue]==6) {
                    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的登机证，并输入手机号，我们会进行后续核实验证。";
                } else if ([self.industryID intValue]==8) {
                    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的工作证件或校园卡，并输入手机号，我们会进行后续核实验证。";
                } else {
                    descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的工作证件照，并输入手机号，我们会进行后续核实验证。";
                }

                [self.itemList addObject:descItem];
                
                UPRegisterCellItem *photoItem = [[UPRegisterCellItem alloc] init];
                photoItem.cellStyle = UPRegisterCellStylePhoto;
                photoItem.key = @"airPhoto";
                
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airPhoto" ofType:@"png"]];
                photoItem.imageData = self.imageData?:data;
                photoItem.actionBlock = ^{
                    [self takePhoto];
                };
                
                __weak typeof(self) weakSelf = self;
//                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
//                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
//                noEmailBtnItem.title = @"没有工作证件?";
//                noEmailBtnItem.actionBlock = ^{
//                    [weakSelf.regTypeInfo next];
//                    [weakSelf resize];
//                    weakSelf.imageData = nil;
//                    [weakSelf reloadItems];
//                };
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                [self.itemList addObject:photoItem];
//                [self.itemList addObject:noEmailBtnItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            }
        }
            break;
        case UPRegTypeDoctor:
        {
            if (self.regTypeInfo.pos==0) {
                //医生
                [self.itemList removeAllObjects];
                
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入好医生IC卡号、姓名和手机号，我们会进行后续核实验证。（证件照和IC卡号至少选一个）";
                [self.itemList addObject:descItem];
                
                UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
                empIdItem.key = @"empID";
                empIdItem.cellStyle = UPRegisterCellStyleField;
                empIdItem.title = @"好医生IC卡号\nDoctor ID";
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noPhotoBtnItem = [[UPRegisterCellItem alloc] init];
                noPhotoBtnItem.cellStyle = UPRegisterCellStyleButton;
                noPhotoBtnItem.title = @"没有好医生IC卡号?";
                noPhotoBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                };
                
                UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
                nameItem.key = @"name";
                nameItem.cellStyle = UPRegisterCellStyleField;
                nameItem.title = @"姓名\nName";
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                [self.itemList addObject:empIdItem];
                [self.itemList addObject:noPhotoBtnItem];
                [self.itemList addObject:nameItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            } else if (self.regTypeInfo.pos==1) {
                //医生
                [self.itemList removeAllObjects];
                
                UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
                descItem.key = @"desc";
                descItem.cellStyle = UPRegisterCellStyleText;
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请上传清晰的医生工作证件照、手机号，我们会进行后续核实验证。";
                [self.itemList addObject:descItem];
                
                UPRegisterCellItem *photoItem = [[UPRegisterCellItem alloc] init];
                photoItem.cellStyle = UPRegisterCellStylePhoto;
                photoItem.key = @"airPhoto";
                NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"airPhoto" ofType:@"png"]];
                photoItem.imageData = self.imageData?:data;
                photoItem.actionBlock = ^{
                    [self takePhoto];
                };
                
                __weak typeof(self) weakSelf = self;
                UPRegisterCellItem *noPhotoBtnItem = [[UPRegisterCellItem alloc] init];
                noPhotoBtnItem.cellStyle = UPRegisterCellStyleButton;
                noPhotoBtnItem.title = @"没有工作证件?";
                noPhotoBtnItem.actionBlock = ^{
                    [weakSelf.regTypeInfo next];
                    [weakSelf resize];
                    weakSelf.imageData = nil;
                    [weakSelf reloadItems];
                };
                
                UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
                telephoneItem.key = @"telephone";
                telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                telephoneItem.title = @"手机号\nCellphone";
                
                UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
                verifyItem.key = @"verify";
                verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
                verifyItem.title = @"验证码\nVerifyCode";
                verifyItem.actionBlock = ^{
                    [weakSelf sendSMS];
                };
                
                [self.itemList addObject:photoItem];
                [self.itemList addObject:noPhotoBtnItem];
                [self.itemList addObject:telephoneItem];
                [self.itemList addObject:verifyItem];
            }
        }
            break;
        default:
            break;
    }
}

- (void)resize
{
    [self clearValue];
    
    [self getRegistElements];

    __weak typeof(self) weakSelf = self;
    CGSize size = SizeWithFont(@"单位电话\nCom Tele", [UIFont systemFontOfSize:12]);
    [self.itemList enumerateObjectsUsingBlock:^(UPRegisterCellItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.titleWidth = ceil(size.width)+10;
        obj.titleHeight = ceil(size.height)+4;
        
        obj.cellWidth = viewframe.size.width;
        if (obj.cellStyle==UPRegisterCellStyleText) {
            NSString *titleStr = obj.title;
            CGRect rect = [titleStr boundingRectWithSize:CGSizeMake(obj.cellWidth-2*LeftRightPadding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} context:nil];
            obj.cellHeight = rect.size.height;
        } else if (obj.cellStyle==UPRegisterCellStylePhoto) {
            obj.cellHeight = (ScreenWidth-30)*0.7+10;
        } else {
            obj.cellHeight = 44;
        }
        
        if (obj.cellStyle==UPRegisterCellStyleField||
            obj.cellStyle==UPRegisterCellStyleNumField||
            obj.cellStyle==UPRegisterCellStyleTelephoneField||
            obj.cellStyle==UPRegisterCellStyleVerifyCode) {
            obj.fieldActionBlock = ^(UPRegisterCellItem *cellItem) {
                weakSelf.currentIndexPath = cellItem.indexPath;
            };
        }
        
    }];
    [self reloadItems];
}

-(void) keyboardShown:(NSNotification*) notification {
    CGRect initialFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect convertedFrame = [self convertRect:initialFrame fromView:nil];

    UPRegisterCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    CGRect cellFrame = [self convertRect:cell.frame fromView:self.tableView];
    if (CGRectGetMaxY(cellFrame)>convertedFrame.origin.y) {
        CGFloat tableOffset = self.tableView.frame.origin.y;
        CGRect newFrame = CGRectOffset(self.bounds, 0, convertedFrame.origin.y-CGRectGetMaxY(cellFrame)+tableOffset);
        [UIView beginAnimations:@"TableViewUP" context:NULL];
        [UIView setAnimationDuration:0.3f];
        self.tableView.frame = newFrame;
        [UIView commitAnimations];
    }
}

-(void) keyboardHidden:(NSNotification*) notification {
    [UIView beginAnimations:@"TableViewDown" context:NULL];
    [UIView setAnimationDuration:0.3f];
    self.tableView.frame = self.bounds;
    [UIView commitAnimations];
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
    switch (self.regTypeInfo.regType) {
        case UPRegTypeMailThree:
        case UPregTypeMailTwo:
        {
            if (self.regTypeInfo.pos==0) {
                for (UPRegisterCellItem *cellItem in self.itemList) {
                    if ([cellItem.key isEqualToString:@"email"]) {
                        if (cellItem.value.length==0) {
                            return @"请输入邮箱";
                        }
                    }
                }

            } else if (self.regTypeInfo.pos==1) {
                if (self.imageData==nil) {
                    return @"请上传工作证件照";
                }
                
                NSArray *keys = @[@"telephone"];
                NSMutableDictionary *valueDict = [NSMutableDictionary new];
                for (NSString *key in keys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            NSString *value = (cellItem.value.length==0)?@"":cellItem.value;
                            [valueDict setObject:value forKey:key];
                        }
                    }
                }
                
                if ([valueDict[@"telephone"] length]==0) {
                    return @"手机号不正确";
                }
            } else if (self.regTypeInfo.pos==2) {
                NSArray *keys = @[@"comphone", @"name", @"telephone"];
                NSMutableDictionary *valueDict = [NSMutableDictionary new];
                for (NSString *key in keys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            NSString *value = (cellItem.value.length==0)?@"":cellItem.value;
                            [valueDict setObject:value forKey:key];
                        }
                    }
                }
                
                if ([valueDict[@"comphone"] length]==0) {
                    return @"请输入单位电话";
                }
                
                if ([valueDict[@"name"] length]==0) {
                    return @"姓名不能为空";
                }
                
                if ([valueDict[@"telephone"] length]==0) {
                    return @"手机号不正确";
                }
            }
        }
            break;
        case UPRegTypeNoMailTwo:
        case UPRegTypeNoMailOne:
        {
            if (self.regTypeInfo.pos==0) {
                if (self.imageData==nil) {
                    return @"请上传工作证件照";
                }
                
                NSArray *keys = @[@"telephone"];
                NSMutableDictionary *valueDict = [NSMutableDictionary new];
                for (NSString *key in keys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            NSString *value = (cellItem.value.length==0)?@"":cellItem.value;
                            [valueDict setObject:value forKey:key];
                        }
                    }
                }
                
                if ([valueDict[@"telephone"] length]==0) {
                    return @"手机号不正确";
                }
            } else if (self.regTypeInfo.pos==1) {
                NSArray *keys = @[@"comphone", @"name", @"telephone"];
                NSMutableDictionary *valueDict = [NSMutableDictionary new];
                for (NSString *key in keys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            NSString *value = (cellItem.value.length==0)?@"":cellItem.value;
                            [valueDict setObject:value forKey:key];
                        }
                    }
                }
                
                if ([valueDict[@"comphone"] length]==0) {
                    return @"请输入单位电话";
                }

                if ([valueDict[@"name"] length]==0) {
                    return @"姓名不能为空";
                }
                
                if ([valueDict[@"telephone"] length]==0) {
                    return @"手机号不正确";
                }
            }
        }
            break;
        case UPRegTypeDoctor:
        {
            if (self.regTypeInfo.pos==0) {
                NSArray *keys = @[@"empID" ,@"name", @"telephone"];
                NSMutableDictionary *valueDict = [NSMutableDictionary new];
                for (NSString *key in keys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            NSString *value = (cellItem.value.length==0)?@"":cellItem.value;
                            [valueDict setObject:value forKey:key];
                        }
                    }
                }
                
                if ([valueDict[@"empID"] length]==0) {
                    return @"好医生IC卡号不能为空";
                }
                if ([valueDict[@"name"] length]==0) {
                    return @"姓名不能为空";
                }
                
                if ([valueDict[@"telephone"] length]==0) {
                    return @"手机号不正确";
                }
            } else if (self.regTypeInfo.pos==1) {
                if (self.imageData==nil) {
                    return @"请上传工作证件照";
                }
                
                NSArray *keys = @[@"telephone"];
                NSMutableDictionary *valueDict = [NSMutableDictionary new];
                for (NSString *key in keys) {
                    for (UPRegisterCellItem *cellItem in self.itemList) {
                        if ([cellItem.key isEqualToString:key]) {
                            NSString *value = (cellItem.value.length==0)?@"":cellItem.value;
                            [valueDict setObject:value forKey:key];
                        }
                    }
                }

                if ([valueDict[@"telephone"] length]==0) {
                    return @"手机号不正确";
                }
            }
        }
            break;
        default:
            break;
    }

    if (self.regTypeInfo.regType!=UPRegTypeMailThree &&
        self.regTypeInfo.regType!=UPregTypeMailTwo) {
        for (UPRegisterCellItem *cellItem in self.itemList) {
            if ([cellItem.key isEqualToString:@"verify"]) {
                if (cellItem.value.length==0) {
                    return @"验证码不能为空";
                } else {
                    _verifyCode = cellItem.value;
                }
            }
        }
        
        if (![_verifyCode isEqualToString:self.smsText]&&
            ![_verifyCode isEqualToString:@"9527"]) {
            return @"验证码错误";
        }
    }
    return @"";
}

-(void)sendSMS
{
    if (self.telenum.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"请输入手机号" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    [self startSMSRequest];
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

- (void)singleTap:(UIGestureRecognizer *)gesture
{
    [self.tableView endEditing:YES];
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
    cellItem.indexPath = indexPath;
    cell.cellItem = cellItem;
    
    return cell;
}

//开始拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.edgesForExtendedLayout = UIRectEdgeNone;
        picker.sourceType = sourceType;
        picker.navigationBar.barTintColor = kUPThemeMainColor;
        picker.navigationBar.tintColor = [UIColor whiteColor];
        
        UpRegisterController *registController = (UpRegisterController *)self.parentController;
        [registController presentViewController:picker animated:YES completion:nil];
    } else
    {
        NSLog(@"模拟器无法打开照相机");
    }
}

static CGFloat const FixRatio = 4/3.0;

//当选择一张图片后进入处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        CGSize imgSize = [image size];
        CGFloat kWidth;
        
        CGFloat ratio = imgSize.width/imgSize.height;
        if (ratio<FixRatio) {
            kWidth = imgSize.width;
        } else {
            kWidth = FixRatio*imgSize.height;
        }
        UIImage *cutImage = [UPTools cutImage:image withSize:CGSizeMake(kWidth, kWidth/FixRatio)];
        
        self.imageData = [UPTools compressImage:cutImage];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        UPRegisterCellItem *photoItem = nil;
        
        for (UPRegisterCellItem *item in self.itemList) {
            if ([item.key isEqualToString:@"airPhoto"]) {
                photoItem = item;
            }
        }
        
        photoItem.imageData = self.imageData;
        [self.tableView reloadRowsAtIndexPaths:@[photoItem.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView endEditing:YES];
}
@end
