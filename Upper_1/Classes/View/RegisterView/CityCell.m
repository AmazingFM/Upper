//
//  CityCell.m
//  Upper_1
//
//  Created by aries365.com on 16/1/28.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "CityCell.h"
#import "CityItem.h"
#import "Info.h"

@interface CityCell()

@end

@implementation CityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        _cityNameBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        
        //[_cityNameBtn setUserInteractionEnabled:NO];
        [_cityNameBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cityNameBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];
    _cityNameBtn.selected = selected;
}

- (void)setCityItem:(CityItem *)cityItem
{
    self.item = cityItem;
    _cityNameBtn.frame = CGRectMake(LeftRightPadding, TopDownPadding, cityItem.width-2*LeftRightPadding, cityItem.height-2*TopDownPadding);
    _cityNameBtn.layer.cornerRadius = 5.0f;
    _cityNameBtn.layer.masksToBounds = YES;
    [_cityNameBtn setTitle:cityItem.cityInfo.city forState:UIControlStateNormal];
    [_cityNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cityNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cityNameBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [_cityNameBtn setBackgroundImage:[UIImage imageNamed:@"select_bg"] forState:UIControlStateSelected];
    [_cityNameBtn setBackgroundImage:[UIImage imageNamed:@"unselect_bg"] forState:UIControlStateNormal];
    _cityNameBtn.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    _cityNameBtn.alpha = 0.8;
}

- (void)btnClicked:(UIButton *)btn
{
    //btn.selected = !btn.selected;
    NSLog(@"btnClick:%@",_item.cityInfo.city);

    if ([self.delegate respondsToSelector:@selector(cityCellSelected:didClickItem:)]) {
        [self.delegate cityCellSelected:self didClickItem:_item];
    }
}

@end
