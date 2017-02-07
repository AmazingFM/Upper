//
//  UPDropDownMenu.m
//  Upper
//
//  Created by 张永明 on 2017/2/7.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPDropDownMenu.h"

@implementation UPIndexPath

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row
{
    self = [super init];
    if (self) {
        _column = column;
        _leftOrRight = leftOrRight;
        _leftRow = leftRow;
        _row = row;
    }
    return self;
}

+ (instancetype)indexPathWithCol:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row
{
    UPIndexPath *indexPath = [[self alloc] initWithColumn:column leftOrRight:leftOrRight leftRow:leftRow row:row];
    return indexPath;
}

@end

@interface UPDropDownMenu()

@property (nonatomic, assign) NSInteger currentSelectedMenuIndex;
@property (nonatomic, assign) BOOL show;
@property (nonatomic, assign) NSInteger numOfMenu;
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) UIView *backGroundView;
@property (nonatomic, assign) UIView *bottomShadow;
@property (nonatomic, assign) UITableView *leftTableView;
@property (nonatomic, assign) UITableView *rightTableView;
@property (nonatomic, assign) UITableView *collectionView;

@property (nonatomic, copy) NSArray *array;

@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *indicators;
@property (nonatomic, copy) NSArray *bgLayers;
@property (nonatomic, assign) NSInteger leftSelectedRow;
@property (nonatomic, assign) BOOL hadSelected;

@end

@implementation UPDropDownMenu

- (UIColor *)indicatorColor
{
    if (!_indicatorColor) {
        _indicatorColor = [UIColor blackColor];
    }
    return _indicatorColor;
}

- (UIColor *)textColor
{
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (UIColor *)separatorColor
{
    if (!_separatorColor) {
        _separatorColor = [UIColor blackColor];
    }
    return _separatorColor;
}

- (NSString *)titleForRowAtIndexPath:(UPIndexPath *)indexPath
{
    return [self.dataSource menu:self titleForRowAtIndexPath:indexPath];
}

#pragma mark - setter
- (void)setDataSource:(id<UPDropDownMenuDataSource>)dataSource
{
    _dataSource = dataSource;
    
    if ([_dataSource respondsToSelector:@selector(numberOfColumnsInMenu:)]) {
        _numOfMenu = [_dataSource numberOfColumnsInMenu:self];
    } else {
        _numOfMenu = 1;
    }
}

@end
