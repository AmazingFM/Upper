//
//  UPChatViewController.h
//  Upper
//
//  Created by 张永明 on 2017/2/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "BottomBarViewController.h"
#import "UserData.h"

@interface UPChatViewController : BottomBarViewController

@property (nonatomic, copy) NSString *remote_id;
@property (nonatomic, copy) NSString *remote_name;
@property (nonatomic, copy) NSString *remote_icon;

@property (nonatomic, retain) UserData *userData;
@property (nonatomic, retain) OtherUserData *otherUserData;

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName andUserIcon:(NSString *)userIcon;
@end
