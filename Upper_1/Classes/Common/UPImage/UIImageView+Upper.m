//
//  UIImageView+Upper.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UIImageView+Upper.h"
#import <objc/runtime.h>
#import "UIView+WebCacheOperation.h"

static char imageURLKey;
static char TAG_ACTIVITY_INDICATOR;
static char TAG_ACTIVITY_STYLE;
static char TAG_ACTIVITY_SHOW;

@implementation UIImageView (Upper)

- (void)setImageWithUserId:(NSString *)userId
{
    [self setImageWithUserId:userId placeholderImage:nil];
}

- (void)setImageWithUserId:(NSString *)userId placeholderImage:(UIImage *)placeholder
{
    [self up_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, userId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //先设置默认图片
    dispatch_main_async_safe(^{
        self.image = placeholder;
    });
    
    if (userId) {
        __weak __typeof(self)wself = self;
        
    }
}

- (void)up_cancelCurrentImageLoad
{
    [self sd_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}
@end
