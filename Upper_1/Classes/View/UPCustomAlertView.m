//
//  UPCustomAlertView.m
//  Upper
//
//  Created by 张永明 on 2017/5/13.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPCustomAlertView.h"

#define kUPCustomAlertViewTitleHeight 40
#define kUPCustomAlertViewLineColor [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:0.5]
@implementation UPCustomAlertView

- (instancetype)initWithTitle:(NSString *)title CustomView:(UIView *)a_customView
{
    //40+40+customViewFrame.Height
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.customView = a_customView;
        self.customView.frame = CGRectOffset(a_customView.frame, 0, kUPCustomAlertViewTitleHeight);
        
        CGRect customRect = CGRectMake(0, 0, self.frame.size.width-100, kUPCustomAlertViewTitleHeight*2+self.customView.frame.size.height);
        mainView = [[UIView alloc] initWithFrame:customRect];
        mainView.backgroundColor = [UIColor whiteColor];
        mainView.layer.cornerRadius = 10.f;
        mainView.layer.masksToBounds = YES;
        mainView.center = self.center;
        
        titleLabel = [self createLabelWithTitle:title andFrame:CGRectMake(0, 10, mainView.frame.size.width, kUPCustomAlertViewTitleHeight-10)];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.frame.size.height-0.6, mainView.frame.size.width, 0.6)];
        line.backgroundColor = kUPCustomAlertViewLineColor;
        [titleLabel addSubview:line];
        
        confirmBtn = [self createButtonWithTitle:@"确定" andFrame:CGRectMake(mainView.frame.size.width/2, kUPCustomAlertViewTitleHeight+self.customView.frame.size.height, mainView.frame.size.width/2, kUPCustomAlertViewTitleHeight)];
        confirmBtn.tag = 100;
        
        cancelBtn = [self createButtonWithTitle:@"取消" andFrame:CGRectMake(0, kUPCustomAlertViewTitleHeight+self.customView.frame.size.height, mainView.frame.size.width/2, kUPCustomAlertViewTitleHeight)];
        cancelBtn.tag = 101;
        
        UIView *Hline = [[UIView alloc] initWithFrame:CGRectMake(0, kUPCustomAlertViewTitleHeight+self.customView.frame.size.height, mainView.frame.size.width, 0.6)];
        Hline.backgroundColor = kUPCustomAlertViewLineColor;

        UIView *Vline = [[UIView alloc] initWithFrame:CGRectMake(mainView.frame.size.width/2-0.6, kUPCustomAlertViewTitleHeight+self.customView.frame.size.height, 0.6, kUPCustomAlertViewTitleHeight)];
        Vline.backgroundColor = kUPCustomAlertViewLineColor;

        [mainView addSubview:titleLabel];
        [mainView addSubview:self.customView];
        [mainView addSubview:confirmBtn];
        [mainView addSubview:cancelBtn];
        [mainView addSubview:Hline];
        [mainView addSubview:Vline];
        
        [self addSubview:mainView];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)dismiss
{
    [self.customView removeFromSuperview];
    [mainView removeFromSuperview];
    [self removeFromSuperview];
    self.customView = nil;
}

- (UILabel *)createLabelWithTitle:(NSString *)title andFrame:(CGRect)labelFrame
{
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.text = title;
    label.font = [UIFont boldSystemFontOfSize:17.f];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    return label;
}
                     
- (UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)btnFrame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:17.f];
    [btn setTitleColor:[UIColor colorWithRGBHex:0x157EFB] forState:UIControlStateNormal];
    btn.frame = btnFrame;
    btn.backgroundColor = [UIColor clearColor];
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag==100) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(customAlertView:buttonClickedWithIndex:)])  {
            [self.delegate customAlertView:self buttonClickedWithIndex:1];
        }
        [self dismiss];
    } else if (sender.tag==101) {
        [self dismiss];
    }
}
@end
