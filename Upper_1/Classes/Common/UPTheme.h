//
//  UPTheme.h
//  Upper
//
//  Created by 张永明 on 16/4/24.
//  CopyrigUP © 2016年 aries365.com. All rigUPs reserved.
//

#import <Foundation/Foundation.h>

#import "UIImage+CH.h"
#import "UIView+MJ.h"
#import "UIBarButtonItem+CH.h"

#define kImageRatio 0.75

//定义屏幕的宽-高
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//定义颜色的宏
#define UpColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define UpColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

// 随机色
#define  UpRandomColor UpColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

//判断是什么型号的手机
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



//定义一个监听
#define XWNotification  [NSNotificationCenter defaultCenter]
//定义checkout复选框  通知的名字
#define checkBoxName @"checkBoxName"
//定义个清空缓存的通知名字
#define clearDataName @"clearDataName"
//定义下载完毕后发送的通知
#define downdidFinishName @"downdidFinishName"


#define kUPDateFormater @"yyyy-MM-dd"
#define kUPDateParamFormater @"yyyyMMdd"

#define kUPCellDefaultHeight 50
#define kUPCellHorizontalPadding 15
#define kUPCellVerticalPadding 2

#define kHTTabbarHeight        50

#define kUPNavigationBarHeight 44

// 功能菜单宽度
#define kUPMainMenuWidth       320

#define kUPMainStatusBarHeight 20
#define kUPMainSubViewHeight   (ScreenWidth-kUPTabbarHeight-kUPMainStatusBarHeight)          //带tab和子页面
#define kUPMainViewHeight (ScreenHeight-kUPNavigationBarHeight-kUPMainStatusBarHeight)   //主界面

/**
 *  ---------------------------------------UIColor-----------------------------------------
 */

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//主色调
#define kUPThemeMainColor           RGBCOLOR(140,25,25) //暗红
#define kUPThemeLineColor           [UIColor colorWithWhite:0.3 alpha:0.15]//线条颜色
#define kUPThemeBackgroundColor     RGBCOLOR(237,237,237) //RGBCOLOR(255,255,255)
#define kUPThemeHighligUPColor      RGBCOLOR(250,150,40)
#define kUPThemeUnhighligUPColor    [UIColor lightGrayColor]

//#define kUPThemeTableHeaderBackgroundColor RGBCOLOR(240,240,240)
#define kUPThemeTableCellHighligUPBackgroundColor RGBCOLOR(250,250,250)

#define kUPThemeMenuTitleHighligUPColor kUPThemeMainColor

/**
 *  ------------------------------------------style------------------------------------------
 */

//默认圆角
#define kUPThemeCornerRadius  5.0f

//默认左右间距
#define kUPThemeBorder        5
#define kUPHBorder        5
//默认上下间距
#define kUPVBorder        2

#define kUPThemeHugeFont      [UIFont systemFontOfSize:30]
#define kUPThemeBigFont       [UIFont systemFontOfSize:24]
#define kUPThemeMiddleFont    [UIFont systemFontOfSize:20]
#define kUPThemeNormalFont     [UIFont systemFontOfSize:16]
#define kUPThemeSmallFont     [UIFont systemFontOfSize:14]
#define kUPThemeMinFont       [UIFont systemFontOfSize:12]
#define kUPThemeMiniFont       [UIFont systemFontOfSize:10]

#define kUPThemeTitleFont     [UIFont systemFontOfSize:17]
#define kUPThemeInfoTimeFont  [UIFont systemFontOfSize:15]

extern UIButton* createSubmitButton(CGFloat fontSize);


@interface UPTheme : NSObject

+ (instancetype)shared;

- (UIColor *)colorForTitle;

- (UIFont *)fontForCommon;

//-------------------------------------------------------------------------------------

// 获取日期 格式yyyyMMdd
+ (NSString *)getSpecialDate:(NSString *)date;
//用空格截取日期
+ (NSString *)getDate:(NSString*)curDateStr;
//用空格截取时间
+ (NSString *)getTime:(NSString*)curDateStr;
//根据传入日期返回日期格式，当天的没有日期，只有时间
+ (NSString *)getDateStrByCurDate:(NSString *)recvDateStr curDateStr:(NSString *)curDateStr;

// 取当日期 格式YYYY-MM-DD
+ (NSString *)getCurDate;



@end
