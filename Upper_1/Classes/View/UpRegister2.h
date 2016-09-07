//
//  UpRegister2.h
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpRegisterController.h"
#import "UPRegisterView.h"

@interface UpRegister2 : UPRegisterView

@property (nonatomic, retain) NSString *industryId;

- (void)loadIndustryData:(id)respData;
- (void)buttonClick:(UIButton*)sender;
- (void)resetSubView;
@end
