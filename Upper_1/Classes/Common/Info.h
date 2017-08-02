//
//  Info.h
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#ifndef Upper_1_Info_h
#define Upper_1_Info_h

#define kNotifierLogin    @"kNotifierLoginIdentifier"    //登录
#define kNotifierLogout   @"kNotifierLogoutIdentifier"    //登出

#define kNotifierActCancelRefresh    @"kNotifierActCancelRefreshIdentifier"    //取消活动
#define kNotifierActQuitRefresh  @"kNotifierActQuitRefreshIdentifier"    //退出活动

#define kNotifierMessagePull    @"kNotifierMessagePull"   //从server 定时取消息
#define kNotifierMessageSending @"kNotifierMessageSending"    //取到消息后，对chatcontroller内容进行更新
#define kNotifierMessageComing @"kNotifierMessageComing"    //取到消息后，对chatcontroller内容进行更新

#define kUPMessageTimeMachineName     @"messageTimer"

#define kMessageRequireTimeInterval 5.0f

#ifdef UPPER_DEBUG
#define kBaseURL @"http://api.qidianzhan.com.cn/AppServ/index.php"
#else
#define kBaseURL @"http://api.uppercn.com/AppServ/index.php"
#endif

#define kShareURL @"http://share.uppercn.com"
#define kShareActivityURL @"http://a.uppercn.com"

//浅灰
#define GRAYCOLOR [UIColor colorWithRed:248/255.0 green:245/255.0 blue:246/255.0 alpha:1]
//暗红
#define REDCOLOR [UIColor colorWithRed:138/255.0 green:16/255.0 blue:16/255.0 alpha:1]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

#define isIOS7  ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

#define NAV_HEIGHT ( isIOS7 ? 64 : 44)  //导航栏高度

#define NAV_HEIGHT_NO_STATUSVIEW 44  //导航栏高度-不包含状态栏

#define NAV_START_Y (NAV_HEIGHT – NAV_HEIGHT_NO_STATUSVIEW)//导航栏绘制时的起始Y值
//第一个Label离top的距离
#define FirstLabelHeight 64

//左右边距
#define LeftRightPadding 15
//上下边距 for cell
#define TopDownPadding 1
#define CellHeightDefault 44
#define SectionHeaderHeight 15

#define kUPActReviewTag     100
#define kUPActChangeTag     101
#define kUPActCancelTag     102
#define kUPActCommentTag    103
#define kUPActQuitTag       104
#define kUPActSignTag       105
#define kUPActEditTag       106
#define kUPActComplainTag   107

//顶部菜单高度
#define selectMenuH 30

typedef NS_ENUM(NSInteger, ViewType) {
    HOME_VIEW = 0,
    UPPER_VIEW,
    ACTIVITY_VIEW, //活动大厅
    EXPERT_VIEW,
    LAUNCH_ACTIVITY_VIEW,
    MY_Friends_View,
    MY_ACTIVITY_VIEW,
    LOGIN_VIEW,
    REGISTER_VIEW,
    SETTING_VIEW,
    PERSON_CENTER_VIEW,
    ENROLL_PEOPLE_VIEW,
    ACTIVITY_DETAIL_VIEW,
    GET_PASSWORD_VIEW,
    MYACT_VIEW,
    QR_VIEW,
    QR_SCAN_VIEW,
    MESSAGE_CENTER_VIEW,
    CHAT_VIEW
};

typedef enum action
{
    LEFT_MENU_CHANGE,
    CHANGE_VIEW,
} ActionType;

@protocol ActionDelegate <NSObject>

@optional
-(void)changeView:(id)sender from:(NSInteger)from to:(NSInteger)to;

@end

#endif
