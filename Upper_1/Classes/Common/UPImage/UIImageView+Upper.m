//
//  UIImageView+Upper.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UIImageView+Upper.h"
#import <objc/runtime.h>
#import "UIView+UPCacheOperation.h"
#import "UPWebImageOperation.h"
#import "UPWebImageManager.h"

static char imageURLKey;

@implementation UIImageView (Upper)

- (void)setImageWithUserId:(NSString *)userId
{
    [self setImageWithUserId:userId placeholderImage:nil];
}

- (void)setImageWithUserId:(NSString *)userId placeholderImage:(UIImage *)placeholder completed:(UPWebImageCompletionBlock)completedBlock
{
    [self up_cancelCurrentImageLoad];
    objc_setAssociatedObject(self, &imageURLKey, userId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    //先设置默认图片
    dispatch_main_async_safe(^{
        self.image = placeholder;
    });
    
    if (userId) {
        __weak __typeof(self)wself = self;
        id<UPWebImageOperation> operation = [[UPWebImageManager sharedManager] downloadImageWithUserID:userId progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSString *usrID){
            if (!wself) {
                return;
            }
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image && completedBlock) {
                    completedBlock(image, error, cacheType, userId);
                    return;
                } else if (image) {
                    wself.image = image;
                    [wself setNeedsLayout];
                } else {
                    wself.image = placeholder;
                    [wself setNeedsLayout];
                }
                
                if (completedBlock && finished) {
                    completedBlock(image, error, cacheType, userId);
                }
            });
            
        }];
        [self up_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    }
}
                                                                                                 
- (void)setImageWithUserId:(NSString *)userId placeholderImage:(UIImage *)placeholder
{
    [self setImageWithUserId:userId placeholderImage:placeholder completed:nil];
}

- (void)up_cancelCurrentImageLoad
{
    [self up_cancelImageLoadOperationWithKey:@"UIImageViewImageLoad"];
}
@end
