//
//  UPPresentViewController.h
//  Upper
//
//  Created by 张永明 on 2017/2/3.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@interface UPPresentViewController : UPBaseViewController

- (void)setNavigationBarTitle:(NSString *)title;
- (void)setNavigationBarTitleView:(UIView *)titleView;
- (void)setNavigationBarRightItem:(UIBarButtonItem *)item;
@end
