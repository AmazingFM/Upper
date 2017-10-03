//
//  WXApiManager.m
//  Upper
//
//  Created by 张永明 on 2017/5/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "WXApiManager.h"
#import "UPGlobals.h"
#import "Info.h"
#import "MBProgressHUD+MJ.h"

@implementation WXApiManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImageName:(NSString *)thumbImageName
            InScene:(enum WXScene)scene
{
    if ([WXApi isWXAppInstalled]) {
        UIImage *thumbImage = [UIImage imageNamed:thumbImageName];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = urlString;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        message.mediaObject = ext;
        message.messageExt = nil;
        message.messageAction = nil;
        message.mediaTagName = tagName;
        [message setThumbImage:thumbImage];
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = scene;
        
        [WXApi sendReq:req];
    } else {
        [MBProgressHUD showError:@"未检测到微信"];
    }
}


#pragma mark WXApiDelegate
- (void)onReq:(BaseReq *)req{}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(managerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate managerDidRecvMessageResponse:messageResp];
        }
    }
}

@end
