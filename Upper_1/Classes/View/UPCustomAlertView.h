//
//  UPCustomAlertView.h
//  Upper
//
//  Created by 张永明 on 2017/5/13.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPCustomAlertView;
@protocol UPCustomAlertViewDelegate <NSObject>

- (void)customAlertView:(UPCustomAlertView *)alertView buttonClickedWithIndex:(NSInteger)index;

@end

@interface UPCustomAlertView : UIView
{
    UIView *bgView;
    UIView *mainView;
    UIView *titleLabel;
    UIView *customView;
    UIButton *confirmBtn;
    UIButton *cancelBtn;
}

@property (nonatomic, weak) id<UPCustomAlertViewDelegate> delegate;

- (instancetype)initWithTitle:(NSString *)title CustomView:(UIView *)a_customView;
- (void)show;
@end
