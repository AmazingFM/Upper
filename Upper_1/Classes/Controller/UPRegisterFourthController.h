//
//  UPRegisterFourthController.h
//  Upper
//
//  Created by 张永明 on 2017/10/31.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"

@protocol UPRegistV4Delegate <NSObject>

-(void)beginEditing:(CGFloat)height;
-(void)endEditing;

@end

@interface UPRegisterFourthController : UPBaseViewController

@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSString *provId;
@property (nonatomic, retain) NSString *townId;

@property (nonatomic, retain) NSString *industryId;

@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *emailSuffix;

@end
