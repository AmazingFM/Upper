//
//  UPCommentController.h
//  Upper
//
//  Created by 张永明 on 16/7/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

typedef NS_ENUM(NSInteger, UPCommentType) {
    UPCommentTypeReview = 0,    //回顾
    UPCommentTypeComment,   //评论
    UPCommentTypeComplain,   //投诉
    UPCommentTypeFeedback   //用户意见反馈
};

@interface CommentUserItem : NSObject
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userSexual;
@property (nonatomic, copy) NSString *userNickName;
@property (nonatomic) int status;//踩：-1， 无：0， 赞：1
@end

@protocol UPCommentUserDelegate <NSObject>

- (void)commentUserStatusChanged:(NSArray *)newCommentUserItems;

@end

@protocol UPCommentUserDatasource <NSObject>

- (NSArray*)getCommentUsers;

@end

@interface UPCommentUserView : UIView

@property (nonatomic, copy) NSString *activityId;
@property (nonatomic,weak) id<UPCommentUserDelegate> delegate;
@property (nonatomic,weak) id<UPCommentUserDatasource> dataSource;

- (void)reloadData;
@end

@protocol UPCommentDelegate <NSObject>

- (void)commentSuccess;

@end

@interface UPCommentController : UPBaseViewController <UPCommentUserDelegate, UPCommentUserDatasource>
@property (nonatomic, copy) NSString *actID;
@property (nonatomic) UPCommentType type; //0-我要回顾， 1-我要评论
@property (nonatomic, weak) id<UPCommentDelegate> delegate;
- (instancetype)initWithPlaceholder:(NSString *)placeholder;
@end
