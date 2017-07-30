//
//  UPGlobals.h
//  Upper
//
//  Created by 张永明 on 16/4/27.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "YRSideViewController.h"

#import "UPTheme.h"

extern int g_PageSize;

extern NSString *g_uuid;

extern int g_nOSVersion;


extern int       g_MajorVersion;

extern int       g_MinorVersion;

extern int       g_BuilderNumber;


extern float     g_newsFontSize;

extern UIWindow *g_mainWindow;


extern AppDelegate *g_appDelegate;

@class MainController;
extern YRSideViewController* g_sideController;

@class UPMainMenuController;
extern UPMainMenuController *g_homeMenu;

extern BOOL g_isLogin;

extern void initialize();

UIBarButtonItem* createBarItemTitle(NSString* title ,id target, SEL selector);

void showDefaultAlert(NSString* title,NSString* msg);
void showConfirmAlert(NSString* title,NSString* msg,id<UIAlertViewDelegate> delegate);
void showConfirmTagAlert(NSString* title,NSString* msg,id<UIAlertViewDelegate> delegate,int tag);
@interface UPGlobals : NSObject

@end
