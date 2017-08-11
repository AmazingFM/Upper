//
//  UPTextAlertView.h
//  Upper
//
//  Created by 张永明 on 2017/8/11.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPTextAlertView : UIView

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

- (void)show;

@end
