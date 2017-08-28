//
//  UpActDetailController.h
//  Upper_1
//
//  Created by aries365.com on 15/12/22.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "ActivityData.h"
#import "UPCells.h"
#import "UIImageView+WebCache.h"
#import "MainController.h"

typedef NS_ENUM(NSInteger, DetailBtnType) {
//    DetailBtnTypeLove,
    DetailBtnTypeComment,
    DetailBtnTypeReview,
    DetailBtnTypeEnroll,
//    DetailBtnTypeJoin,
//    DetailBtnTypeQuit,
//    DetailBtnTypeSign,
    DetailBtnTypeSubmit,
};

typedef NS_ENUM(NSInteger, RequestType) {
    ActivityQuit,
    ActivityComment,
    ActivityReview,
};


typedef NS_ENUM(NSInteger, SourceType) {
    SourceTypeDaTing,
    SourceTypeWoFaqi,
    SourceTypeWoCanyu,
    SourceTypeTaFaqi,
    SourceTypeTaCanyu
};

@interface UPDetailImageCellItem : UPBaseCellItem
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSString *imageDefault;
@property (nonatomic, retain) NSString *userIconUrl;
@property (nonatomic, retain) NSString *userIconDefault;
@property (nonatomic, retain) NSString *userName;
@end

@interface UPDetailTitleInfoCellItem : UPBaseCellItem
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *startTime;
@property (nonatomic, retain) NSString *endTime;
@property (nonatomic, retain) NSString *payTypeName;
@property (nonatomic, retain) NSString *payFee;
@end

@interface UPDetailPeopleInfoCellItem : UPBaseCellItem
@property (nonatomic, retain) NSString *currentNum;
@property (nonatomic, retain) NSString *totalNum;
@property (nonatomic, retain) NSMutableArray *userIconUrlList;
@end

@interface UPDetailExtraInfoCellItem : UPBaseCellItem
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, retain) NSString *place;
@property (nonatomic, retain) NSString *shopName;
@property (nonatomic, retain) NSString *activityTypeName;
@property (nonatomic, retain) NSString *clothTypeName;
@end

@interface UPDetailButtonCellItem : UPBaseCellItem
@property (nonatomic, retain) NSString *title;
@end

@interface UPDetailReviewInfoCellItem :UPBaseCellItem
@property (nonatomic, retain) NSString *reviewText;
@property (nonatomic, retain) NSMutableArray *reviewImageUrls;
@end

//------cell
@interface UPDetailImageCell : UPBaseCell
@property (nonatomic, retain) UIImageView *activityImage;
@property (nonatomic, retain) UIImageView *userIconImage;
@property (nonatomic, retain) UILabel *userNameLabel;
@end


@interface UPDetailTitleInfoCell : UPBaseCell
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *cityNameLabel;
@property (nonatomic, retain) UILabel *startTimeLabel;
@property (nonatomic, retain) UILabel *endTimeLabel;
@property (nonatomic, retain) UILabel *payTypeNameLabel;
@property (nonatomic, retain) UILabel *payFeeLabel;
@end

@interface UPDetailPeopleInfoCell : UPBaseCell
@property (nonatomic, retain) UIButton *infoButton;
@end

@interface UPDetailExtraInfoCell : UPBaseCell
@property (nonatomic, retain) UILabel *descLabel;
@property (nonatomic, retain) UILabel *placeLabel;
@property (nonatomic, retain) UILabel *shopNameLabel;
@property (nonatomic, retain) UILabel *activityTypeNameLabel;
@property (nonatomic, retain) UILabel *clothTypeNameLabel;
@end

@interface UPDetailButtonCell : UPBaseCell
@property (nonatomic, retain) UIButton *button;
@end

@interface UPDetailReviewInfoCell : UPBaseCell
@property (nonatomic, retain) UILabel *reviewLabel;
@property (nonatomic, retain) NSMutableArray *reviewImages;
@end

@interface UpActDetailController : UPBaseViewController

@property (nonatomic, retain) ActivityData *actData;
@property (nonatomic, retain) ActivityData *detailActData;
@property (nonatomic) UPItemStyle style;
@property (nonatomic) SourceType sourceType;
@property (nonatomic, weak) UIViewController * preController;
@end
