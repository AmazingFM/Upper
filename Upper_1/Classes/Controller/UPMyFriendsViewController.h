//
//  UPMyFriendsViewController.h
//  Upper
//
//  Created by 张永明 on 16/10/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPBaseViewController.h"
#import "UPBaseModel.h"

@interface UPFriendItem : UPBaseModel

@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *relation_id;
@property (nonatomic, copy) NSString *sexual;
@property (nonatomic, copy) NSString *user_icon;
@end

@interface UPMyFriendsViewController : UPBaseViewController

@end
