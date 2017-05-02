//
//  UpLeftButton.m
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "YMImageButton.h"

@implementation YMImageButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageWidth = frame.size.width;
        CGRect imgFrame = CGRectMake(0,0,frame.size.width, frame.size.height*2/3);
        self.imageV = [[UIImageView alloc] initWithFrame:imgFrame];
        self.imageV.contentMode = UIViewContentModeScaleAspectFit|UIViewContentModeCenter;
        self.imageV.backgroundColor = [UIColor clearColor];
        
        CGRect titleFrame = CGRectMake(0,frame.size.height*2/3+2, frame.size.width, frame.size.height/3-2);
        self.titleLab = [[UILabel alloc] initWithFrame:titleFrame];
        self.titleLab.font = [UIFont systemFontOfSize:8];
        self.titleLab.adjustsFontSizeToFitWidth = YES;
        self.titleLab.textColor = [UIColor whiteColor];
        self.titleLab.textAlignment = NSTextAlignmentCenter;
        self.titleLab.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.imageV];
        [self addSubview:self.titleLab];
    }
    return self;
}

- (void)setImage:(UIImage *)image andTitle:(NSString *)title
{
    self.imageV.image = image;
    self.titleLab.text = title;
}

- (void)setImageRound
{
    self.imageV.layer.cornerRadius = imageWidth/2;
    self.imageV.layer.masksToBounds = YES;
}

- (void)setTitleFont:(UIFont *)font
{
    self.titleLab.font = font;
}

@end
