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
#import "UPCommentController.h"
#import "QRCodeController.h"
#import "EnrollPeopleController.h"
#import "UPFriendListController.h"
#import "NewLaunchActivityController.h"
#import "YMNetwork.h"

@interface UPMyLaunchViewController () <UPFriendListDelegate>
{
    ActivityData *selectedActData;
}
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
//    [self checkNetStatus];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%ld", self.pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", g_PageSize] forKey:@"page_size"];
    [params setObject:@"" forKey:@"activity_status"];
    [params setObject:@""forKey:@"activity_class"];
    [params setObject:@"-1" forKey:@"industry_id"];
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
            NSString *resp_desc = dict[@"resp_desc"];
            NSLog(@"%@", resp_desc);

            if (resp_data==nil) {
                self.tipsLabel.hidden = NO;
                self.mainTable.footer.hidden = YES;
                [self.myRefreshView endRefreshing];
                return;
            }
            
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
    [self.navigationController pushViewController:actDetailController animated:YES];
}


-(void)onButtonSelected:(UPActivityCellItem *)cellItem withType:(int)type
{
    if (type==kUPActReviewTag) {
        //发布回顾
        UPCommentController *commentController = [[UPCommentController alloc]init];
        commentController.actID = cellItem.itemData.ID;
        commentController.title=@"我要回顾";
        commentController.type = 0;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
        nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
        //2.设置导航栏barButton上面文字的颜色
        UIBarButtonItem *item=[UIBarButtonItem appearance];
        [item setTintColor:[UIColor whiteColor]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        [nav.navigationBar setTranslucent:YES];
        [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (type==kUPActSignTag) {
        QRCodeController *qrController = [[QRCodeController alloc] init];
        qrController.title = @"扫描";
        [self.navigationController pushViewController:qrController animated:YES];
    } else if (type==kUPActChangeTag) {
        //查看报名人数
        selectedActData = cellItem.itemData;
        
        UPFriendListController *friendlistController = [[UPFriendListController alloc]init];
        friendlistController.type = 1; //活动参与者列表
        friendlistController.activityId = cellItem.itemData.ID;
        friendlistController.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:friendlistController];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (type==kUPActEditTag) {
        NewLaunchActivityController *launchVC = [[NewLaunchActivityController alloc] init];
        launchVC.type = ActOperTypeEdit;
        launchVC.actData = cellItem.itemData;
        [self.navigationController pushViewController:launchVC animated:YES];
    }
}

#pragma mark UPInviteFriendDelegate
- (void)changeLauncher:(NSString *)userId
{
    __block int count = 0;
    
    NSDictionary *actDataDict = @{@"activity_name":selectedActData.activity_name,@"activity_class":selectedActData.activity_class,@"begin_time":selectedActData.begin_time,@"id":selectedActData.ID};
    
    NSString *msgDesc = [UPTools stringFromJSON:actDataDict];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"MessageSend" forKey:@"a"];
    [params setValue:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
    [params setValue:userId forKey:@"to_id"];
    [params setValue:@"98" forKey:@"message_type"];
    [params setValue:msgDesc forKey:@"message_desc"];
    [params setValue:@"" forKey:@"expire_time"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"MessageSend, %@", dict);
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSLog(@"send message successful!");
            count++;
        } else {
            count++;
        }
    } failure:^(NSError *error) {
        count++;
    }];
}

@end
