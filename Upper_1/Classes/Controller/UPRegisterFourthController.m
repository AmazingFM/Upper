//
//  UPRegisterFourthController.m
//  Upper
//
//  Created by 张永明 on 2017/10/31.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRegisterFourthController.h"
#import "UPRegisterFifthController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Info.h"
#import "DrawSomething.h"
#import "RadioButton.h"
#import "TTTAttributedLabel.h"
#import "UPTextAlertView.h"

#define BtnSpace 40
#define VERTICAL_SPACE 40
#define VerifyBtnWidth 100
#define TimeInterval 10

@interface UPRegisterFourthController ()<UITextFieldDelegate, RadioButtonDelegate,UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>
{
    UIScrollView *contentScro;
}


@property (nonatomic, retain) NSMutableArray<UITextField*> *fields;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPass;
@property (nonatomic, copy) NSString *sexType;

@property (nonatomic, retain) id<UPRegistV4Delegate> delegate;


@property (nonatomic,retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *preBtn;
@property (nonatomic,retain) UILabel *tipsLabel;
@end

@implementation UPRegisterFourthController

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
    
    NSString *tipsText = @"Step4:完善资料";
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
    
    contentScro = [[UIScrollView alloc] initWithFrame:frame];
    contentScro.showsHorizontalScrollIndicator = NO;
    contentScro.showsVerticalScrollIndicator = NO;
    contentScro.scrollEnabled = YES;
    
    
    NSString *usernameStr = @"用户名\nUsername";
    NSString *passwordStr = @"密码\nPassword";
    NSString *confirmStr = @"确认密码\nConfirm";
    NSString *sexualStr = @"性别\nSexual";
    
    size = [usernameStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    size.width = size.width+5;
    
    NSArray *labelStr = [NSArray arrayWithObjects:usernameStr,passwordStr,confirmStr,sexualStr,nil];
    
    _fields = [[NSMutableArray alloc]initWithCapacity:4];
    for (int i=0; i<labelStr.count; i++) {
        UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, i*(size.height+VERTICAL_SPACE), size.width, size.height)];
        tmpLabel.textAlignment = NSTextAlignmentRight;
        tmpLabel.numberOfLines = 0;
        tmpLabel.text = [labelStr objectAtIndex:i];
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.textColor = [UIColor whiteColor];
        tmpLabel.font = [UIFont systemFontOfSize:12];
        
        if (i==3) {
            UIView *radioBackView = [[UIView alloc] initWithFrame:CGRectMake(20+tmpLabel.size.width, tmpLabel.origin.y, frame.size.width-2*LeftRightPadding-20-tmpLabel.size.width, size.height)];
            
            RadioButton *rad1 = [RadioButton alloc];
            [rad1 setWidth:80 andHeight:size.height];
            [rad1 setText:@"男"];
            rad1 = [rad1 initWithGroupId:@"mygroup" index:0];
            rad1.frame = CGRectMake(0, 0, 100, size.height);
            
            [radioBackView addSubview:rad1];
            
            RadioButton *rad2 = [RadioButton alloc];
            [rad2 setWidth:80 andHeight:size.height];
            [rad2 setText:@"女"];
            rad2 = [rad2 initWithGroupId:@"mygroup" index:1];
            rad2.frame = CGRectMake(120, 0, 80, size.height);
            [radioBackView addSubview:rad2];
            
            [RadioButton addObserverForGroupId:@"mygroup" observer:self];
            
            [rad1 handleButtonTap:rad1];
            
            UILabel *seperatorV = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, tmpLabel.y+size.height, frame.size.width-2*LeftRightPadding, 1)];
            seperatorV.backgroundColor = [UIColor grayColor];
            
            [contentScro addSubview:radioBackView];
            
            [contentScro addSubview:tmpLabel];
            
            [contentScro addSubview:seperatorV];
            continue;
        }
        
        UITextField *tmpField = [[UITextField alloc]initWithFrame:CGRectMake(20+tmpLabel.size.width, tmpLabel.origin.y, frame.size.width-2*LeftRightPadding-20-tmpLabel.size.width, size.height)];
        tmpField.delegate = self;
        [tmpField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [tmpField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
        if( i==1 || i==2) {
            tmpField.secureTextEntry = YES;
        }
        if (i==4||i==5) {
            [tmpField setKeyboardType:UIKeyboardTypeNumberPad];
        }
        
        tmpField.delegate = self;
        tmpField.tag = 10+i;
        
        [_fields addObject:tmpField];
        
        UILabel *seperatorV = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, tmpLabel.y+size.height, frame.size.width-2*LeftRightPadding, 1)];
        seperatorV.backgroundColor = [UIColor grayColor];
        [contentScro addSubview:tmpLabel];
        [contentScro addSubview:tmpField];
        [contentScro addSubview:seperatorV];
    }
    
    TTTAttributedLabel *detailLabel = [self addTTAttributedLabel];
    CGRect rect = CGRectOffset(detailLabel.frame, 0, 4*(size.height+VERTICAL_SPACE));
    detailLabel.frame = rect;
    [contentScro addSubview:detailLabel];
    
    [contentScro setContentSize:CGSizeMake(frame.size.width, 5*(size.height+VERTICAL_SPACE)+rect.size.height)];
    [self.view addSubview:contentScro];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    [contentScro addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
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

- (TTTAttributedLabel *)addTTAttributedLabel
{
    NSString *detailStr = @"注册即表示同意《upper用户协议》";
    CGSize size = [detailStr sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(ScreenWidth-2*LeftRightPadding,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    TTTAttributedLabel *detailLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(LeftRightPadding, 0, ScreenWidth-2*LeftRightPadding, size.height)];
    detailLabel.delegate = self;
    detailLabel.font = [UIFont systemFontOfSize:15];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.backgroundColor = [UIColor clearColor];
    detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailLabel.numberOfLines = 0;
    [detailLabel setText:detailStr];
    
    UIFont *boldSystemFont = [UIFont systemFontOfSize:14];
    CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);
    //添加点击事件
    detailLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    detailLabel.delegate = self;
    detailLabel.linkAttributes = @{(NSString *)kCTFontAttributeName:(__bridge id)font,(id)kCTForegroundColorAttributeName:RGBCOLOR(33, 129, 247)};
    detailLabel.activeLinkAttributes = nil;
    NSRange range1= [detailLabel.text rangeOfString:@"《upper用户协议》"];
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

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    //在这里我多加了62，（加上了输入中文选择文字的view高度）这个依据自己需求而定
    [self beginEditing:CGRectGetMinY(frame)+62];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //输入框编辑完成以后，当键盘即将消失时，将视图恢复到原始状态
    [self endEditing];
}


-(void)beginEditing:(CGFloat)height
{
    int offset = height+contentScro.origin.y-(self.view.frame.size.height-216.0);//键盘高度216
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

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [self.fields enumerateObjectsUsingBlock:^(UITextField *obj, NSUInteger idx, BOOL *stop)
     {
         [obj resignFirstResponder];
     }];
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

#pragma UITextFieldDelegate
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


-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId
{
    NSLog(@"%lu, %@", (unsigned long)index, groupId);
    if (index==0) {
        _sexType = @"1";
    } else {
        _sexType = @"2";
    }
}

-(NSString *)username
{
    _username = ((UITextField *)[contentScro viewWithTag:10]).text;
    return _username;
}

-(NSString *)password
{
    _password = ((UITextField *)[contentScro viewWithTag:11]).text;
    return _password;
}

-(NSString *)confirmPass
{
    _confirmPass = ((UITextField *)[contentScro viewWithTag:12]).text;
    return _confirmPass;
}

-(void)navButtonClick:(UIButton *)sender
{
    if (sender.tag ==11) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (sender.tag==12) {
        
        NSMutableString *str = [[NSMutableString alloc] init];
        
        if (self.username.length==0) {
            [str appendString:@"用户名不能为空\n"];
        } else if (self.password.length==0) {
            [str appendString:@"密码不能为空\n"];
        } else if (![self.confirmPass isEqualToString:self.password]) {
            [str appendString:@"密码不一致\n"];
        }

        if (str.length>0) {
            showDefaultAlert(@"提示", str);
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
