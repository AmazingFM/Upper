//
//  CityCell.h
//  Upper_1
//
//  Created by aries365.com on 16/1/28.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityCell;
@class CityItem;

@protocol CityCellDelegate <NSObject>

- (void)cityCellSelected:(CityCell *)cell didClickItem:(CityItem *)item;

@end

@interface CityCell : UITableViewCell
{
    UIButton *_cityNameBtn;
}

@property (nonatomic, retain) CityItem *item;
@property (nonatomic, weak) id<CityCellDelegate> delegate;
- (void)setCityItem:(CityItem *)cityItem;
@end
