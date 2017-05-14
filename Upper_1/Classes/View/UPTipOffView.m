//
//  UPTipOffView.m
//  Upper
//
//  Created by 张永明 on 2017/5/13.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPTipOffView.h"
#import "UPTheme.h"

@implementation UPTipOffView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        tipoffArr = @[@"地域攻击", @"无端谩骂", @"营销诈骗", @"淫秽色情", @"反动谣言", @"其它原因"];
        float rowHeight = frame.size.height/2;
        float btnWidth = frame.size.width/3;
        float labelWidth;
        float labelHeight;
        CGSize labelSize = [@"地域攻击" sizeWithAttributes: @{NSFontAttributeName:[UIFont systemFontOfSize:15.f]}];
        if (labelSize.width+20>=btnWidth) {
            labelWidth = btnWidth-10;
        } else {
            labelWidth = labelSize.width+10;
        }
        labelHeight = labelSize.height+5;
        
        for (int i=0; i<tipoffArr.count; i++) {
            NSString *tipoff = tipoffArr[i];
        
            int row = i/3;
            int col = i%3;
            
            CGRect btnFrame = CGRectMake(col*btnWidth, row*rowHeight, btnWidth, rowHeight);
            
            CGRect labelFrame = CGRectMake((btnWidth-labelWidth)/2, (rowHeight-labelHeight)/2, labelWidth, labelHeight);
            UILabel *titleLabel = [self createLabelWithFrame:labelFrame withText:tipoff];
            titleLabel.tag = 1000;
            
            UIButton *tipoffBtn = [self createButtonWithTag:100+i frame:btnFrame];
            [tipoffBtn addSubview:titleLabel];
            
            [self addSubview:tipoffBtn];
        }
    }
    return self;
}

- (UIButton *)createButtonWithTag:(NSInteger)tag frame:(CGRect)btnFrame
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = btnFrame;
    button.tag = tag;
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(tipoffClicked:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.layer.cornerRadius = 5.f;
    label.layer.borderColor = kUPThemeLineColor.CGColor;
    label.layer.borderWidth = 0.6f;
    label.layer.masksToBounds = YES;
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:14.f];
    return label;
}

- (void)tipoffClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    UILabel *titleLabel = [sender viewWithTag:1000];
    
    if (sender.isSelected) {
        titleLabel.backgroundColor = [UIColor lightGrayColor];
        titleLabel.textColor = [UIColor whiteColor];
    } else {
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
    }
}

- (NSString *)getTipOffDesc
{
    NSMutableArray *resultArr = [NSMutableArray new];
    for (int i=0; i<tipoffArr.count; i++) {
        UIButton *btn = [self viewWithTag:100+i];
        if (btn.isSelected) {
            [resultArr addObject:tipoffArr[i]];
        }
    }
    
    if (resultArr.count>0) {
        return [resultArr componentsJoinedByString:@","];
    } else {
        return nil;
    }
}
@end
