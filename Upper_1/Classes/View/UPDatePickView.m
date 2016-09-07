//
//  UPDatePickView.m
//  Upper
//
//  Created by 张永明 on 16/5/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPDatePickView.h"
#import "UPTheme.h"

@interface UPDatePickView()
{
    UIImageView *_iconImage;
    UILabel     *_titleLabel;
    UIButton    *_valueButton;
    UILabel     *_line;
}
@end

@implementation UPDatePickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _iconImage = [[UIImageView alloc] init];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UPTheme shared].fontForCommon;
        
        _valueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _line = [[UILabel alloc] init];
    }
    return self;
}


- (void)setIcon:(NSString *)iconName withTitle:(NSString *)title withDefaultValue:(NSString *)value
{
    //
}

@end