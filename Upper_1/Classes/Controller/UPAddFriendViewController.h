//
//  UPAddFriendViewController.h
//  Upper
//
//  Created by 张永明 on 16/10/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@protocol UPAddFriendDelegate <NSObject>
@optional
- (void)addFriendSuccess;

@end
@interface UPAddFriendViewController : UIViewController
@property (nonatomic, weak) id<UPAddFriendDelegate> delegate;

@end
