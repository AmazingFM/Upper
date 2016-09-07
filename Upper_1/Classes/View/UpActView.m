//
//  UpActView.m
//  Upper_1
//
//  Created by aries365.com on 15/11/12.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpActView.h"

@implementation UpActView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    _actTitle = @"大堡礁奢华游轮派对";
    _actContent = @"Met Ball是时尚界最隆重的晚会 因名流汇聚而备受外界瞩目的晚会红毯部分都被誉为时尚界奥斯卡...";
    _actBeginTime = @"2015.06.20";
    _actLocation = @"London";
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/2)];
    //imageV.contentMode = UIViewContentModeScaleAspectFit;
    imageV.contentMode = UIViewContentModeScaleToFill;
    imageV.image = [UIImage imageNamed:@"act"];
    
    UIView *infoV = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2)];
    infoV.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height/4-16)];
    titleLabel.text = _actTitle;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *seperatorV = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height/4-16, frame.size.width, 1)];
    seperatorV.backgroundColor = [UIColor grayColor];
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height/4-15, frame.size.width, frame.size.height/4)];
    tipsLabel.text = _actContent;
    tipsLabel.font = [UIFont systemFontOfSize:11];
    tipsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipsLabel.numberOfLines = 0;
    tipsLabel.textColor = [UIColor grayColor];
    
    UIButton *arrowBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, frame.size.height/2-15, frame.size.width, 15)];
    [arrowBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [arrowBtn setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
    [arrowBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    [infoV addSubview:titleLabel];
    [infoV addSubview:seperatorV];
    [infoV addSubview:tipsLabel];
    [infoV addSubview:arrowBtn];
    
    
    [self addSubview:imageV];
    [self addSubview:infoV];

    return self;
}

@end
