//
//  UpRegister1.h
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityItem.h"
#import "AFHTTPRequestOperationManager.h"
#import "UpRegisterController.h"
#import "CityCell.h"
#import "UPRegisterView.h"

@interface UpRegister1 : UPRegisterView <UITableViewDataSource, UITableViewDelegate, CityCellDelegate>

@property (nonatomic, retain) NSMutableArray *arrayLocatingCity;
@property (nonatomic, retain) NSMutableArray *arrayHotCity;
@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSString *provId;
@property (nonatomic, retain) NSString *townId;
- (void)loadAlphabetCitInfo;
@end
