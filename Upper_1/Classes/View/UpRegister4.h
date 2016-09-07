//
//  UpRegister4.h
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"
#import "UpRegisterController.h"
#import "UPRegisterView.h"

@protocol UPRegistV4Delegate <NSObject>

-(void)beginEditing:(CGFloat)height;
-(void)endEditing;

@end

@interface UpRegister4 : UPRegisterView <UITextFieldDelegate, RadioButtonDelegate>

@property (nonatomic, retain) NSMutableArray<UITextField*> *fields;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *confirmPass;
@property (nonatomic, copy) NSString *sexType;

@property (nonatomic, retain) id<UPRegistV4Delegate> delegate;

@end
