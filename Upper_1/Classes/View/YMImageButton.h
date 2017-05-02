//
//  UpLeftButton.h
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMImageButton : UIButton
{
    CGFloat imageWidth;
}

@property (nonatomic, retain) UIImageView *imageV;
@property (nonatomic, retain) UILabel     *titleLab;

- (void)setImage:(UIImage *)image andTitle:(NSString *)title;
- (void)setTitleFont:(UIFont *)font;
- (void)setImageRound;
@end
