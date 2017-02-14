//
//  UIImageView+Upper.h
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Upper)

- (void)setImageWithUserId:(NSString *)userId;
- (void)setImageWithUserId:(NSString *)userId placeholderImage:(UIImage *)placeholder;

@end
