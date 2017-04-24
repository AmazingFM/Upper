//
//  MessageListController.m
//  Upper
//
//  Created by 张永明 on 2017/2/13.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "MessageListController.h"
#import "ConversationCell.h"
#import "MessageManager.h"
#import "ActivityData.h"
#import "UIAlertView+NSObject.h"
#import "YMNetwork.h"
#import "UpActDetailController.h"
#import "MBProgressHUD+MJ.h"

#define kCellIdentifier_Message     @"kMessageCellId"
@interface MessageListController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_messageTable;
    NSMutableArray<PrivateMessage *> *priMsgList;
    
    NSString *remoteID;
}
@end

@implementation MessageListController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        priMsgList = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.messageType==MessageTypeSystem) {
        self.title = @"系统消息";
    } else if (self.messageType==MessageTypeActivity) {
        self.title = @"活动消息";
    }
    
    _messageTable = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tableView registerClass:[ConversationCell class] forCellReuseIdentifier:kCellIdentifier_Message];
        tableView.tableFooterView = [UIView new];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadMessage];//加载初始消息
    [_messageTable reloadData];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//初次加载
- (void)loadMessage
{
    [priMsgList removeAllObjects];
    [priMsgList addObjectsFromArray:[[MessageManager shared] getMessagesByType:self.messageType]];
}

- (void)updateMsg:(NSNotification *)notification
{
    NSString *msgGroupKey = nil;
    if (self.messageType==MessageTypeSystem) {
        msgGroupKey = SysMsgKey;
    } else if (self.messageType==MessageTypeActivity) {
        msgGroupKey = ActMsgKey;
    }
    
    NSDictionary *msgGroupDict = notification.userInfo;
    NSArray<PrivateMessage *> *msgList = msgGroupDict[msgGroupKey];
    
    if (msgList.count>0) {
        [priMsgList addObjectsFromArray:msgList];
        [_messageTable reloadData];
    }
}

#pragma mark UITableViewDelegate, datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ConversationCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return priMsgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Message forIndexPath:indexPath];
    PrivateMessage *msg = [priMsgList objectAtIndex:indexPath.row];
    cell.curPriMsg = msg;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *msg = [priMsgList objectAtIndex:indexPath.row];
    remoteID = msg.remote_id;
    
    switch (msg.localMsgType) {
        case MessageTypeSystemGeneral:
            showDefaultAlert(@"系统消息", msg.msg_desc);
            break;
        case MessageTypeActivityInvite:
        {
            //得到活动信息
            ActivityData *activityInfo = [self getActivityInfoFromMsg:msg.msg_desc];
            ActivityType *actType = [[UPConfig sharedInstance] getActivityTypeByID:activityInfo.activity_class];
            
            //activity_name-活动名称,activity_class-活动类型, start_time-活动开始时间，ID-活动id，nick_name-发起人昵称
            NSString *showMsg = [NSString stringWithFormat:@"活动名称:%@\n活动类型:%@\n开始时间:%@", activityInfo.activity_name, actType.name, activityInfo.start_time];
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"活动邀请" message:showMsg delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"查看详情", nil];
            alertview.tag = 99;
            alertview.someObj = activityInfo;
            [alertview show];
        }
            break;
        case MessageTypeActivityChangeLauncher:
        {
            //得到活动信息
            ActivityData *activityInfo = [self getActivityInfoFromMsg:msg.msg_desc];
            ActivityType *actType = [[UPConfig sharedInstance] getActivityTypeByID:activityInfo.activity_class];
            
            NSString *showMsg = [NSString stringWithFormat:@"活动名称:%@\n活动类型:%@\n发起人:%@", activityInfo.activity_name, actType.name, activityInfo.nick_name];
            
            UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"变更发起人" message:showMsg delegate:self cancelButtonTitle:@"忽略" otherButtonTitles:@"接受", nil];
            alertview.tag = 100;
            alertview.someObj = activityInfo;
            [alertview show];
        }
            break;
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==99) {
        if (buttonIndex==1) {//查看活动详情
            ActivityData *activityInfo = (ActivityData *)alertView.someObj;
            UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
            actDetailController.actData = activityInfo;
            actDetailController.sourceType = SourceTypeDaTing;
            [self.navigationController pushViewController:actDetailController animated:YES];

        }
    }
    if (alertView.tag==100) {
        if (buttonIndex==1) {//接受转让
            ActivityData *activityInfo = (ActivityData *)alertView.someObj;
            [self acceptActivity:activityInfo];
        }
    }
}

- (ActivityData *)getActivityInfoFromMsg:(NSString *)msg
{
    if (msg==nil || msg.length==0) {
        return nil;
    }
    
    NSString *jsonStr = [UPTools stringFromQuotString:msg];
    ActivityData *activityData = [[ActivityData alloc] initWithJsonString:jsonStr];
    return activityData;
}

- (void)acceptActivity:(ActivityData *)activityInfo
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [indicator startAnimating];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityModify"forKey:@"a"];
    [params setObject:remoteID forKey:@"user_id"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"new_user_id"];
    [params setObject:activityInfo.ID forKey:@"activity_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [indicator stopAnimating];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            [MBProgressHUD show:resp_desc icon:nil view:nil];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            [MBProgressHUD show:resp_desc icon:nil view:nil];
        }
        
    } failture:^(id error) {
        [indicator stopAnimating];
        NSLog(@"%@",error);
        
    }];
}


@end
