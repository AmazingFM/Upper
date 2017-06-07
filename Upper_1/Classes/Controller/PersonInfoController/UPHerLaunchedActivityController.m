//
//  FriendsController.m
//  Upper_1
//
//  Created by aries365.com on 16/1/28.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPHerLaunchedActivityController.h"
#import "YMNetwork.h"
#import "UPBaseItem.h"
@interface UPHerLaunchedActivityController ()

@end

@implementation UPHerLaunchedActivityController

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
    if (self.user_id==nil || self.user_id.length==0) {
        [self.myRefreshView endRefreshing];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", g_PageSize] forKey:@"page_size"];
    [params setObject:@"" forKey:@"activity_status"];
    [params setObject:@""forKey:@"activity_class"];
    [params setObject:@"-1" forKey:@"industry_id"];
    [params setObject:@"" forKey:@"start_begin_time"];
    [params setObject:@"" forKey:@"province_code"];
    [params setObject:@"" forKey:@"city_code"];
    [params setObject:@""forKey:@"town_code"];
    [params setObject:self.user_id forKey:@"creator_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
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
                    actCellItem.type = SourceTypeTaFaqi;
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
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [self.myRefreshView endRefreshing];
        
    }];
}

@end
