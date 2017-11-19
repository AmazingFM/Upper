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

typedef NS_ENUM(NSInteger, UPRegType)
{
    UPRegTypeMailThree,
    UPregTypeMailTwo,
    UPRegTypeNoMailTwo,
    UPRegTypeNoMailOne,
    UPRegTypeDoctor,
    UPRegTypeNone
};

@interface UPRegTypeInfo : NSObject

@property (nonatomic) UPRegType regType;
@property (nonatomic) int pos;

- (void)next;

@end

typedef NS_ENUM(NSInteger, UPRegisterCellStyle)
{
    UPRegisterCellStyleText,    //纯文本
    UPRegisterCellStyleField,   //文本框
    UPRegisterCellStyleNumField,
    UPRegisterCellStyleTelephoneField,
    UPRegisterCellStyleVerifyCode, //验证码
    UPRegisterCellStyleEmail,   //邮件
    UPRegisterCellStyleRadio,   //Radio
    UPRegisterCellStyleButton,
    UPRegisterCellStylePhoto,//拍照
};

@class UPRegisterCellItem;
typedef void (^CellBtnActionBlock) ();
typedef void (^CellFieldActionBlock) (UPRegisterCellItem *cellItem);

@interface UPRegisterCellItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *cellId;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;
@property (nonatomic) UPRegisterCellStyle cellStyle;
@property (nonatomic) CellBtnActionBlock actionBlock;
@property (nonatomic) CellFieldActionBlock fieldActionBlock;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property (nonatomic) CGFloat cellHeight;
@property (nonatomic) CGFloat cellWidth;

@property (nonatomic) CGFloat titleWidth;
@property (nonatomic) CGFloat titleHeight;

@end

@interface UPRegisterCell : UITableViewCell

@property (nonatomic, strong) UPRegisterCellItem *cellItem;

@end

@interface UpRegister5 : UPRegisterView <UITextFieldDelegate>

@property (nonatomic, strong) NSData *imageData;

@property (nonatomic, copy) NSString *emailPrefix;
@property (nonatomic, copy) NSString *emailSuffix;
@property (nonatomic) BOOL noEmail;
@property (nonatomic, strong) UPRegTypeInfo *regTypeInfo;

@property (nonatomic) NSString *industryID;
@property (nonatomic) NSString *companyID;//公司id

@property (nonatomic, copy) NSString *comPhone;
@property (nonatomic, copy) NSString *empName;
@property (nonatomic, copy) NSString *empID;
@property (nonatomic, copy) NSString *telenum;
@property (nonatomic, copy) NSString *smsText;

- (NSString *)identifyID;
- (NSString *)identifyType;
- (void)resize;
- (void)reloadItems;
- (void)startSMSRequest;
@end
