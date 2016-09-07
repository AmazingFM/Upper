//
//  UPActivityCell.m
//  Upper
//
//  Created by 海通证券 on 16/5/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActivityCell.h"
#import "Info.h"
#import "UPTools.h"
#import "DrawSomething.h"
#import "UPTheme.h"

@interface UPTimeLocationView()
{
    UILabel *_timeLabel;
    UIButton *_locationButton;
}
@end

@implementation UPTimeLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = kUPThemeSmallFont;

        _locationButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        
        _locationButton.backgroundColor=[UIColor clearColor];
        _locationButton.titleLabel.textColor = [UIColor whiteColor];
        _locationButton.titleLabel.font = kUPThemeSmallFont;
        _locationButton.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [_locationButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_timeLabel];
        [self addSubview:_locationButton];
    }
    
    return self;
}

- (void)setTime:(NSString *)time andLocation:(NSString *)location
{
    float offsetX=0;
    CGSize size;
    _timeLabel.text = time;
    
    size = SizeWithFont(time, kUPThemeSmallFont);
    _timeLabel.frame = CGRectMake(offsetX, 0, size.width, self.frame.size.height);
    
    offsetX += size.width+5;
    
    [_locationButton setTitle:location forState:UIControlStateNormal];
    _locationButton.frame = CGRectMake(offsetX, 0, self.frame.size.width-offsetX, self.frame.size.height);
}

- (void)onClick:(UIButton *)sender
{
    
}

@end

@implementation UILabel (VerticalUpAlignment)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight
{
    CGRect frame = self.frame;
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(frame.size.width, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    frame.size = CGSizeMake(frame.size.width, rect.size.height);
    self.frame = frame;
    self.text = text;
}

@end


@interface UPActivityCell() <UIGestureRecognizerDelegate>
{
    UIView *backView;
    UIImageView *_img;
    UILabel *_titleLab;
    UILabel *_typeLab;
    UILabel *_clothLab;
    UILabel *_statusLab;
    UPTimeLocationView *_timeLocationV;
}

@end

@implementation UPActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = kUPThemeTitleFont;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;

        _img = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.font = kUPThemeSmallFont;
        _typeLab.backgroundColor = [UPTools colorWithHex:0x79CDCD];
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.layer.cornerRadius = 2.0f;
        _typeLab.layer.masksToBounds = YES;
        
        _clothLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _clothLab.font = kUPThemeSmallFont;
        _clothLab.backgroundColor = [UPTools colorWithHex:0x79CDCD];
        _clothLab.textAlignment = NSTextAlignmentCenter;
        _clothLab.layer.cornerRadius = 2.0f;
        _clothLab.layer.masksToBounds = YES;

        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLab.font = kUPThemeMinFont;
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textColor = [UIColor redColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.layer.cornerRadius = 2.0f;
        _statusLab.layer.masksToBounds = YES;

        _timeLocationV = [[UPTimeLocationView alloc] initWithFrame:CGRectZero];
        
        [backView addSubview:_img];
        [backView addSubview:_titleLab];
        [backView addSubview:_typeLab];
        [backView addSubview:_clothLab];
        [backView addSubview:_statusLab];
        [self addSubview:_timeLocationV];
    }
    return self;
}

- (void)setActivityItems:(UPBaseCellItem *)item
{
    _actCellItem = item;
    ActivityData *itemData = ((UPActivityCellItem*)item).itemData;
    
    
    backView.frame = CGRectMake(0, TopDownPadding, _actCellItem.cellWidth, _actCellItem.cellHeight-2*TopDownPadding);
    
    CGFloat width = backView.frame.size.width;
    CGFloat height = backView.frame.size.height;
    
    CGFloat offsetx=0;
    CGFloat offsety=0;
    
    _img.frame = CGRectMake(0, 0, height*4/3, height);
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.clipsToBounds = YES;
    [_img sd_setImageWithURL:[NSURL URLWithString:itemData.activity_image] placeholderImage:[UIImage imageNamed:@"me"]];
    _titleLab.text = itemData.activity_name;

    
    offsetx += height*4/3+kUPThemeBorder;
    
    _titleLab.frame = CGRectMake(offsetx,offsety,width-offsetx,30);
    
    offsety += _titleLab.height;
    
    CGFloat perHeight = (height-offsety)/3;
    
    CGSize size;
    NSArray*  actTypeArr = @[@"不限", @"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动",@"交友、徒步"];
    NSArray *actStatusArr = @[@"募集中", @"募集中", @"募集中", @"募集中", @"募集中", @"募集中", @"募集中", @"募集中", @"募集中"];
    NSArray *clothTypeArr = @[@"随性", @"西装领带", @"便装"];

    int selectIndex;
    selectIndex = [itemData.activity_class intValue];
    if (selectIndex<actTypeArr.count) {
        _typeLab.text = actTypeArr[selectIndex];
        size = SizeWithFont(actTypeArr[selectIndex], kUPThemeSmallFont);
        _typeLab.size = CGSizeMake(size.width+10, size.height+4);;
        _typeLab.center = CGPointMake(offsetx+size.width/2+5, offsety+perHeight/2);
    }
    
    selectIndex = [itemData.clothes_need intValue];
    if (selectIndex<clothTypeArr.count) {
        _clothLab.text = clothTypeArr[selectIndex];
        size = SizeWithFont(clothTypeArr[selectIndex], kUPThemeSmallFont);
        _clothLab.size = CGSizeMake(size.width+10, size.height+4);;
        _clothLab.center = CGPointMake(offsetx+size.width/2+5+_typeLab.size.width+kUPThemeBorder, offsety+perHeight/2);
    }
    
    offsety += perHeight;
    
    selectIndex = [itemData.activity_status intValue];
    if (selectIndex<actStatusArr.count) {
        _statusLab.text = actStatusArr[selectIndex];
        size = SizeWithFont(actStatusArr[selectIndex], kUPThemeMinFont);
        _statusLab.size = CGSizeMake(size.width+10, size.height+4);;
        _statusLab.center = CGPointMake(offsetx+size.width/2+5, offsety+perHeight/2);
        offsety += perHeight;
    }
    
    NSString *time = [UPTools dateStringTransform:itemData.begin_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy.MM.dd"];
    NSString *location = itemData.activity_place;
    NSString *mergeStr = [NSString stringWithFormat:@"%@AAA%@", time, location];
    
    size = SizeWithFont(mergeStr, kUPThemeSmallFont);
    _timeLocationV.size = CGSizeMake(size.width, size.height+4);
    _timeLocationV.center = CGPointMake(offsetx+size.width/2, offsety+perHeight/2);
    [_timeLocationV setTime:time andLocation:location];
}

- (void)onClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(onButtonSelected:)]) {
        [self.delegate onButtonSelected:_actCellItem];
    }
}

@end
