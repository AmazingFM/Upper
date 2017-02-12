//
//  UpRegister5.h
//  Upper_1
//
//  Created by aries365.com on 16/1/15.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpRegisterController.h"
#import "UPRegisterView.h"

@interface UpRegister5 : UPRegisterView <UITextFieldDelegate>

@property (nonatomic, retain) UITextField *emailField;
@property (nonatomic, copy) NSString *emailPrefix;
@property (nonatomic, copy) NSString *emailSuffix;

@property (nonatomic, retain) UILabel *suffixLabel;
@property (nonatomic) BOOL noEmail;
@property (nonatomic) NSString *industryID;

@property (nonatomic, copy) NSString *comPhone;
@property (nonatomic, copy) NSString *empName;
@property (nonatomic, copy) NSString *empID;
@property (nonatomic, copy) NSString *telenum;
@property (nonatomic, copy) NSString *smsText;

- (NSString *)identifyID;
- (NSString *)identifyType;
- (void)resize;
-(void)stopTimer;

@end
