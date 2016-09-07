//
//  UIBarButtonItem+CH.h
//  新闻
//
//  Created by Think_lion on 15/5/4.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CH)
+(UIBarButtonItem*)itemWithLeftIcon:(NSString *)icon highIcon:(NSString*)highIcon target:(id)target action:(SEL)action;
+(UIBarButtonItem*)itemWithRightIcon:(NSString *)icon highIcon:(NSString*)highIcon target:(id)target action:(SEL)action;
//导航栏左边按钮的添加  包括设置距离
+(UIBarButtonItem*)itemWithLeftIcon:(NSString *)icon highIcon:(NSString*)highIcon  edgeInsets:(UIEdgeInsets)edgeInsets  target:(id)target action:(SEL)action;
//设置左边按钮文字  包括间距
+(UIBarButtonItem*)itemWithLeftTitle:(NSString*)title target:(id)target action:(SEL)action;
//设置右边按钮文字, by zym 20151102
+(UIBarButtonItem*)itemWithRightTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
