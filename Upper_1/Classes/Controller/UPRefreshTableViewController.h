//
//  UPRefreshTableViewController.h
//  Upper
//
//  Created by freshment on 16/7/2.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
#import "UPActivityCell.h"

typedef void (^ItemClickBlock)(id item);

@interface UPRefreshTableViewController : UIViewController <UPItemButtonDelegate>

@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) UILabel *tipsLabel;

@property (nonatomic, retain) NSMutableArray *itemArray;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) BOOL lastPage;
@property (nonatomic, retain) MJRefreshComponent *myRefreshView;
@property (nonatomic) BOOL hasLoad;
@property (nonatomic) ItemClickBlock clickBlock;
- (void)refresh;
@end
