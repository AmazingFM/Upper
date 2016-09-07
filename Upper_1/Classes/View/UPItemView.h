//
//  UPItemView.h
//  Upper
//
//  Created by freshment on 16/5/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    DateBtnType,
    AreaBtnType,
    ActType,
    LocationType,
    ActThemeType
}UPViewType;

@protocol UPItemViewDelegate <NSObject>

- (void)itemViewClick:(UPViewType)type withTag:(NSInteger)tag;

@end

@interface UPItemView : UIView
{
    UIView *_backView;
    UIImageView *_iconImg;
    UILabel *_descLabel;
}

@property (nonatomic, weak) UITextField *textField;
@property (nonatomic, retain) UIButton *infoBtn;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *valueStr;

@property (nonatomic) UPViewType type;

@property (nonatomic, weak) id<UPItemViewDelegate> delegate;

@end
