//
//  UpLeftMenu.h
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//左边菜单最上面按钮的y值
#define LeftMenuButtonY 300

@class UpLeftMenu;
@protocol UpLeftMenuDelegate <NSObject>

@optional
-(void)leftMenu:(UpLeftMenu*)leftMenu didSelectedFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface UpLeftMenu : UIView

@property (nonatomic,weak) id<UpLeftMenuDelegate> delegate;

@end
