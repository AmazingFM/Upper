//
//  UPCellItems.h
//  Upper
//
//  Created by 张永明 on 16/5/7.
//  CopyrigUP © 2016年 aries365.com. All rigUPs reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, UPItemStyle) {
    UPItemStyleActNone      =0,
    UPItemStyleActCreated   = 1<<0,     //刚刚发起活动
    UPItemStyleActBegin     = 1<<1,     //审核通过
    UPItemStyleActOK        = 1<<2,
    UPItemStyleActEnd       = 1<<3,
    UPItemStyleActJoin      = 1<<4,     //参与
    UPItemStyleActLaunch    = 1<<5,     //发起
    
    UPItemStyleInput        = 1<<6,
    UPItemStyleIndex        = 1<<7,      //索引数据   如列表，多选框等       将索引对应的值提交
    
    UPItemStyleUserImg      = 1<<11,    //用户头像
    UPItemStyleUserQrcode   = 1<<12,    //用户二维码
    UPItemStyleUserNickName = 1<<13,
    UPItemStyleUserSexual   = 1<<14,
    UPItemStyleUserBirth    = 1<<15,
    UPItemStyleUserAnonymous= 1<<16,     //单位匿名
    UPItemStyleUserIndustry = 1<<17     //行业
};

typedef enum{
    UPFieldTypeUnlimited,               //不限制
    UPFieldTypeAmount,                  //金额/价格，限数字和小数点
    UPFieldTypeNumber,                   //数字,数量，限数字
    UPFieldTypeCharater,                //数字和字母
} UPFieldType;

typedef enum{
    UPComboxTypeActionSheet,
    UPComboxTypePicker
} UPComboxType;

typedef enum{
    UPBtnStyleSubmit,
    UPBtnStyleReset,
    UPBtnStyleImage,
} UPBtnStyle;

@interface UPBaseCellItem : NSObject

@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic) float cellWidth;
@property (nonatomic) float cellHeight;
@property (nonatomic, copy) NSString *cellID;
@property(nonatomic)BOOL                more;           //有更多记录
@property (nonatomic) UPItemStyle style;
- (void)reset;
- (id)value;
- (void)fillWithValue:(NSString *)value;

@end

@interface UPTitleCellItem : UPBaseCellItem
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *iconName;
@end

@interface UPDetailCellItem : UPTitleCellItem
@property (nonatomic) UIColor *detailColor;
@property (nonatomic, copy) NSString *detail;
@end

@interface UPComboxCellItem : UPDetailCellItem
@property(nonatomic,retain)NSArray* comboxItems;
@property(nonatomic)int             selectedIndex;
@property(nonatomic)int             defaultIndex;
@property(nonatomic)UPComboxType comboxType;
-(NSArray*)comboxTitles;
-(NSString*)selectedText;
@end

@interface UPFieldCellItem : UPDetailCellItem
@property(nonatomic,copy) NSString* fieldText;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic)BOOL           secureTextEntry;
@property(nonatomic)BOOL           userInteractionDisabled;//屏蔽输入
@property(nonatomic)int            actionLen;
@property(nonatomic)UPFieldType fieldType;
@end

@interface UPOnlyFieldCellItem : UPBaseCellItem
@property(nonatomic,copy) NSString* fieldText;
@property(nonatomic, copy) NSString *placeholder;
@end

@interface UPTextCellItem : UPTitleCellItem
@property(nonatomic,copy) NSString* fieldText;
@property(nonatomic, copy) NSString *placeholder;
@property(nonatomic) BOOL           secureTextEntry;
@property(nonatomic)BOOL           userInteractionDisabled;//屏蔽输入
@property(nonatomic)int            actionLen;
@property(nonatomic)UPFieldType fieldType;
@end


@interface UPSwitchCellItem : UPDetailCellItem
@property (nonatomic) BOOL isLock;
@property (nonatomic) BOOL isOn;
@end

@interface UPImageDetailCellItem : UPTitleCellItem
@property (nonatomic, copy) NSString *defaultName;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic)       BOOL    isSwitchOn;
@end

@interface UPButtonCellItem : UPBaseCellItem
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, copy) UIImage *btnImage;
@property (nonatomic) BOOL defaultImage;
@property (nonatomic, retain) UIColor *tintColor;
@property (nonatomic) UPBtnStyle btnStyle;
@end

@interface UPDateCellItem : UPTitleCellItem
@property (nonatomic, copy) NSString *date;
@end

@interface UPInfoCellItem : UPBaseCellItem
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *detail;
@property (nonatomic, retain) NSString *tips;
@end

@interface UPCellItems : NSObject

@end
