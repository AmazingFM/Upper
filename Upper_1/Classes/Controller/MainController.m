//
//  UpHomeController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "MainController.h"
#import "UpExpertController.h"
#import "UpMyActivityController.h"
#import "UpSettingController.h"
#import "ActivityData.h"
#import "UpActivitiesController.h"
#import "UpRegisterController.h"
#import "LaunchActivityController.h"
#import "NewLaunchActivityController.h"
#import "PersonalCenterController.h"
#import "EnrollPeopleController.h"
#import "UpActDetailController.h"
#import "GetPasswordController.h"
#import "UpperController.h"
#import "UPQRViewController.h"
#import "QRCodeController.h"
#import "ChatController.h"
#import "MessageCenterController.h"

@interface MainController ()<UIGestureRecognizerDelegate>

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myActController = [[UpMyActivityViewController alloc]init];
    myActController.parentController = self;
    
    expertController = [[UpExpertController alloc]init];
    expertController.parentController = self;
    
    activityController =[[UpActivitiesController alloc]init];
    activityController.parentController = self;
    
    settingController = [[UpSettingController alloc]init];
    settingController.parentController = self;
    
    registerController = [[UpRegisterController alloc]init];
    registerController.parentController = self;
    
    launchActController = [[LaunchActivityController alloc]init];
    launchActController.parentController = self;
    
    newLaunchActController = [[NewLaunchActivityController alloc]init];
    newLaunchActController.parentController = self;
    
    personalCenterController = [[PersonalCenterController alloc]init];
    personalCenterController.parentController = self;
    
    enrollController = [[EnrollPeopleController alloc]init];
    enrollController.parentController = self;
    
    actDetailController = [[UpActDetailController alloc]init];
    actDetailController.parentController = self;
    
    getPasswordController = [[GetPasswordController alloc]init];
    getPasswordController.parentController = self;
    
    upperController = [[UpperController alloc]init];
    upperController.parentController = self;
    
    qrController = [[UPQRViewController alloc] init];
    qrController.parentController = self;
        
    qrCodeController = [[QRCodeController alloc] init];
    qrCodeController.parentController = self;
    
    msgCenterController = [[MessageCenterController alloc] init];
    msgCenterController.parentController = self;
    
    chatController = [[ChatController alloc] init];
    chatController.parentController = self;
    
    [self OnAction:self withType:CHANGE_VIEW toView:ACTIVITY_VIEW withArg:nil];
}

- (void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (BOOL) isStack:(UIViewController *)p
{
    NSArray *array = [self.navigationController viewControllers];
    for (int i=0; i<array.count; i++) {
        if ([array objectAtIndex:i] == p) {
            return YES;
        }
    }
    return NO;
}
- (void) OnAction:(id)mself withType:(ActionType)actionType toView:(ViewType)viewType withArg:(id)arg
{
    switch (actionType) {
        case LEFT_MENU_CHANGE:
        {
            int nIndex = viewType;
            switch (nIndex) {
                case UPPER_VIEW:
                {
                    
                    if ([self isStack:upperController]) {
                        [self.navigationController popToViewController:upperController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:upperController animated:YES];
                    }
                    [upperController setTitle:@"Upper"];
                    break;
                }
                case ACTIVITY_VIEW:
                {
                    if ([self isStack:activityController]) {
                        [self.navigationController popToViewController:activityController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:activityController animated:YES];
                    }
                    [activityController setTitle:@"活动大厅"];
                    break;
                }
                case EXPERT_VIEW:
                {
                    if ([self isStack:expertController]) {
                        [self.navigationController popToViewController:expertController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:expertController animated:YES];
                    }
                    [expertController setTitle:@"专家社区"];
                    break;
                }
                case LAUNCH_ACTIVITY_VIEW:
                {
                    
                    if ([self isStack:newLaunchActController]) {
                        [self.navigationController popToViewController:newLaunchActController animated:NO];
                    } else {
                        [self.navigationController pushViewController:newLaunchActController animated:YES];
                    }

                }
                    break;
                case MY_LOCATION_VIEW:
                {
                    if ([self isStack:launchActController]) {
                        [self.navigationController popToViewController:launchActController animated:NO];
                    } else {
                        [self.navigationController pushViewController:launchActController animated:YES];
                    }
                }
                    break;
                case MY_ACTIVITY_VIEW:
                {
                    if ([self isStack:myActController]) {
                        [self.navigationController popToViewController:myActController  animated:NO];
                    } else {
                        [self.navigationController pushViewController:myActController animated:YES];
                    }
                }
                    break;
            }
        }
            break;
        case CHANGE_VIEW:
        {
            int nIndex = viewType;
            switch (nIndex) {
                case REGISTER_VIEW:
                {
                    if ([self isStack:registerController]) {
                        [self.navigationController popToViewController:registerController animated:YES];
                    } else {
                        [self.navigationController pushViewController:registerController animated:YES];
                    }
                }
                    break;
                case SETTING_VIEW:
                {
                    if ([self isStack:settingController]) {
                        [self.navigationController popToViewController:settingController animated:YES];
                    }
                    else {
                        [self.navigationController pushViewController:settingController animated:YES];
                    }
                    [settingController setTitle:@"设置"];
                    break;
                }
                case PERSON_CENTER_VIEW:
                {
                    if (arg!=nil) {
                        personalCenterController.index = (int)[(NSString*)arg integerValue];
                    }
                    if ([self isStack:personalCenterController]) {
                        [self.navigationController popToViewController:personalCenterController animated:YES];
                    } else {
                        [self.navigationController pushViewController:personalCenterController animated:YES];
                    }
                }
                    break;
                case ENROLL_PEOPLE_VIEW:
                {
                    if ([self isStack:enrollController]) {
                        [self.navigationController popToViewController:enrollController animated:YES];
                    } else {
                        [self.navigationController pushViewController:enrollController animated:YES];
                    }
                }
                    break;
                case ACTIVITY_DETAIL_VIEW:
                {
                    if ([self isStack:actDetailController]) {
                        [self.navigationController popToViewController:actDetailController animated:YES];
                    } else {
                        [self.navigationController pushViewController:actDetailController animated:YES];
                    }
                    break;
                }
                case GET_PASSWORD_VIEW:
                {
                    if ([self isStack:getPasswordController]) {
                        [self.navigationController popToViewController:getPasswordController animated:YES];
                    } else {
                        [self.navigationController pushViewController:getPasswordController animated:YES];
                    }
                    break;
                }
                case MYACT_VIEW:
                {
                    if ([self isStack:myActController]) {
                        [self.navigationController popToViewController:myActController animated:YES];
                    }
                    else {
                        [self.navigationController pushViewController:myActController animated:YES];
                    }
                    [myActController setTitle:@"我的活动"];
                    break;
                }
                case QR_VIEW:
                {
                    if ([self isStack:qrController]) {
                        [self.navigationController popToViewController:qrController animated:NO];
                    } else {
                        [self.navigationController pushViewController:qrController animated:YES];
                    }
                    [qrController setTitle:@"我的二维码"];
                }
                    break;
                case QR_SCAN_VIEW:
                {
                    if ([self isStack:qrCodeController]) {
                        [self.navigationController popToViewController:qrCodeController animated:NO];
                    } else {
                        [self.navigationController pushViewController:qrCodeController animated:YES];
                    }
                    [qrCodeController setTitle:@"扫描"];
                }
                    break;
                case LAUNCH_ACTIVITY_VIEW:
                {
                    if ([self isStack:launchActController]) {
                        [self.navigationController popToViewController:launchActController animated:NO];
                    } else {
                        [self.navigationController pushViewController:launchActController animated:YES];
                    }
                }
                    break;
                case CHAT_VIEW:
                {
                    if ([self isStack:chatController]) {
                        [self.navigationController popToViewController:chatController animated:YES];
                    } else {
                        [self.navigationController pushViewController:chatController animated:YES];
                    }
                }
                    break;
                case MESSAGE_CENTER_VIEW:
                {
                    if ([self isStack:msgCenterController]) {
                        [self.navigationController popToViewController:msgCenterController animated:YES];
                    } else {
                        [self.navigationController pushViewController:msgCenterController animated:YES];
                    }
                }
                    break;
                case ACTIVITY_VIEW:
                {
                    if ([self isStack:activityController]) {
                        [self.navigationController popToViewController:activityController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:activityController animated:YES];
                    }
                    break;
                }
                case UPPER_VIEW:
                {
                    if ([self isStack:upperController]) {
                        [self.navigationController popToViewController:upperController animated:NO];
                    }
                    else {
                        [self.navigationController pushViewController:upperController animated:YES];
                    }
                    [upperController setTitle:@"Upper"];
                    break;
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)rightClick
{
    [self OnAction:self withType:CHANGE_VIEW toView:PERSON_CENTER_VIEW withArg:nil];
}

@end
