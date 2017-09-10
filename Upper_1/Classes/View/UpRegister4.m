
//
//  UpRegister4.m
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpRegister4.h"
#import "RadioButton.h"
#import "Info.h"
#import "UPDataManager.h"
#import "XWHttpTool.h"
#import "TTTAttributedLabel.h"
#import "UPTextAlertView.h"

#define VERTICAL_SPACE 40
#define VerifyBtnWidth 100
#define TimeInterval 10

@interface UpRegister4() <UITextFieldDelegate,UIGestureRecognizerDelegate, TTTAttributedLabelDelegate>
{
    UIScrollView *contentScro;
}


@end
@implementation UpRegister4 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    contentScro = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    contentScro.showsHorizontalScrollIndicator = NO;
    contentScro.showsVerticalScrollIndicator = NO;
    contentScro.scrollEnabled = YES;
    
    
    NSString *usernameStr = @"用户名\nUsername";
    NSString *passwordStr = @"密码\nPassword";
    NSString *confirmStr = @"确认密码\nConfirm";
    NSString *sexualStr = @"性别\nSexual";
    
    CGSize size = [usernameStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    size.width = size.width+5;
    
    NSArray *labelStr = [NSArray arrayWithObjects:usernameStr,passwordStr,confirmStr,sexualStr,nil];
    
    _fields = [[NSMutableArray alloc]initWithCapacity:5];
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
    [self addSubview:contentScro];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleTap];
    [contentScro addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;

    return self;
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
    if ([self.delegate respondsToSelector:@selector(beginEditing:)]) {
        //在这里我多加了62，（加上了输入中文选择文字的view高度）这个依据自己需求而定
        [self.delegate beginEditing:frame.origin.y+62];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    //输入框编辑完成以后，当键盘即将消失时，将视图恢复到原始状态
    if ([self.delegate respondsToSelector:@selector(endEditing)]) {
        [self.delegate endEditing];
    }
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

-(void)clearValue
{

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

-(NSString *)alertMsg
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    if (self.username.length==0) {
        [str appendString:@"用户名不能为空\n"];
        return str;
    }
    
    if (self.password.length==0) {
        [str appendString:@"密码不能为空\n"];
        return str;
    }
    if (![self.confirmPass isEqualToString:self.password]) {
        [str appendString:@"密码不一致\n"];
        return str;
    }
    
    return @"";
}
@end
