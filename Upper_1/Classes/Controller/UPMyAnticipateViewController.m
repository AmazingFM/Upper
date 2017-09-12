//
//  UPMyAnticipateViewController.m
//  Upper
//
//  Created by freshment on 16/6/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMyAnticipateViewController.h"
#import "UpActDetailController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
#import "UPDataManager.h"
#import "Info.h"
#import "UPBaseItem.h"
#import "ActivityData.h"
#import "UPActivityCellItem.h"
#import "UPCommentController.h"
#import "YMNetwork.h"
@interface UPMyAnticipateViewController () <UPCommentDelegate>

@end

@implementation UPMyAnticipateViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startRequest) name:kNotifierActQuitRefresh object:nil];
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
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"JoinActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%ld",(long)self.pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", g_PageSize] forKey:@"page_size"];
//    [params setObject:@"" forKey:@"activity_status"];
//    [params setObject:@""forKey:@"activity_class"];
    [params setObject:[UPDataManager shared].userInfo.industry_id forKey:@"industry_id"];
//    [params setObject:@"" forKey:@"start_begin_time"];
//    [params setObject:@"" forKey:@"province_code"];
//    [params setObject:@"" forKey:@"city_code"];
//    [params setObject:@""forKey:@"town_code"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"partner_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
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
                    actCellItem.cellHeight = 30*2+60+10;
                    actCellItem.type = SourceTypeWoCanyu;
                    actCellItem.itemData = activityList[i];
                    int status = [actCellItem.itemData.activity_status intValue];
                    if (status!=0) {
                        actCellItem.style = UPItemStyleActJoin;
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
            
            self.hasLoad = YES;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActivityCellItem *actCellItem = (UPActivityCellItem *)self.itemArray[indexPath.row];
    //跳转到详情页面
    UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
    actDetailController.actData = actCellItem.itemData;
    actDetailController.style = actCellItem.style;
    actDetailController.sourceType = SourceTypeWoCanyu;
    actDetailController.navigationItem.backBarButtonItem.title = @"我的活动";
    
    [self.navigationController pushViewController:actDetailController animated:YES];
}

-(void)onButtonSelected:(UPActivityCellItem *)cellItem withType:(int)type
{
    if (type==kUPActCommentTag ||type==kUPActComplainTag) {
        
        //发布评论
        UPCommentController *commentController = [[UPCommentController alloc]init];
        commentController.actID = cellItem.itemData.ID;
        commentController.title = (type==kUPActCommentTag)?@"活动评论":@"活动投诉";
        commentController.type = (type==kUPActCommentTag)?UPCommentTypeComment:UPCommentTypeComplain;
        commentController.delegate = self;
        //2.设置导航栏barButton上面文字的颜色
        UIBarButtonItem *item=[UIBarButtonItem appearance];
        [item setTintColor:[UIColor whiteColor]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionPush;            //改变视图控制器出现的方式
        transition.subtype = kCATransitionFromTop;     //出现的位置
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:commentController animated:NO];
    }
}


- (void)commentSuccess
{
    [self refresh];
}

@end
