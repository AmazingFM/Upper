//
//  UPTextAlertView.m
//  Upper
//
//  Created by 张永明 on 2017/8/11.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPTextAlertView.h"
#import "UPGlobals.h"

#define kALERTVIEW_WIDTH ScreenWidth*3/4

@interface UPTextAlertView()
{
    NSString *_title;
    NSString *_message;
    NSString *_btnTitle;
}

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UITextView *contentView;
@property (nonatomic, weak) UIButton *actionButton;

@end

@implementation UPTextAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UPTextAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle
{
    _title = title;
    _message = message;
    _btnTitle = cancelButtonTitle;
    self.delegate = delegate;
    
    return [self initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
}

- (void)setup
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    float alertHeight = 0.f;
    float titleHeight = 30;
    float btnHeight = 35;
    float maxHeight = ScreenHeight*3/4;
    
    if (!_backView) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.cornerRadius = 6.0;
        backView.clipsToBounds = YES;
        [self addSubview:backView];
        _backView = backView;
    }

    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kALERTVIEW_WIDTH, titleHeight)];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.cornerRadius = 4;
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = _title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.backView addSubview:titleLabel];
        _titleLabel = titleLabel;
    }
    
    if (!_contentView) {
        
        BOOL needScroll = NO;
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;//两端对齐
        paragraphStyle.paragraphSpacingBefore=0;
        paragraphStyle.paragraphSpacing = 0.f;
        UIFont *textFont = [UIFont systemFontOfSize:14];
        
        UITextView *contentText = [[UITextView alloc] initWithFrame:CGRectZero];
        contentText.editable = NO;
        contentText.selectable = NO;
        contentText.backgroundColor = [UIColor clearColor];
        contentText.contentInset = UIEdgeInsetsMake(-10,0,0,0);
        contentText.textColor = [UIColor blackColor];
        contentText.attributedText = [[NSAttributedString alloc] initWithString:_message attributes:@{NSFontAttributeName:textFont, NSParagraphStyleAttributeName:paragraphStyle}];
        
        CGFloat insets = 8.f;
        CGSize contentSize = [contentText sizeThatFits:CGSizeMake(kALERTVIEW_WIDTH-insets*2, CGFLOAT_MAX)];
        if (contentSize.height+10+btnHeight+titleHeight> maxHeight) {
            alertHeight = maxHeight;
            needScroll = YES;
        } else {
            alertHeight = contentSize.height+titleHeight+btnHeight+10;
            needScroll = NO;
        }
        
        float y = CGRectGetMaxY(self.titleLabel.frame);
        contentText.frame = CGRectMake(insets, y, kALERTVIEW_WIDTH-insets*2, alertHeight-y-btnHeight);
        contentText.scrollEnabled = needScroll;
        
        [self.backView addSubview:contentText];
    }
    
    if (!_actionButton) {
        UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        actionButton.frame=CGRectMake(0, alertHeight-btnHeight, kALERTVIEW_WIDTH, btnHeight);
        [actionButton setTitle:@"确定" forState:UIControlStateNormal];
        [actionButton setTitleColor:RGBCOLOR(0, 122, 255) forState:UIControlStateNormal];
        actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
        actionButton.backgroundColor = [UIColor clearColor];
        
        [actionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.backView addSubview:actionButton];
        _actionButton = actionButton;
    }
    
    UIView *lineView1=[[UIView alloc] initWithFrame:CGRectMake(0, alertHeight-btnHeight, kALERTVIEW_WIDTH, 0.4)];
    lineView1.backgroundColor=[UIColor lightGrayColor];
    
    self.backView.frame = CGRectMake(0, 0, kALERTVIEW_WIDTH, alertHeight);
    self.backView.center = self.center;
    
    [self.backView addSubview:lineView1];
}

- (void)buttonClicked:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textAlertView:clickedButtonAtIndex:)]) {
        [self.delegate textAlertView:self clickedButtonAtIndex:0];
    }
    [self dismiss];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)show
{
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
