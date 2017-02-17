//
//  UIView+UPCacheOperation.h
//  Upper
//
//  Created by 张永明 on 2017/2/15.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPWebImageManager.h"

@interface UIView (UPCacheOperation)

- (void)up_setImageLoadOperation:(id)operation forKey:(NSString *)key;

- (void)up_cancelImageLoadOperationWithKey:(NSString *)key;

- (void)up_removeImageLoadOperationWithKey:(NSString *)key;

@end
