//
//  HTScrollCell.h
//  Upper
//
//  Created by 张永明 on 2017/3/21.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTImageButton : UIControl{
    UIImageView* _imageView;
}
-(void)setImage:(UIImage*)image;
-(void)setImageURL:(NSString*)url;
-(void)setImageURL:(NSString*)url withHoldplacer:(UIImage*)holdImage;

-(void)setSDImage:(UIImage *)image;
-(void)setSDImageURL:(NSString*)url;
-(void)setSDImageURL:(NSString*)url withHoldplacer:(UIImage*)holdImage;
@end

@interface HTImageTitleButton : HTImageButton
-(void)setTitle:(NSString*)title;
-(void)setTitleFrame:(CGRect)titleFrame imgFrame:(CGRect)imgFrame;
-(void)setTitleColor:(UIColor*)color;
@end


@interface HTConfigItem : NSObject
@property (nonatomic,copy  ) NSString  *itemID;

@property (nonatomic, retain) NSString *title;
-(instancetype)initWithDict:(NSDictionary*)jsonDict;
@end

@interface HTConfigCollectItem : HTConfigItem
@property (nonatomic, retain) NSMutableArray *subItems;
@end

@interface HTConfigInfoItem : HTConfigItem
@property (nonatomic, retain) NSString *localImage;
@end


@protocol HTConfigCellDelegate <NSObject>
-(void)configItemSelected:(HTConfigItem*)item;
@optional
-(void)itemSelectedWithUrl:(NSString *)url title:(NSString *)title;
@end




#define kScrollCellBorder 10
#define kImageButtonWidth (ScreenWidth-kScrollCellBorder*4)/3
#define kImageButtonHeight kImageButtonWidth*kImageRatio+20

@interface HTScrollCell : UITableViewCell
@property (nonatomic, retain) HTConfigItem* configItem;
@property (nonatomic,weak)id<HTConfigCellDelegate> delegate;
-(void)setConfigItem:(HTConfigItem *)configItem;
@end
