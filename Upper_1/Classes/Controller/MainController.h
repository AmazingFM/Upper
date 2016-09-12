//
//  UpHomeController.h
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UPGlobals.h"
#import "UPDataManager.h"
#import "Info.h"
#import "UPBaseViewController.h"

@class UpRegisterController;
@class LaunchActivityController;
@class PersonalCenterController;
@class EnrollPeopleController;
@class UpActDetailController;
@class GetPasswordController;
@class UpperController;
@class UPQRViewController;
@class QRCodeController;
@class ChatController;
@class MessageCenterController;
@class NewLaunchActivityController;

@class UpExpertController;
@class UpMyActivityViewController;
@class UpSettingController;


@interface MainController : UPBaseViewController
{
    UpMyActivityViewController *myActController;
    UpExpertController *expertController;
    UpSettingController *settingController;
    UpRegisterController *registerController;
    LaunchActivityController *launchActController;
    NewLaunchActivityController *newLaunchActController;
    PersonalCenterController *personalCenterController;
    EnrollPeopleController *enrollController;
    GetPasswordController *getPasswordController;
    UpperController *upperController;
    UPQRViewController *qrController;
    QRCodeController *qrCodeController;
    MessageCenterController *msgCenterController;
    ChatController *chatController;
}

@property (nonatomic, retain) id parentController;

- (void)OnAction:(id)mself withType:(ActionType)actionType toView:(ViewType)viewType withArg:(id)arg;
- (void)rightClick;
@end
