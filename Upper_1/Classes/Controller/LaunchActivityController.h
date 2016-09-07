//
//  LaunchActivityController.h
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

#import "Info.h"

@class ActivityData;
@interface LaunchActivityController : UPBaseViewController
{
    UIDatePicker *_datePickerView;
    UIPickerView *_typePickerView;
    UIPickerView *_cityPickerView;
    
    UIView *_datePanelView;
    UIButton *_hideBtn;
    UIButton *_confirmBtn;
}

@property (nonatomic, retain) ActivityData *actData;

@end
