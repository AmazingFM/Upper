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
#import "UPBaseItem.h"
#import "ActivityData.h"
#import "UPActivityCellItem.h"
#import "UPCommentController.h"
#import "QRCodeController.h"
#import "UPFriendListController.h"
#import "NewLaunchActivityController.h"
#import "YMNetwork.h"
#import "MBProgressHUD+MJ.h"
#import "YMNetwork.h"
#import "MessageManager.h"
#import "UPFriendItem.h"
#import "CRNavigationController.h"

@interface UPMyLaunchViewController () <UPFriendListDelegate, UPCommentDelegate>
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
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityList"forKey:@"a"];
    [params setObject:[NSString stringWithFormat:@"%ld", (long)self.pageNum] forKey:@"current_page"];
    [params setObject:[NSString stringWithFormat:@"%d", g_PageSize] forKey:@"page_size"];
    [params setObject:@"" forKey:@"activity_status"];
    [params setObject:@""forKey:@"activity_class"];
    [params setObject:[UPDataManager shared].userInfo.industry_id forKey:@"industry_id"];
    [params setObject:@"" forKey:@"start_begin_time"];
    [params setObject:@"" forKey:@"province_code"];
    [params setObject:@"" forKey:@"city_code"];
    [params setObject:@""forKey:@"town_code"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"creator_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
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
        commentController.delegate = self;
        commentController.type = UPCommentTypeReview;
        
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:commentController];
//        [nav.navigationBar setTintColor:[UIColor whiteColor]];
//        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"back_shadow"] forBarMetrics:UIBarMetricsDefault];
//        nav.navigationBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
        //2.设置导航栏barButton上面文字的颜色
        UIBarButtonItem *item=[UIBarButtonItem appearance];
        [item setTintColor:[UIColor whiteColor]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
//        [nav.navigationBar setTranslucent:YES];
//        [nav setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//        [self presentViewController:nav animated:YES completion:nil];
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionPush;            //改变视图控制器出现的方式
        transition.subtype = kCATransitionFromBottom;     //出现的位置
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        [self.navigationController pushViewController:commentController animated:NO];
    } else if (type==kUPActSignTag) {
        QRCodeController *qrController = [[QRCodeController alloc] init];
        qrController.title = @"扫描";
        qrController.actId = cellItem.itemData.ID;
        [self.navigationController pushViewController:qrController animated:YES];
    } else if (type==kUPActChangeTag) {
        //查看报名人数
        selectedActData = cellItem.itemData;
        
        UPFriendListController *friendlistController = [[UPFriendListController alloc]init];
        friendlistController.type = 1; //活动参与者列表
        friendlistController.activityId = cellItem.itemData.ID;
        friendlistController.delegate = self;
        CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:friendlistController];
        [self presentViewController:nav animated:YES completion:nil];
    } else if (type==kUPActEditTag) {
        NewLaunchActivityController *launchVC = [[NewLaunchActivityController alloc] init];
        launchVC.type = ActOperTypeEdit;
        launchVC.actData = cellItem.itemData;
        [self.navigationController pushViewController:launchVC animated:YES];
    }
}

#pragma mark UPInviteFriendDelegate
- (void)changeLauncher:(UPFriendItem *)userItem
{
    //增加人数条件判断，
    
    NSString *actStatusID = selectedActData.activity_status;
    
    if ([actStatusID intValue]==4) {//募集状态为4(募集结束)时需要判断
        if (selectedActData.part_count<=selectedActData.limit_low) {
            showDefaultAlert(@"提示", @"报名人数不够，无法转让");
            return;
        } else if (selectedActData.fmale_part_count<=selectedActData.fmale_low
                   && [userItem.sexual intValue]==2) { //sexual:1-男，2-女
            showDefaultAlert(@"提示", @"报名人数不够，无法转让给女性");
            return;
        }
    }
    
    __block int count = 0;
    NSDictionary *actDataDict = @{@"activity_name":selectedActData.activity_name,@"activity_class":selectedActData.activity_class,@"begin_time":selectedActData.begin_time,@"id":selectedActData.ID};
    
    NSString *msgDesc = [UPTools stringFromJSON:actDataDict];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"MessageSend" forKey:@"a"];
    [params setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
    [params setValue:userItem.relation_id forKey:@"to_id"];
    UPServerMsgType msgType = ServerMsgTypeChangeLauncher;
    [params setValue:[@(msgType) stringValue] forKey:@"message_type"];
    [params setValue:msgDesc forKey:@"message_desc"];
    [params setValue:@"" forKey:@"expire_time"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"MessageSend, %@", dict);
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            showDefaultAlert(@"提示", @"已成功发送更改请求给对方，如果对方接受，发起人职位将会移交给对方。为提高成功率，您也可以对多个参与者发起更改请求。");
            count++;
        } else {
            count++;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"发送消息失败，请重新操作"];
    }];
}

- (void)commentSuccess
{
    [self refresh];
}

@end
