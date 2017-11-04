//
//  UpActDetailController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UpActDetailController.h"
#import "QRCodeController.h"
#import "UPCommentController.h"
#import "MainController.h"
#import "Info.h"
#import "UPTheme.h"
#import "UPDataManager.h"
#import "ZouMaDengView.h"
#import "MBProgressHUD+MJ.h"
#import "EnrollPeopleController.h"
#import "UPActivityCell.h"
#import "UPTools.h"
#import "DrawSomething.h"
#import "UPConfig.h"
#import "NewLaunchActivityController.h"
#import "UPFriendListController.h"
#import "UPCustomAlertView.h"
#import "MessageManager.h"
#import "UPTipOffView.h"
#import "CRNavigationController.h"
#import "CRNavigationBar.h"
#import "YMNetwork.h"
#import "WXApiManager.h"

#define kUPButtonTagJuBao       100
#define kUPButtonTagYaoqing     101
#define kUPButtonTagFenXiang    102
#define kUPButtonTagBlock       103

@implementation UPDetailImageCellItem
@end

@implementation UPDetailTitleInfoCellItem
@end

@implementation UPDetailPeopleInfoCellItem
-(NSMutableArray *)userIconUrlList
{
    if (_userIconUrlList==nil) {
        _userIconUrlList = [[NSMutableArray alloc] init];
    }
    return _userIconUrlList;
}
@end

@implementation UPDetailExtraInfoCellItem
@end

@implementation UPDetailButtonCellItem
@end

@implementation UPDetailReviewInfoCellItem
- (NSMutableArray *)reviewImageUrls
{
    if (_reviewImageUrls==nil) {
        _reviewImageUrls = [NSMutableArray new];
    }
    return _reviewImageUrls;
}
@end
//------cell
@interface UPDetailImageCell()
{
    UIView *backView;
    UIView *userBackView;
}

@end

@implementation UPDetailImageCell
//@property (nonatomic, retain) UIImageView *activityImage;
//@property (nonatomic, retain) UIImageView *userIconImage;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        
        self.activityImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.activityImage.contentMode = UIViewContentModeScaleToFill;
        self.activityImage.backgroundColor = [UIColor clearColor];
        self.activityImage.layer.cornerRadius = 5.f;
        self.activityImage.layer.masksToBounds = YES;
        
        userBackView = [[UIView alloc] initWithFrame:CGRectZero];
        userBackView.backgroundColor = [UIColor whiteColor];
        userBackView.layer.borderColor = kUPThemeLineColor.CGColor;
        userBackView.layer.borderWidth = 1;
        userBackView.layer.cornerRadius = 5.f;
        
        
        self.userIconImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.userIconImage.contentMode = UIViewContentModeScaleAspectFit;
        self.userIconImage.backgroundColor = [UIColor clearColor];
        
        self.userNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.userNameLabel.font = kUPThemeMiniFont;
        self.userNameLabel.textColor = [UIColor blackColor];
        self.userNameLabel.textAlignment = NSTextAlignmentLeft;

        [self addSubview: backView];
        [backView addSubview:self.activityImage];
        [backView addSubview:userBackView];
        [userBackView addSubview:self.userIconImage];
        [userBackView addSubview:self.userNameLabel];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPDetailImageCellItem *cellItem = (UPDetailImageCellItem *)item;
    
    CGFloat offsetx = 10;
    CGFloat offsety = 10;
    
    backView.frame = CGRectMake(offsetx, offsety, cellItem.cellWidth-2*offsetx, cellItem.cellHeight-offsety);
    CGFloat backWidth = backView.width;
    CGFloat backHeight = backView.height;
    
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:cellItem.imageUrl] placeholderImage:[UIImage imageNamed:cellItem.imageDefault]];
    self.activityImage.frame = CGRectMake(0, 0, backWidth, backHeight-5);
    
    float width =(ScreenWidth==320?100:125);
    userBackView.frame = CGRectMake(backWidth-20-width, self.activityImage.height-25, width, 30);
    
    [self.userIconImage sd_setImageWithURL:[NSURL URLWithString:cellItem.userIconUrl] placeholderImage:[UIImage imageNamed:cellItem.userIconDefault] options:SDWebImageRefreshCached];
    self.userIconImage.frame = CGRectMake(5, 2, 26, 26);
    self.userIconImage.layer.cornerRadius = 13;
    self.userIconImage.layer.masksToBounds = YES;
    
    self.userNameLabel.frame = CGRectMake(10+26, 0, width-(36), 30);
    self.userNameLabel.text = cellItem.userName;
    
    //(ScreenWidth-2*10)*3/4+10+5
}
@end

@interface UPDetailTitleInfoCell()
{
    UIView *backView;
    UIView *infoBackView;
}
@end
@implementation UPDetailTitleInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = kUPThemeSmallFont;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.textColor = RGBCOLOR(0, 0, 0);
        
        infoBackView = [[UIView alloc] initWithFrame:CGRectZero];
        infoBackView.backgroundColor = RGBCOLOR(240, 240, 240);
        
        self.cityNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.cityNameLabel.font = kUPThemeMinFont;
        self.cityNameLabel.backgroundColor = [UIColor clearColor];
        self.cityNameLabel.textAlignment = NSTextAlignmentLeft;
        self.cityNameLabel.textColor = RGBCOLOR(160, 160, 160);
        self.cityNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.startTimeLabel.font = kUPThemeMinFont;
        self.startTimeLabel.backgroundColor = [UIColor clearColor];
        self.startTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.startTimeLabel.textColor = RGBCOLOR(160, 160, 160);
        
        self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.endTimeLabel.font = kUPThemeMinFont;
        self.endTimeLabel.backgroundColor = [UIColor clearColor];
        self.endTimeLabel.textAlignment = NSTextAlignmentLeft;
        self.endTimeLabel.textColor = RGBCOLOR(160, 160, 160);
        
        self.payTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.payTypeNameLabel.font = kUPThemeMinFont;
        self.payTypeNameLabel.backgroundColor = [UIColor clearColor];
        self.payTypeNameLabel.textAlignment = NSTextAlignmentLeft;
        self.payTypeNameLabel.textColor = RGBCOLOR(160, 160, 160);
        
        self.payFeeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.payFeeLabel.font = kUPThemeMinFont;
        self.payFeeLabel.backgroundColor = [UIColor clearColor];
        self.payFeeLabel.textAlignment = NSTextAlignmentLeft;
        self.payFeeLabel.textColor = RGBCOLOR(160, 160, 160);
        
        [self addSubview:backView];
        [backView addSubview:self.titleLabel];
        [backView addSubview:infoBackView];
        [infoBackView addSubview:self.cityNameLabel];
        [infoBackView addSubview:self.startTimeLabel];
        [infoBackView addSubview:self.endTimeLabel];
        [infoBackView addSubview:self.payTypeNameLabel];
        [infoBackView addSubview:self.payFeeLabel];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPDetailTitleInfoCellItem *cellItem = (UPDetailTitleInfoCellItem*)item;
    
    CGFloat offsetx = 10;
    CGFloat offsety = 5;
    
    backView.frame = CGRectMake(offsetx, 0, cellItem.cellWidth-2*offsetx, cellItem.cellHeight);
    CGFloat backWidth = backView.width;

    self.titleLabel.frame = CGRectMake(offsetx, offsety, backWidth-offsetx, 30);
    self.titleLabel.text = cellItem.title;
    
    offsety+=30;
    CGSize size = SizeWithFont(@"活动时间", kUPThemeMinFont);
    CGFloat backViewWidth = backWidth-2*offsetx;
    CGFloat backViewHeight = 5*4+size.height*3;
    infoBackView.frame = CGRectMake(offsetx, offsety, backViewWidth, backViewHeight);
    
    offsety=5;
    self.cityNameLabel.frame = CGRectMake(offsetx, offsety, backViewWidth/3, size.height);
    self.cityNameLabel.text = cellItem.cityName;
    
    offsetx += self.cityNameLabel.width;
    self.startTimeLabel.frame = CGRectMake(offsetx+5, offsety, backViewWidth-offsetx, size.height);
    self.startTimeLabel.text = cellItem.startTime;

    offsetx = 10;
    offsety+=5+self.cityNameLabel.height;
    self.endTimeLabel.frame = CGRectMake(offsetx, offsety, backViewWidth-offsetx, size.height);
    self.endTimeLabel.text = [NSString stringWithFormat:@"报名截止:%@", cellItem.endTime];
    
    offsety+=5+self.endTimeLabel.height;
    self.payTypeNameLabel.frame = CGRectMake(offsetx, offsety, backViewWidth/2, size.height);
    self.payTypeNameLabel.text = [NSString stringWithFormat:@"付费方式:%@", cellItem.payTypeName];
    
    if (cellItem.payFee.length>0) {
        offsetx +=backViewWidth/2+5;
        self.payFeeLabel.frame = CGRectMake(offsetx, offsety, backViewWidth-offsetx, size.height);
        self.payFeeLabel.text = [NSString stringWithFormat:@"预估费用:%@/人", cellItem.payFee];

    }
    
    //5+30+5*4+size.height*3+5
}
@end

#define kUPDetailPeopleInfoCellTag 100
@interface UPDetailPeopleInfoCell()
{
    UIView *backView;
}

@end
@implementation UPDetailPeopleInfoCell
//@property (nonatomic, retain) UIButton *infoButton;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        
        self.infoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.infoButton.titleLabel.font = kUPThemeMinFont;
        self.infoButton.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.infoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.infoButton.backgroundColor = [UIColor clearColor];
        [self.infoButton setTitleColor:[UPTools colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
        [self.infoButton setImage:[UIImage imageNamed:@"icon-user"] forState:UIControlStateNormal];
        
        [self addSubview:backView];
        [backView addSubview:self.infoButton];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPDetailPeopleInfoCellItem *cellItem = (UPDetailPeopleInfoCellItem *)item;
    
    
    CGFloat offsetx = 10;
    CGFloat offsety = 0;
    
    backView.frame = CGRectMake(offsetx, 0, cellItem.cellWidth-2*offsetx, cellItem.cellHeight);
    CGFloat backWidth = backView.width;
    
    self.infoButton.frame = CGRectMake(offsetx, offsety, backWidth-2*offsetx, 15);
    NSString *btnStr = [NSString stringWithFormat:@"%@/%@", cellItem.currentNum, cellItem.totalNum];
    [self.infoButton setTitle:btnStr forState:UIControlStateNormal];
    
    offsety = 15;
    
    if (cellItem.userIconUrlList.count>0) {
        for (int i=0; i<cellItem.userIconUrlList.count; i++) {
            NSDictionary *userDict = cellItem.userIconUrlList[i];
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(offsetx, offsety+2, 26, 26)];
            icon.backgroundColor = [UIColor grayColor];
            icon.layer.cornerRadius = 13;
            icon.layer.masksToBounds = YES;
            icon.tag = i+kUPDetailPeopleInfoCellTag;
            [icon sd_setImageWithURL:userDict[@"user_icon"] placeholderImage:nil options:SDWebImageRefreshCached];
            [backView addSubview:icon];
            
            offsetx += 30;
        }
    }
    //15+30
}

@end

@interface UPDetailExtraInfoCell()
{
    UIView *backView;
    UIView *infoBackView;
}

@end
@implementation UPDetailExtraInfoCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descLabel.font = kUPThemeSmallFont;
        self.descLabel.backgroundColor = [UIColor clearColor];
        self.descLabel.textAlignment = NSTextAlignmentLeft;
        self.descLabel.numberOfLines = 0;
        self.descLabel.textColor = RGBCOLOR(0, 0, 0);
        
        infoBackView = [[UIView alloc] initWithFrame:CGRectZero];
        infoBackView.backgroundColor = RGBCOLOR(240, 240, 240);
        
        self.placeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.placeLabel.font = kUPThemeMinFont;
        self.placeLabel.backgroundColor = [UIColor clearColor];
        self.placeLabel.textAlignment = NSTextAlignmentLeft;
        self.placeLabel.textColor = RGBCOLOR(160, 160, 160);
        self.placeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.shopNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.shopNameLabel.font = kUPThemeMinFont;
        self.shopNameLabel.backgroundColor = [UIColor clearColor];
        self.shopNameLabel.textAlignment = NSTextAlignmentLeft;
        self.shopNameLabel.textColor = RGBCOLOR(160, 160, 160);
        
        self.activityTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.activityTypeNameLabel.font = kUPThemeMinFont;
        self.activityTypeNameLabel.backgroundColor = [UIColor clearColor];
        self.activityTypeNameLabel.textAlignment = NSTextAlignmentLeft;
        self.activityTypeNameLabel.textColor = RGBCOLOR(160, 160, 160);
        
        self.clothTypeNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.clothTypeNameLabel.font = kUPThemeMinFont;
        self.clothTypeNameLabel.backgroundColor = [UIColor clearColor];
        self.clothTypeNameLabel.textAlignment = NSTextAlignmentLeft;
        self.clothTypeNameLabel.textColor = RGBCOLOR(160, 160, 160);
        
        [self addSubview:backView];
        [backView addSubview:self.descLabel];
        [backView addSubview:infoBackView];
        [infoBackView addSubview:self.placeLabel];
        [infoBackView addSubview:self.shopNameLabel];
        [infoBackView addSubview:self.activityTypeNameLabel];
        [infoBackView addSubview:self.clothTypeNameLabel];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPDetailExtraInfoCellItem *cellItem = (UPDetailExtraInfoCellItem *)item;
    
    CGFloat offsetx = 10;
    CGFloat offsety = 5;
    
    backView.frame = CGRectMake(offsetx, 0, cellItem.cellWidth-2*offsetx, cellItem.cellHeight);
    CGFloat backWidth = backView.width;

    CGSize size;
    if (cellItem.desc.length==0) {
        cellItem.desc = @"该活动没有描述";
    }
    
    size = [UPTools sizeOfString:cellItem.desc withWidth:backWidth-2*offsetx font:kUPThemeSmallFont];
    
    self.descLabel.frame = CGRectMake(offsetx, offsety, backWidth-2*offsetx, ceil(size.height));
    self.descLabel.text = cellItem.desc;
    
    offsety+=self.descLabel.height+5;
    size = SizeWithFont(@"商户名称", kUPThemeMinFont);
    CGFloat backViewWidth = backWidth-2*offsetx;
    CGFloat backViewHeight = 5*4+size.height*3;
    infoBackView.frame = CGRectMake(offsetx, offsety, backViewWidth, backViewHeight);
    
    offsety=5;
    self.placeLabel.frame = CGRectMake(offsetx, offsety, backViewWidth-2*offsetx, size.height);
    self.placeLabel.text = [NSString stringWithFormat:@"地址:%@", cellItem.place];
    
    offsety+=5+self.placeLabel.height;
    self.shopNameLabel.frame = CGRectMake(offsetx, offsety, backViewWidth-2*offsetx, size.height);
    self.shopNameLabel.text = [NSString stringWithFormat:@"商户名称:%@", cellItem.shopName];
    
    offsety+=5+self.shopNameLabel.height;
    self.activityTypeNameLabel.frame = CGRectMake(offsetx, offsety, backViewWidth/2, size.height);
    self.activityTypeNameLabel.text = [NSString stringWithFormat:@"类型:%@", cellItem.activityTypeName];
    
    
    offsetx +=backViewWidth/2+5;
        self.clothTypeNameLabel.frame = CGRectMake(offsetx, offsety, backViewWidth-offsetx, size.height);
        self.clothTypeNameLabel.text = [NSString stringWithFormat:@"着装风格:%@", cellItem.clothTypeName];

    ////5+(desc.height)+5+5*4+size.height*3+5
}

@end

@implementation UPDetailButtonCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        self.button.titleLabel.font = kUPThemeSmallFont;
        self.button.backgroundColor = kUPThemeMainColor;
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPDetailButtonCellItem *cellItem = (UPDetailButtonCellItem *)item;
    
    CGFloat offsetx = 10;
    self.button.frame = CGRectMake(offsetx, 0, cellItem.cellWidth-2*offsetx, cellItem.cellHeight);
    [self.button setTitle:cellItem.title forState:UIControlStateNormal];
}

@end

@interface UPDetailReviewInfoCell()
{
    UIView *backView;
    UIView *lineView;
    UILabel *titleLabel;
}

@end

#define kUPDetailReviewImageTag 100
@implementation UPDetailReviewInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];

        lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = RGBCOLOR(160, 160, 160);
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = kUPThemeSmallFont;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = RGBCOLOR(160, 160, 160);
        titleLabel.text = @"活动回顾";
        
        self.reviewLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.reviewLabel.font = kUPThemeSmallFont;
        self.reviewLabel.backgroundColor = [UIColor clearColor];
        self.reviewLabel.textAlignment = NSTextAlignmentLeft;
        self.reviewLabel.textColor = RGBCOLOR(160, 160, 160);
        self.reviewLabel.numberOfLines =0;
        
        [self addSubview:backView];
        [backView addSubview:lineView];
        [backView addSubview:titleLabel];
        [backView addSubview:self.reviewLabel];
        
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (NSMutableArray *)reviewImages
{
    if (_reviewImages==nil) {
        _reviewImages = [NSMutableArray new];
    }
    return _reviewImages;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem: item];
    UPDetailReviewInfoCellItem *reviewInfoItem = (UPDetailReviewInfoCellItem *)item;
    
    CGFloat offsetx = 10;
    CGFloat offsety = 0;
    
    backView.frame = CGRectMake(offsetx, 0, reviewInfoItem.cellWidth-2*offsetx, reviewInfoItem.cellHeight);
    CGFloat backWidth = backView.width;

    lineView.frame = CGRectMake(0, 14.5, backWidth, 1);
    titleLabel.frame = CGRectMake((backWidth-100)/2, 0, 100, 30);
    
    offsety +=30;
    float imageWidth = 75;
    if (reviewInfoItem.reviewImageUrls.count>0) {
        for (int i=0; i<reviewInfoItem.reviewImageUrls.count; i++) {
            UIImageView *imageView = [self viewWithTag:kUPDetailReviewImageTag+i];
            if (imageView==nil) {
                imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
                imageView.layer.borderColor = RGBCOLOR(160, 160, 160).CGColor;
                imageView.layer.borderWidth = 0.2;
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.tag = kUPDetailReviewImageTag+i;
                [backView addSubview:imageView];
            }
            offsetx += i*(imageWidth+10);
            imageView.frame = CGRectMake(offsetx, offsety, imageWidth, imageWidth);
            [imageView sd_setImageWithURL:[NSURL URLWithString:reviewInfoItem.reviewImageUrls[i]]];
        }
        offsety += 80;
    }
    
    offsetx = 10;
    
    if (reviewInfoItem.reviewText.length!=0) {
        NSString *reviewText = reviewInfoItem.reviewText;
        self.reviewLabel.frame = CGRectMake(offsetx, offsety, backWidth-2*offsetx,reviewInfoItem.cellHeight-offsety );
        self.reviewLabel.text = reviewText;
    }
}
@end


#define LabelHeight 17
#define AlertTagEdit    0
#define AlertTagCancel  1
#define AlertTagBlock   2

@interface UpActDetailController () <UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UPFriendListDelegate,UPCustomAlertViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
    UIButton *_submitBtn;
    NSMutableArray *_itemList;
}

@end

@implementation UpActDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _itemList = [NSMutableArray new];
    
    UPDetailImageCellItem *imageItem = [[UPDetailImageCellItem alloc] init];
    UPDetailTitleInfoCellItem *infoItem = [[UPDetailTitleInfoCellItem alloc] init];
    UPDetailPeopleInfoCellItem *peopleItem = [[UPDetailPeopleInfoCellItem alloc] init];
    UPDetailExtraInfoCellItem *extraItem = [[UPDetailExtraInfoCellItem alloc] init];
    UPBaseCellItem *extraBtnItem = [[UPBaseCellItem alloc] init];
    UPDetailReviewInfoCellItem *reviewInfoItem = [[UPDetailReviewInfoCellItem alloc] init];
    
    [_itemList addObject:imageItem];
    [_itemList addObject:infoItem];
    [_itemList addObject:peopleItem];
    [_itemList addObject:extraItem];
    [_itemList addObject:extraBtnItem];
    [_itemList addObject:reviewInfoItem];
    
    for (UPBaseCellItem *item in _itemList) {
        item.cellHeight = 0;
        item.cellWidth = ScreenWidth;
    }
    
    self.title = @"活动详情";

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight,ScreenWidth, ScreenHeight-FirstLabelHeight-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGBCOLOR(240, 240, 240);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(0, ScreenHeight-44, ScreenWidth, 44);
    _submitBtn.backgroundColor = kUPThemeMainColor;
    [_submitBtn setTitle:@"我要报名" forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = kUPThemeSmallFont;
    [_submitBtn addTarget:self action:@selector(joinActivity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    [self getActivityDetailInfo:self.actData.ID];
    
    if (self.sourceType==SourceTypeWoFaqi) {
        UIButton *addFriendButton=[UIButton buttonWithType:UIButtonTypeCustom];
        addFriendButton.tag = kUPButtonTagYaoqing;
        addFriendButton.frame=CGRectMake(0, 0, 35, 35);
        UIImage *image = [UIImage imageNamed:@"add"];
        UIImage *stretchableButtonImage = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
        [addFriendButton setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
        [addFriendButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:addFriendButton];
    }
}

- (void)reloadItems
{
    if (self.detailActData) {
        UPDetailImageCellItem *imageItem = _itemList[0];
        imageItem.key = @"ActivityImage";
        imageItem.imageUrl = self.detailActData.activity_image;
        imageItem.imageDefault = @"";
        imageItem.userIconUrl = self.detailActData.user_icon;
        imageItem.userIconDefault = @"activity_user_icon";
        imageItem.userName = self.detailActData.nick_name;
        imageItem.cellHeight = (int)((ScreenWidth-2*10)*3/4+10+5)+1;

        
        UPDetailTitleInfoCellItem *infoItem = _itemList[1];
        infoItem.key = @"ActivityInfo";
        infoItem.title = self.detailActData.activity_name;
        infoItem.cityName = self.detailActData.city;
        infoItem.startTime = [UPTools dateTransform:self.detailActData.start_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy年MM月dd日"];
        infoItem.endTime = [UPTools dateTransform:self.detailActData.end_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy年MM月dd日"];
        infoItem.payTypeName = [[UPConfig sharedInstance] getPayTypeByID:self.detailActData.is_prepaid].name;
        infoItem.payFee = self.detailActData.activity_fee;
        CGSize size = SizeWithFont(@"活动时间", kUPThemeMinFont);
        infoItem.cellHeight = (int)(5+30+5*4+size.height*3+5)+1;
        
        UPDetailPeopleInfoCellItem *peopleItem = _itemList[2];
        peopleItem.key = @"ActivityPeople";
        peopleItem.currentNum = self.detailActData.part_count;
        peopleItem.totalNum = self.detailActData.limit_count;
        peopleItem.cellHeight = 15;
        if (self.detailActData.join_list.count>0) {
            [peopleItem.userIconUrlList removeAllObjects];
            [peopleItem.userIconUrlList addObjectsFromArray:self.detailActData.join_list];
            peopleItem.cellHeight+=30;
        }
        
        UPDetailExtraInfoCellItem *extraItem = _itemList[3];
        extraItem.key = @"extraInfo";
        extraItem.desc = self.detailActData.activity_desc;
        extraItem.place = self.detailActData.activity_addr;
        extraItem.shopName = self.detailActData.activity_place;//[[UPConfig sharedInstance] getPlaceTypeByID:[@(actId) stringValue]].name;
        extraItem.activityTypeName = [[UPConfig sharedInstance] getActivityTypeByID:self.detailActData.activity_class].name;
        extraItem.clothTypeName = [[UPConfig sharedInstance] getClothTypeByID:self.detailActData.clothes_need].name;

        if (extraItem.desc.length==0) {
            extraItem.desc = @"该活动没有描述";
        }
        size = [UPTools sizeOfString:extraItem.desc withWidth:ScreenWidth-40 font:kUPThemeSmallFont];
        float height = ceil(size.height);

        size = SizeWithFont(@"商户名称", kUPThemeMinFont);
        extraItem.cellHeight = (int)(5+height+5+5*4+size.height*3+5)+1;
        
        UPBaseCellItem *extraBtnItem = _itemList[4];
        extraBtnItem.cellHeight = 40;
        extraBtnItem.key = @"extraButton";
        
        [_tableView reloadData];
        
        NSString *btnTitle = [NSString stringWithFormat:@"活动还差%d人，我要参加", [self.detailActData.limit_count intValue]-[self.detailActData.part_count intValue]];
        [_submitBtn setTitle:btnTitle forState:UIControlStateNormal];
    }
}

- (void)reloadReviewCellItem:(NSDictionary *)evaluateInfoDict
{
    UPDetailReviewInfoCellItem *reviewInfoItem = _itemList[5];
    reviewInfoItem.reviewText = evaluateInfoDict[@"evaluate_text"];
    
    NSString *image1Url = evaluateInfoDict[@"image_1"];
    NSString *image2Url = evaluateInfoDict[@"image_2"];
    NSString *image3Url = evaluateInfoDict[@"image_3"];
    
    [reviewInfoItem.reviewImageUrls removeAllObjects];
    if (image1Url.length>0) {
        [reviewInfoItem.reviewImageUrls addObject:image1Url];
    }
    if (image2Url.length>0) {
        [reviewInfoItem.reviewImageUrls addObject:image2Url];
    }
    if (image3Url.length>0) {
        [reviewInfoItem.reviewImageUrls addObject:image3Url];
    }
    float height = 30+(reviewInfoItem.reviewImageUrls.count>0?80:0);
    
    CGSize size=[UPTools sizeOfString:reviewInfoItem.reviewText withWidth:ScreenWidth-40 font:kUPThemeSmallFont];
    reviewInfoItem.cellHeight = height+size.height+5;
    
    [_tableView reloadData];
}

- (void)blockThisUser
{
    NSString *relation_id = self.detailActData.user_id;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"FriendsWhiteBlack"forKey:@"a"];
    [params setObject:relation_id forKey:@"relation_id"];
    [params setObject:@"9" forKey:@"group"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            [MBProgressHUD showSuccess:resp_desc];
            [self refreshMainController];
        }
    } failure:^(NSError *error) {
        //
    }];
}

- (void)refreshMainController
{
    if (self.preController&&[self.preController isKindOfClass:[MainController class]]) {
        MainController *mainController = (MainController *)self.preController;
        [mainController refresh];
    }
}

- (void)getReviewInfo:(NSString *)activityId
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityEvaluateQuery"forKey:@"a"];
    [params setObject:@"10" forKey:@"page_size"];
    [params setObject:@"1" forKey:@"current_page"];
    [params setObject:activityId forKey:@"activity_id"];
    [params setObject:@"0" forKey:@"type"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            NSArray *evaluateList = resp_data[@"evaluate_list"];
            if (evaluateList !=nil && [evaluateList isKindOfClass:[NSArray class]]) {
                if (evaluateList.count>0) {
                    NSDictionary *evaluateInfoDict = evaluateList[0];
                    [self reloadReviewCellItem:evaluateInfoDict];
                }
            }

        }
    } failure:^(NSError *error) {
        //
    }];
}

- (void)getActivityDetailInfo:(NSString *)activityId
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityInfo"forKey:@"a"];
    [params setObject:activityId forKey:@"activity_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *respData = dict[@"resp_data"];
            self.detailActData = [[ActivityData alloc] initWithDict:respData];
            
            [self.detailActData.join_list removeAllObjects];
            
            NSDictionary *meDict = @{@"user_id":self.detailActData.user_id, @"nick_name":self.detailActData.nick_name, @"user_icon":self.detailActData.user_icon};
            [self.detailActData.join_list addObject:meDict];
            
            if (respData[@"join_list"]!=nil) {
                NSArray *join_list = respData[@"join_list"];
                if (join_list.count>0) {
                    [self.detailActData.join_list addObjectsFromArray:join_list];
                }
            }
            [self reloadItems];
            [self getReviewInfo:self.detailActData.ID];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        
    } failure:^(id error) {
        NSLog(@"%@",error);
    }];
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag==kUPButtonTagBlock) {
        showConfirmTagAlert(@"提示", @"屏蔽该用户发起的所有活动", self, AlertTagBlock);
    } else if (sender.tag==kUPButtonTagJuBao) {
        UPTipOffView *tipoffView = [[UPTipOffView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-100, 70)];
        UPCustomAlertView *jbAlert = [[UPCustomAlertView alloc] initWithTitle:@"我要举报" CustomView:tipoffView];
        jbAlert.delegate = self;
        [jbAlert show];
    } else if (sender.tag==kUPButtonTagYaoqing) {
        UPFriendListController *inviteFriend = [[UPFriendListController alloc] init];
        inviteFriend.type = 0; //我的好友列表
        inviteFriend.delegate = self;
        CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:inviteFriend];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (sender.tag==kUPButtonTagFenXiang) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给朋友", @"分享到朋友圈", nil];
        [actionSheet showInView:self.view];
    }
}

#pragma mark UPCustomAlertViewDelegate
- (void)customAlertView:(UPCustomAlertView *)alertView buttonClickedWithIndex:(NSInteger)index
{
    UPTipOffView *tipoffView = (UPTipOffView *)alertView.customView;
    if (tipoffView) {
        NSString *tipoffStr = [tipoffView getTipOffDesc];
        if (tipoffStr!=nil) {
            [self sendTipOff:tipoffStr];
        }
    }
}

- (void)sendTipOff:(NSString *)tipoffStr
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"TipOff" forKey:@"a"];
    [params setValue:self.actData.ID forKey:@"relation_id"];
    [params setValue:tipoffStr forKey:@"tip_reason"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            [MBProgressHUD showSuccess:@"提交举报信息成功"];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"提交失败，请重新提交"];
    }];
}

#pragma mark UPInviteFriendDelegate
- (void)inviteFriends:(NSArray *)friendId
{
    if (friendId.count==0) {
        return;
    }
    [self sendInvitation:friendId];
}

- (void)sendInvitation:(NSArray *)friendIds
{
    __block int count = 0;
    
    //activity_name-活动名称,activity_class-活动类型, start_time-活动开始时间，ID-活动id，nick_name-发起人昵称
    NSDictionary *actDataDict = @{@"activity_name":self.actData.activity_name,@"activity_class":self.actData.activity_class,@"start_time":self.actData.start_time,@"id":self.actData.ID, @"nick_name":self.actData.nick_name};
    
    NSString *msgDesc = [UPTools stringFromJSON:actDataDict];
    
    for (NSString *to_id in friendIds) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:@"MessageSend" forKey:@"a"];
        [params setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
        [params setValue:to_id forKey:@"to_id"];
        
        UPServerMsgType msgType = ServerMsgTypeInviteFriend;
        [params setValue:[@(msgType) stringValue] forKey:@"message_type"];
        [params setValue:msgDesc forKey:@"message_desc"];
        [params setValue:@"" forKey:@"expire_time"];
        
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"MessageSend, %@", dict);
            NSString *resp_id = dict[@"resp_id"];
            if ([resp_id intValue]==0) {
                [MBProgressHUD showSuccess:@"已发送邀请给对方"];
                count++;
            } else {
                count++;
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"发送消息失败，请重新操作"];
            count++;
        }];
    }
}

- (void)modifyActiviy:(RequestType)type
{
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:self.view];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityJoinModify"forKey:@"a"];
    [params setObject:self.actData.ID forKey:@"activity_id"];
    
    NSString *userStatus;
    if (type==ActivityQuit) {
        userStatus = @"2";
    } else if (type==ActivityComment) {
        userStatus = @"5";
    }
    [params setObject:userStatus forKey:@"user_status"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)cancelActivity
{
    
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityModify"forKey:@"a"];
    [params setObject:self.actData.ID forKey:@"activity_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)joinActivity
{
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityJoin"forKey:@"a"];
    [params setObject:self.actData.ID forKey:@"activity_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            showDefaultAlert(@"提示", @"活动报名成功，如果参与意向有变，请点击活动规则查看相关规则和操作方式。");
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",error);
        
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actId = self.actData.ID;
    
    NSData *actIdData = [actId dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [actIdData base64EncodedStringWithOptions:0];
    
    NSString *md5Str = [UPTools md5HexDigest:[NSString stringWithFormat:@"%@upperinterface", actId]];
    NSString *shareLinkUrl = [NSString stringWithFormat:@"%@/?a=%@&t=%@", kShareActivityURL, base64Encoded, md5Str];
    
    ActivityType *activityType = [[UPConfig sharedInstance] getActivityTypeByID:self.actData.activity_class];
    NSString *actDesc = [NSString stringWithFormat:@"活动类型：%@\n活动描述：%@", activityType.name,self.actData.activity_desc];
    NSString *actImageName = [NSString stringWithFormat:@"default_activity_%@", activityType.ID];
    
    if (buttonIndex==0) {
        [[WXApiManager sharedManager] sendLinkURL:shareLinkUrl TagName:@"UPPER上行" Title:@"我发现了一个活动" Description:actDesc ThumbImageName:actImageName InScene:WXSceneSession];
    } else if (buttonIndex==1) {
        [[WXApiManager sharedManager] sendLinkURL:shareLinkUrl TagName:@"UPPER上行" Title:@"我发现了一个活动" Description:actDesc ThumbImageName:actImageName InScene:WXSceneTimeline];
    } else {
        //取消
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==AlertTagBlock) {
        if (buttonIndex==1) { //确定
            [self blockThisUser];
        }else{
            return;
        }
    } else if (alertView.tag == AlertTagEdit) {
        if (buttonIndex==0) {
            //发布回顾
            UPCommentController *commentController = [[UPCommentController alloc]init];
            commentController.actID = self.actData.ID;
            commentController.title=@"我要回顾";
            commentController.type = 0;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
            [nav.navigationBar setTintColor:[UIColor whiteColor]];
            [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
            nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
            //2.设置导航栏barButton上面文字的颜色
            UIBarButtonItem *item=[UIBarButtonItem appearance];
            [item setTintColor:[UIColor whiteColor]];
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
            [nav.navigationBar setTranslucent:YES];
            [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [self presentViewController:nav animated:YES completion:nil];

            
        } else if (buttonIndex==1) {
            //编辑
            NewLaunchActivityController *editActivityController = [[NewLaunchActivityController alloc] init];
            editActivityController.actData = self.actData;
            [self.navigationController pushViewController:editActivityController animated:YES];
        } else if (buttonIndex==2) {
            //取消
            NSString *rules = @"取消规则：\n\
            1、募集中的活动，随时可取消，一年内满十次，封停账号一个月（不可发起 可参与）\n\
            2、募集成功的活动，如果发起者不能参加，建议先尝试寻找接替的发起人，将活动发起者身份转交给新的发起人。无法找到接替者也可以取消，一年满3次，封停账号半年。\n\
            3、可以点击“更改发起人”按钮，向目前报名人员发送站内信，发送接受链接。可以在发送之前通过站内短信和参与人员沟通接收意向。\n";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:rules delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = AlertTagCancel;
            [alert show];
        }
        return;
    }
    if (alertView.tag == AlertTagCancel) {
        if (buttonIndex==1) {
            //取消活动
            [self cancelActivity];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = _itemList[indexPath.row];
    return cellItem.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = _itemList[indexPath.row];
    
    NSString *itemClassStr = NSStringFromClass([cellItem class]);
    NSString *cellClassStr = [itemClassStr substringToIndex:itemClassStr.length-4];
    
    UPBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassStr];
    if (cell==nil) {
        cell = [(UPBaseCell *)[NSClassFromString(cellClassStr) alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellClassStr];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setItem:cellItem];
    
    if ([cellItem.key isEqualToString:@"extraButton"]) {
        cell.backgroundColor = [UIColor clearColor];
        UIView *backView = [cell viewWithTag:100];
        if (backView==nil) {
            backView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth-20, cellItem.cellHeight)];
            backView.tag=100;
            backView.backgroundColor = [UIColor whiteColor];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 1)];
            line.backgroundColor = [UIColor grayColor];
            [backView addSubview:line];
            
            UIButton *blockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            blockBtn.frame = CGRectMake(10, 8, 70, cellItem.cellHeight-16);
            blockBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            blockBtn.highlighted = NO;
            [blockBtn setImage:[UIImage imageNamed:@"ic_block"] forState:UIControlStateNormal];
            [blockBtn setTitle:@"不看TA" forState:UIControlStateNormal];
            [blockBtn setTitleColor:RGBCOLOR(160, 160, 160) forState:UIControlStateNormal];
            blockBtn.titleLabel.font = kUPThemeMinFont;
            blockBtn.backgroundColor = [UIColor clearColor];
//            blockBtn.layer.cornerRadius = 2.f;
//            blockBtn.layer.borderColor = [UIColor grayColor].CGColor;
//            blockBtn.layer.borderWidth = 1.f;
//            blockBtn.layer.masksToBounds = YES;
            blockBtn.tag = kUPButtonTagBlock;
            [blockBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:blockBtn];
            
            if (self.sourceType==SourceTypeDaTing) {
                blockBtn.hidden = NO;
            } else {
                blockBtn.hidden = YES;
            }

            UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            reportBtn.frame = CGRectMake(ScreenWidth-20-60, 8, 50, cellItem.cellHeight-16);
            reportBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            reportBtn.highlighted = NO;
            [reportBtn setImage:[UIImage imageNamed:@"ic_tipoff"] forState:UIControlStateNormal];
            [reportBtn setTitle:@"举报" forState:UIControlStateNormal];
            [reportBtn setTitleColor:RGBCOLOR(160, 160, 160) forState:UIControlStateNormal];
            reportBtn.titleLabel.font = kUPThemeMinFont;
            reportBtn.backgroundColor = [UIColor clearColor];
//            reportBtn.layer.cornerRadius = 2.f;
//            reportBtn.layer.borderColor = [UIColor grayColor].CGColor;
//            reportBtn.layer.borderWidth = 1.f;
//            reportBtn.layer.masksToBounds = YES;
            reportBtn.tag = kUPButtonTagJuBao;
            [reportBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:reportBtn];
            
            UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            inviteBtn.frame = CGRectMake(ScreenWidth-20-120, 8, 50, cellItem.cellHeight-16);
            inviteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            inviteBtn.highlighted = NO;
            [inviteBtn setImage:[UIImage imageNamed:@"ic_invite"] forState:UIControlStateNormal];
            [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
            [inviteBtn setTitleColor:RGBCOLOR(160, 160, 160) forState:UIControlStateNormal];
            inviteBtn.titleLabel.font = kUPThemeMinFont;
            inviteBtn.backgroundColor = [UIColor clearColor];
//            inviteBtn.layer.cornerRadius = 2.f;
//            inviteBtn.layer.borderColor = [UIColor grayColor].CGColor;
//            inviteBtn.layer.borderWidth = 1.f;
//            inviteBtn.layer.masksToBounds = YES;
            inviteBtn.tag = kUPButtonTagYaoqing;
            [inviteBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:inviteBtn];
            
            UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            shareBtn.frame = CGRectMake(ScreenWidth-20-180, 8, 50, cellItem.cellHeight-16);
            shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            shareBtn.highlighted = NO;
            [shareBtn setImage:[UIImage imageNamed:@"ic_share"] forState:UIControlStateNormal];
            [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
            [shareBtn setTitleColor:RGBCOLOR(160, 160, 160) forState:UIControlStateNormal];
            shareBtn.titleLabel.font = kUPThemeMinFont;
            shareBtn.backgroundColor = [UIColor clearColor];
//            shareBtn.layer.cornerRadius = 2.f;
//            shareBtn.layer.borderColor = [UIColor grayColor].CGColor;
//            shareBtn.layer.borderWidth = 1.f;
//            shareBtn.layer.masksToBounds = YES;
            shareBtn.tag = kUPButtonTagFenXiang;
            [shareBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:shareBtn];
            [cell addSubview:backView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) { //活动参与人
        UPDetailPeopleInfoCellItem *peopleItem = _itemList[indexPath.row];
        peopleItem.currentNum = self.detailActData.part_count;
        //查看报名人数
        if (peopleItem.userIconUrlList.count>0) {
            EnrollPeopleController *enrollController = [[EnrollPeopleController alloc]init];
            [enrollController.userList addObjectsFromArray:peopleItem.userIconUrlList];
            [self.navigationController pushViewController:enrollController animated:YES];
        }
    }
}

@end
