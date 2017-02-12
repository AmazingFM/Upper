//
//  CityButton.m
//  ChinaCityList
//
//  Created by zjq on 15/10/27.
//  Copyright © 2015年 zhengjq. All rights reserved.
//

#import "CityButton.h"
#import "Info.h"
#define IsNilOrNull(_ref) (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))
#define kCityItemViewTitleTextW 80
#define kCityItemViewTitleTextH 25
#define kCityItemViewTitleTextFont 15
@interface CityButton ()

@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) UILabel *titleName;

@end

@implementation CityButton

- (id)init
{
    
    if (self = [super init]) {
        // Custom initialization
        [self setBackgroundImage:[UIImage imageNamed:@"select_bg"] forState:UIControlStateSelected];
        [self setBackgroundImage:[UIImage imageNamed:@"unselect_bg"] forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        [self.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    
    UIView *container = [[UIView alloc] init];
    
    container.userInteractionEnabled = NO;
    container.backgroundColor = [UIColor clearColor];

    
    UILabel *titleName = [[UILabel alloc] init];
    titleName.font = [UIFont systemFontOfSize:kCityItemViewTitleTextFont];
    titleName.textColor = [UIColor whiteColor];
    titleName.textAlignment = NSTextAlignmentCenter;
    titleName.backgroundColor = [UIColor clearColor];
    titleName.numberOfLines = 1;
    titleName.adjustsFontSizeToFitWidth = YES;
    [container addSubview:titleName];
    
    self.titleName = titleName;
    
    [self addSubview:container];
    
    self.container = container;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    self.container.frame = CGRectMake(2, 0, self.frame.size.width-4, self.frame.size.height);
    self.titleName.frame = CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height);
}

- (void)setCityItem:(CityItem *)cityItem
{
    
    _cityItem = cityItem;
    
    if (!IsNilOrNull(_cityItem)) {
        self.titleName.text = _cityItem.cityInfo.city;
    }
}

@end
