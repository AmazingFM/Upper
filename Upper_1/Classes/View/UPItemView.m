//
//  UPItemView.m
//  Upper
//
//  Created by freshment on 16/5/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPItemView.h"
#import "Info.h"

@implementation UPItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self  = [super initWithFrame:frame];
    if (self) {
        
        _backView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightPadding, TopDownPadding, frame.size.width-2*LeftRightPadding, frame.size.height-2*TopDownPadding)];
        _backView.backgroundColor = [UIColor clearColor];
        
        _iconImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_backView addSubview:_iconImg];
        [_backView addSubview:_descLabel];
        [_backView addSubview:_infoBtn];
        
        [self addSubview:_backView];
    }
    return self;
}

- (void)setTitle:(NSString *)title  andTips:(NSString *)tips andType:(UPViewType)type
{
    self.type = type;
    
    _iconImg.frame = CGRectMake(0, 0, _backView.height, _backView.height);
    _iconImg.image = [UIImage imageNamed:@"sidebar_ad"];
    _iconImg.contentMode = UIViewContentModeScaleAspectFit;
    
    _descLabel.frame = CGRectMake(_iconImg.size.width+LeftRightPadding, 0, 150, _backView.height);
    _descLabel.text = title;
    _descLabel.font = [UIFont systemFontOfSize:15.0f];
    _descLabel.textAlignment = NSTextAlignmentLeft;
    
    _infoBtn.frame = CGRectMake(_backView.width-200, 0, 200, _backView.height);
    [_infoBtn setTitle:tips forState:UIControlStateNormal];
    _infoBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _infoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _infoBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_infoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(itemViewClick:withTag:)]) {
        [self.delegate itemViewClick:self.type withTag:self.tag];
    }
}

- (void)setValueStr:(NSString *)valueStr
{
    if (valueStr!=nil) {
        [_infoBtn setTitle:valueStr forState:UIControlStateNormal];
    }
}

- (NSString *)valueStr
{
    return   _infoBtn.titleLabel.text;;
}
@end
