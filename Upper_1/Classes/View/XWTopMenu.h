//
//  XWTopMenu.h
//  新闻
//
//  Created by user on 15/9/4.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XWTopMenu;
@protocol XWTopMenuDelegate <NSObject>

@optional
-(void)topMenu:(XWTopMenu*)topMenu menuType:(NSInteger)menuType andDetailIndex:(NSInteger)detailIndex;

@end

@interface XWTopMenu : UIView<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

//代理
@property (nonatomic,weak) id<XWTopMenuDelegate> delegate;

- (void)createMenuTitleArray:(NSArray *)menuTitleArray dataSource:(NSArray *)dataArr;

@end
