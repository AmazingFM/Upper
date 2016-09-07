//
//  Info.h
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#ifndef Upper_1_Info_h
#define Upper_1_Info_h

//#define kHugeFont      [UIFont systemFontOfSize:26]
//#define kBigBigFont    [UIFont systemFontOfSize:22]
//#define kBigFont       [UIFont systemFontOfSize:20]
//#define kMiddleFont    [UIFont systemFontOfSize:16]
//#define kNomalFont     [UIFont systemFontOfSize:14]
//#define kSmallFont     [UIFont systemFontOfSize:10]
//#define kMinFont       [UIFont systemFontOfSize:8]


#define kNotifierLogin    @"kNotifierLoginIdentifier"    //登录
#define kNotifierLogout   @"kNotifierLogoutIdentifier"    //登出

#define kNotifierMessagePull    @"kNotifierMessagePull"   //从server 定时取消息
#define kNotifierMessageSending @"kNotifierMessageSending"    //取到消息后，对chatcontroller内容进行更新
#define kNotifierMessageComing @"kNotifierMessageComing"    //取到消息后，对chatcontroller内容进行更新
#define kNotifierMessageGroupUpdate @"kNotifierMessageGroupUpdate" ////取到消息后，对messageCenter内容进行更新,显示最新消息
#define kUPMessageTimeMachineName     @"messageTimer"

#define kMessageRequireTimeInterval 5.0f
#define kUPBaseURL @"http://api.qidianzhan.com.cn/AppServ/index.php" //http://121.40.70.124:8080/upper/AppServ/index.php
//浅灰
#define GRAYCOLOR [UIColor colorWithRed:248/255.0 green:245/255.0 blue:246/255.0 alpha:1]
//暗红
#define REDCOLOR [UIColor colorWithRed:138/255.0 green:16/255.0 blue:16/255.0 alpha:1]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//第一个Label离top的距离
#define FirstLabelHeight 44

//左右边距
#define LeftRightPadding 0
//上下边距 for cell
#define TopDownPadding 1
#define CellHeightDefault 44
#define SectionHeaderHeight 15


//顶部菜单高度
#define selectMenuH 30

typedef NS_ENUM(NSInteger, ViewType) {
    HOME_VIEW = 0,
    UPPER_VIEW,
    ACTIVITY_VIEW,
    EXPERT_VIEW,
    LAUNCH_ACTIVITY_VIEW,
    MY_LOCATION_VIEW,
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
