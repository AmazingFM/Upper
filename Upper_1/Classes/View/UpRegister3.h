//
//  UpRegister3.h
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpRegisterController.h"
#import "UPRegisterView.h"

@interface UpRegister3 : UPRegisterView

@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *emailSuffix;

@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableArray *companyCategory;
@property (nonatomic, retain) NSMutableArray *showCompany;

- (void)loadCompanyData:(id)respData;
- (void)buttonClick:(UIButton *)sender;
- (void)resetSubView;
@end
