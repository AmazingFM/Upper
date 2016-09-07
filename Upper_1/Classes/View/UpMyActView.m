//
//  UpMyActView.m
//  Upper_1
//
//  Created by aries365.com on 16/1/31.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UpMyActView.h"

@implementation UpMyActView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    _actTitle = @"大堡礁奢华游轮派对";
    _actContent = @"Met Ball是时尚界最隆重的晚会 因名流汇聚而备受外界瞩目的晚会红毯部分都被誉为时尚界奥斯卡...";
    _actBeginTime = @"2015.06.20";
    _actLocation = @"London";
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];;
    imageV.contentMode = UIViewContentModeScaleToFill;
    imageV.image = [UIImage imageNamed:@"act"];
    
    UIView *infoV = [[UIView alloc]initWithFrame:CGRectMake(frame.size.height, 0, frame.size.width-frame.size.height, frame.size.height)];
    infoV.backgroundColor = [UIColor whiteColor];
    
    CGFloat LabelHeight = 17;
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 80, LabelHeight)];
    timeLabel.text = @"2015.06.20";
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.textColor = [UIColor whiteColor];
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    UIButton *whereButton = [[UIButton alloc]initWithFrame:CGRectMake(2, 5, 120, LabelHeight)];
    [whereButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [whereButton setTitle:@"上海" forState:UIControlStateNormal];
    whereButton.backgroundColor=[UIColor redColor];
    whereButton.titleLabel.textColor = [UIColor whiteColor];
    whereButton.titleLabel.font = [UIFont systemFontOfSize:11.0f];
    whereButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [whereButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, whereButton.y+whereButton.height, infoV.width-2, 30)];
    titleLabel.text = self.actTitle; //@"XX律师所team building";
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.y+titleLabel.height, infoV.width, 1)];
    line.backgroundColor = [UIColor grayColor];
    
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, line.y+1, infoV.width-4, 50)];
    contentLabel.text = @"Met Ball是时尚界最隆重的晚会，因为名流汇聚因为名流汇聚因为名流汇聚因为名流汇聚因为名流汇聚因为名流汇聚因为名流汇聚";
    contentLabel.font = [UIFont systemFontOfSize:13];
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    contentLabel.numberOfLines = 2;
    contentLabel.textColor = [UIColor grayColor];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(infoV.width-17, infoV.height-17, 15, 15)];
    arrow.image = [UIImage imageNamed:@"next"];
    [infoV addSubview:whereButton];
    [infoV addSubview:timeLabel];
    [infoV addSubview:titleLabel];
    [infoV addSubview:line];
    [infoV addSubview:contentLabel];
    [infoV addSubview:arrow];
    
    
    [self addSubview:imageV];
    [self addSubview:infoV];
    
    return self;
}

@end
