//
//  UPMyLaunchViewController.m
//  Upper
//
//  Created by freshment on 16/6/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMyLaunchViewController.h"
#import "UpActDetailController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
#import "UPDataManager.h"
#import "Info.h"
#import "XWHttpTool.h"
#import "UPBaseItem.h"
#import "ActivityData.h"
#import "UPActivityCellItem.h"

@interface UPMyLaunchViewController ()
@end

@implementation UPMyLaunchViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRequest) name:kNotifierActCancelRefresh object:nil];
    }
    return self;
}

- (void)loadMoreData
{
    self.myRefreshView = self.mainTable.footer;
    
    if (!self.lastPage) {
        self.pageNum++;
    }
    [self startRequest];
}


- (void)startRequest
{
    [self checkNetStatus];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%d", self.pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", g_PageSize] forKey:@"page_size"];
    [params setObject:@"" forKey:@"activity_status"];
    [params setObject:@""forKey:@"activity_class"];
    [params setObject:@"4" forKey:@"industry_id"];
    [params setObject:@"" forKey:@"start_begin_time"];
    [params setObject:@"" forKey:@"province_code"];
    [params setObject:@"" forKey:@"city_code"];
    [params setObject:@""forKey:@"town_code"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"creator_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            if (resp_data==nil) {
                self.mainTable.footer.hidden = YES;
                [self.myRefreshView endRefreshing];
                return;
            }
            
            NSString *resp_desc = dict[@"resp_desc"];
            NSLog(@"%@", resp_desc);
            /***************/
            NSMutableDictionary *pageNav = resp_data[@"page_nav"];
            
            PageItem *pageItem = [[PageItem alloc] init];
            pageItem.current_page = [pageNav[@"current_page"] intValue];
            pageItem.page_size = [pageNav[@"page_size"] intValue];
            pageItem.total_num = [pageNav[@"total_num"] intValue];
            pageItem.total_page = [pageNav[@"total_page"] intValue];
            
            if (pageItem.current_page==pageItem.total_page) {
                self.lastPage = YES;
            }
            
            
            NSArray *activityList;
            if (pageItem.total_num>0 && pageItem.page_size>0) {
                activityList  = [ActivityData objectArrayWithJsonArray: resp_data[@"activity_list"]];
            }
            
            
            NSMutableArray *arrayM = [NSMutableArray array];
            if (activityList!=nil) {
                for (int i=0; i<activityList.count; i++)
                {
                    UPActivityCellItem *actCellItem = [[UPActivityCellItem alloc] init];
                    actCellItem.cellWidth = ScreenWidth;
                    actCellItem.cellHeight = 100;
                    actCellItem.type = SourceTypeWoFaqi;
                    actCellItem.itemData = activityList[i];
                    int status = [actCellItem.itemData.activity_status intValue];
                    if (status!=0) {
                        actCellItem.style = UPItemStyleActLaunch;
                    }
                    
                    [arrayM addObject:actCellItem];
                }
            }

            /***************/
            //..下拉刷新
            if (self.myRefreshView == self.mainTable.header) {
                self.itemArray = arrayM;
                self.mainTable.footer.hidden = self.lastPage;
                [self.mainTable reloadData];
                [self.myRefreshView endRefreshing];
                
            } else if (self.myRefreshView == self.mainTable.footer) {
                [self.itemArray addObjectsFromArray:arrayM];
                [self.mainTable reloadData];
                [self.myRefreshView endRefreshing];
                if (self.lastPage) {
                    [self.mainTable.footer noticeNoMoreData];
                }
            }
        }
        else
        {
            NSLog(@"%@", @"获取失败");
            [self.myRefreshView endRefreshing];
        }
        
    } failture:^(id error) {
        NSLog(@"%@",error);
        [self.myRefreshView endRefreshing];
        
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActivityCellItem *actCellItem = (UPActivityCellItem *)self.itemArray[indexPath.row];
    //跳转到详情页面
    UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
    actDetailController.actData = actCellItem.itemData;
    actDetailController.style = actCellItem.style;
    actDetailController.sourceType = SourceTypeWoFaqi;
    [((UPBaseViewController *)self.parentController).navigationController pushViewController:actDetailController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
