//
//  UPTextAlertView.h
//  Upper
//
//  Created by 张永明 on 2017/8/11.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPTextAlertView;
@protocol UPTextAlertViewDelegate <NSObject>
- (void)textAlertView:(UPTextAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface UPTextAlertView : UIView

@property (nonatomic, weak) id<UPTextAlertViewDelegate> delegate;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id<UPTextAlertViewDelegate>)delegate cancelButtonTitle:(nullable NSString *)cancelButtonTitle;

- (void)show;

@end
