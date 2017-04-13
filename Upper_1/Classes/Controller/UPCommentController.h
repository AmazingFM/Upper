//
//  UPCommentController.h
//  Upper
//
//  Created by 张永明 on 16/7/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

typedef NS_ENUM(NSInteger, UPCommentType) {
    UPCommentTypeReview,
    UPCommentTypeComment
};

@interface UITable : <#superclass#>

@end
@interface UPCommentController : UPBaseViewController

@property (nonatomic, copy) NSString *actID;
@property (nonatomic) UPCommentType type; //0-我要回顾， 1-我要评论
@end
