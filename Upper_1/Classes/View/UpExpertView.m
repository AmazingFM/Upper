//
//  UpExpertView.m
//  Upper_1
//
//  Created by aries365.com on 15/11/13.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpExpertView.h"

@implementation UpExpertView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIView *infoV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width*0.8, frame.size.height)];
    infoV.backgroundColor = [UIColor whiteColor];
    
    CGFloat infoVW = infoV.frame.size.width;

    UIButton *tipBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, infoVW*0.6-10, frame.size.height/2)];
    tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [tipBtn setImage:[UIImage imageNamed:@"person"] forState:UIControlStateNormal];
    [tipBtn setTitle:@"368人参与" forState:UIControlStateNormal];
    [tipBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[tipBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
   // [tipBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    
    
    UILabel *disc = [[UILabel alloc]initWithFrame:CGRectMake(10, frame.size.height/2, infoVW*0.6, frame.size.height/2)];
    disc.font = [UIFont systemFontOfSize:14];
    disc.text = @"医药行业的未来";
    
    UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(infoVW*0.6, frame.size.height/2, infoVW*0.4, frame.size.height/2)];
    name.font = [UIFont systemFontOfSize:10];
    name.text = @"周明  ";
    name.textAlignment = NSTextAlignmentRight;
    
    [infoV addSubview:tipBtn];
    [infoV addSubview:disc];
    [infoV addSubview:name];

    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width*0.8, 0, frame.size.width*0.2, frame.size.height)];
    ;
    imageV.contentMode = UIViewContentModeScaleToFill;
    imageV.image = [UIImage imageNamed:@"act"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(infoVW*0.6, 5, infoVW*0.44, frame.size.height/2-5)];
    titleLabel.backgroundColor=[UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"协和医院专家";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:imageV];
    [self addSubview:infoV];
    [self addSubview:titleLabel];
    return self;
}

@end
