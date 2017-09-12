//
//  UpRegister5.h
//  Upper_1
//
//  Created by aries365.com on 16/1/15.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpRegisterController.h"
#import "UPRegisterView.h"

typedef NS_ENUM(NSInteger, UPRegisterCellStyle)
{
    UPRegisterCellStyleText,    //纯文本
    UPRegisterCellStyleField,   //文本框
    UPRegisterCellStyleNumField,
    UPRegisterCellStyleTelephoneField,
    UPRegisterCellStyleVerifyCode, //验证码
    UPRegisterCellStyleEmail,   //邮件
    UPRegisterCellStyleRadio,   //Radio
    UPRegisterCellStyleButton
};

typedef void (^CellActionBlock) ();

@interface UPRegisterCellItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *cellId;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *value;
@property (nonatomic) UPRegisterCellStyle cellStyle;
@property (nonatomic) CellActionBlock actionBlock;

@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat cellWidth;

@end

@interface UPRegisterCell : UITableViewCell

@property (nonatomic, strong) UPRegisterCellItem *cellItem;

@end

@interface UpRegister5 : UPRegisterView <UITextFieldDelegate>

@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, copy) NSString *emailPrefix;
@property (nonatomic, copy) NSString *emailSuffix;

@property (nonatomic, retain) UILabel *suffixLabel;
@property (nonatomic) BOOL noEmail;
@property (nonatomic) NSString *industryID;

@property (nonatomic, copy) NSString *comPhone;
@property (nonatomic, copy) NSString *empName;
@property (nonatomic, copy) NSString *empID;
@property (nonatomic, copy) NSString *telenum;
@property (nonatomic, copy) NSString *smsText;

- (NSString *)identifyID;
- (NSString *)identifyType;
- (void)resize;
- (void)reloadItems;
-(void)stopTimer;
- (void)startSMSRequest;
@end
