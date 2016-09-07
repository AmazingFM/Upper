//
//  UPGlobals.m
//  Upper
//
//  Created by 张永明 on 16/4/27.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPGlobals.h"
#import "UPDataManager.h"
#import "MessageManager.h"

int  g_PageSize;

int     g_nOSVersion;

int     g_MajorVersion;
int     g_MinorVersion;
int     g_BuilderNumber;

float   g_newsFontSize;

UIWindow *g_mainWindow;

NSString *g_uuid;

AppDelegate *g_appDelegate;
MainController *g_mainMenu;
YRSideViewController* g_sideController;

void initialize()
{
    UIDevice* device=[UIDevice currentDevice];
    g_PageSize = 20;
    g_nOSVersion=[device.systemVersion intValue];
    
    g_newsFontSize=18.0f;
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString*  version=[infoDict objectForKey:@"CFBundleShortVersionString"];
    NSArray *verArr = [version componentsSeparatedByString:@"."];
    if ([verArr count] > 2) {
        g_MajorVersion = [[verArr objectAtIndex:0] intValue];
        g_MinorVersion = [[verArr objectAtIndex:1] intValue];
        g_BuilderNumber = [[verArr objectAtIndex:2] intValue];
    }
    
    g_appDelegate = nil;
    
    [[MessageManager shared] initEnv];//初始化
    
    [UPDataManager shared].isLogin = NO;
    [[UPDataManager shared] readFromDefaults];
    
    
}
@implementation UPGlobals

@end
