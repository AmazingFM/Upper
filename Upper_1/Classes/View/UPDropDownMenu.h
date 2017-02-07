//
//  UPDropDownMenu.h
//  Upper
//
//  Created by 张永明 on 2017/2/7.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger leftOrRight;
@property (nonatomic, assign) NSInteger leftRow;
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end

@class UPDropDownMenu;

@protocol UPDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(UPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(UPDropDownMenu *)menu titleForRowAtIndexPath:(UPIndexPath *)indexPath;
- (NSString *)menu:(UPDropDownMenu *)menu titleForColumn:(NSInteger)column;

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
- (NSInteger)numberOfColumnsInMenu:(UPDropDownMenu *)menu;
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

@protocol UPDropDownMenuDelegate <NSObject>

@optional
- (void)menu:(UPDropDownMenu *)menu didSelectRowAtIndexPath:(UPIndexPath *)indexPath;

@end

@interface UPDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <UPDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <UPDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;

- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (NSString *)titleForRowAtIndexPath:(UPIndexPath *)indexPath;

@end
