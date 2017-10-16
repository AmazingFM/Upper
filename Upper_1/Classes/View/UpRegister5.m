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
    self.field.text = @"";
    
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
            
            CGSize size = [cellItem.title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            CGFloat btnWidth = ceil(size.width)+10;
            [self.actionButton setTitle:cellItem.title forState:UIControlStateNormal];
            self.actionButton.frame = CGRectMake(LeftRightPadding, 5, btnWidth, cellItem.cellHeight-10);
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
            
            CGFloat originy = cellItem.cellHeight-cellItem.titleHeight;
            self.titleLabel.frame = CGRectMake(LeftRightPadding, originy, cellItem.titleWidth, cellItem.titleHeight);
            self.titleLabel.text = cellItem.title;
            
            NSString *btnTitle = @"发送验证码";
            CGSize size = [btnTitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
            CGFloat btnWidth = ceil(size.width)+10;
            CGFloat btnHeight = cellItem.cellHeight-10;

            self.actionButton.frame = CGRectMake(cellItem.cellWidth-btnWidth-LeftRightPadding, 5, btnWidth, btnHeight);
            [self.actionButton setTitle:btnTitle forState:UIControlStateNormal];
            
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
    button.layer.cornerRadius = 5.0f;
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
    } else {
        [self stopTimer];
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

@interface UpRegister5() <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
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
        if ([_industryID isEqualToString:@"1"]) {
            return [NSString stringWithFormat:@"%@", self.empID];
        } else {

            if ([_industryID intValue]==6) {//[_industryID isEqualToString:@"6"]，航空业属于特殊情况，没有单位电话，使用公司id加工号
                return [NSString stringWithFormat:@"%@|%@", self.companyID, self.empID];
            } else {
                return [NSString stringWithFormat:@"%@|%@", self.comPhone, self.empID];
            }
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

- (void)resize
{
    [self clearValue];
    
    if (_noEmail) {
        if ([self.industryID isEqualToString:@"1"]) {//医生
            [self.itemList removeAllObjects];
            
            UPRegisterCellItem *descItem = [[UPRegisterCellItem alloc] init];
            descItem.key = @"desc";
            descItem.cellStyle = UPRegisterCellStyleText;
            descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的姓名、好医生IC卡号和手机号，我们会进行后续核实验证。";
            
            UPRegisterCellItem *empIdItem = [[UPRegisterCellItem alloc] init];
            empIdItem.key = @"empID";
            empIdItem.cellStyle = UPRegisterCellStyleField;
            empIdItem.title = @"好医生IC卡号\nDoctor ID";
            
            UPRegisterCellItem *nameItem = [[UPRegisterCellItem alloc] init];
            nameItem.key = @"name";
            nameItem.cellStyle = UPRegisterCellStyleField;
            nameItem.title = @"姓名\nName";
            
            UPRegisterCellItem *telephoneItem = [[UPRegisterCellItem alloc] init];
            telephoneItem.key = @"telephone";
            telephoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
            telephoneItem.title = @"手机号\nCellphone";
            __weak typeof(self) weakSelf = self;
            
            UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
            verifyItem.key = @"verify";
            verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
            verifyItem.title = @"验证码\nVerifyCode";
            verifyItem.actionBlock = ^{
                [weakSelf sendSMS];
            };

            
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
            
            [self.itemList addObject:descItem];
            
            __weak typeof(self) weakSelf = self;
            if([self.industryID isEqualToString:@"6"]) {//航空
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的员工号和姓名，我们会进行后续核实验证。";
                UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
                noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
                noEmailBtnItem.title = @"有公司邮箱?";
                noEmailBtnItem.actionBlock = ^{
                    weakSelf.noEmail = NO;
                    [weakSelf resize];
                    [weakSelf reloadItems];
                };
                [self.itemList addObject:noEmailBtnItem];
            }else {
                descItem.title = @"温馨提醒:您当前账号还需要通过行业验证才能完成。请输入您的单位电话、员工号和姓名，我们会进行后续核实验证。";
                UPRegisterCellItem *comphoneItem = [[UPRegisterCellItem alloc] init];
                comphoneItem.key = @"comphone";
                comphoneItem.cellStyle = UPRegisterCellStyleTelephoneField;
                comphoneItem.title = @"单位电话\nCompany phone";
                [self.itemList addObject:comphoneItem];
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
            
            UPRegisterCellItem *verifyItem = [[UPRegisterCellItem alloc] init];
            verifyItem.key = @"verify";
            verifyItem.cellStyle = UPRegisterCellStyleVerifyCode;
            verifyItem.title = @"验证码\nVerifyCode";
            verifyItem.actionBlock = ^{
                [weakSelf sendSMS];
            };
            
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
        emailItem.email = self.emailSuffix;
        
        [self.itemList addObject:descItem];
        [self.itemList addObject:emailItem];
        
        __weak typeof(self) weakSelf = self;
        if([self.industryID isEqualToString:@"6"]) {//航空) {
            UPRegisterCellItem *noEmailBtnItem = [[UPRegisterCellItem alloc] init];
            noEmailBtnItem.cellStyle = UPRegisterCellStyleButton;
            noEmailBtnItem.title = @"没有公司邮箱?";
            noEmailBtnItem.actionBlock = ^{
                weakSelf.noEmail = YES;
                [weakSelf resize];
                [weakSelf reloadItems];
            };
            [self.itemList addObject:noEmailBtnItem];
        }
    }

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
        CGRect newFrame = CGRectOffset(self.bounds, 0, convertedFrame.origin.y-CGRectGetMaxY(cellFrame));
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
}

-(NSString *)alertMsg
{
    if (_noEmail) {
        NSMutableString *str = [[NSMutableString alloc] init];
        
        if ([self.industryID isEqualToString:@"1"]) {
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
            if ([self.industryID isEqualToString:@"6"]) {
                NSDictionary *alertMsgDict = @{@"empID":@"员工号不能为空\n", @"name":@"姓名不能为空\n", @"telephone":@"手机号不正确\n"};
                
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

//#pragma mark - UITextFieldDelegate
//- (BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    return YES;
//}

- (void)singleTap:(UIGestureRecognizer *)gesture
{
    [self.tableView endEditing:YES];
//    UPRegisterCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
//    if (cell) {
//        [cell.field resignFirstResponder];
//    }
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
@end
