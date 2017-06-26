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
#import <UIKit/UIKit.h>

int  g_PageSize;

int     g_nOSVersion;

int     g_MajorVersion;
int     g_MinorVersion;
int     g_BuilderNumber;

float   g_newsFontSize;

UIWindow *g_mainWindow;

NSString *g_uuid;

AppDelegate *g_appDelegate;
UPMainMenuController *g_homeMenu;

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
    [UPDataManager shared].isLogin = NO;
    [[UPDataManager shared] readFromDefaults];
    [[UPDataManager shared] readSeqFromDefaults];
    
    [MessageManager shared];
}

UIBarButtonItem* createBarItemTitle(NSString* title ,id target, SEL selector){
    UIBarButtonItem* barItem=nil;
    
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame=CGRectMake(0,0,40,32);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return barItem;
}

void showDefaultAlert(NSString* title,NSString* msg)
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

void showConfirmAlert(NSString* title,NSString* msg,id<UIAlertViewDelegate> delegate){
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

void showConfirmTagAlert(NSString* title,NSString* msg,id<UIAlertViewDelegate> delegate,int tag){
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag=tag;
    [alert show];
}


@implementation UPGlobals

@end
