//
//  WXApiManager.h
//  Upper
//
//  Created by 张永明 on 2017/5/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WXApiManager : NSObject <WXApiDelegate>

+ (instancetype)sharedManager;

- (void)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImageName:(NSString *)thumbImageName
            InScene:(enum WXScene)scene;
@end
