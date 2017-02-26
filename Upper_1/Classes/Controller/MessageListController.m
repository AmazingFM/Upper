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
#define kCellIdentifier_Message     @"kMessageCellId"
@interface MessageListController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_messageTable;
    NSMutableArray<PrivateMessage *> *msgList;
}
@end

@implementation MessageListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.messageType==MessageTypeSystem) {
        self.title = @"系统消息";
    } else if (self.messageType==MessageTypeActivity) {
        self.title = @"活动消息";
    }
    
    msgList = [NSMutableArray new];
    
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
    
    [self loadMessage];//加载初始消息
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageGroupUpdate object:nil];
    
}

- (void)loadMessage
{
    NSRange range = NSMakeRange(0, 100);
    NSMutableArray *groupMsgList = [[MessageManager shared] getMessageGroup:range];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDelegate, datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ConversationCell cellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Message forIndexPath:indexPath];
    PrivateMessage *msg = [msgList objectAtIndex:indexPath.row];
    cell.curPriMsg = msg;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *msg = [msgList objectAtIndex:indexPath.row];
    switch (msg.localMsgType) {
        case MessageTypeSystemGeneral:
            showDefaultAlert(@"系统消息", msg.message_desc);
            break;
        case MessageTypeActivityInvite:
        {
            //得到活动信息
            ActivityData *activityInfo = [self getActivityInfoFromMsg:msg.message_desc];
            UpActDetailController *actDetailController = [[UpActDetailController alloc] init];
            actDetailController.actData = activityInfo;
            actDetailController.sourceType = SourceTypeDaTing;
            [self.navigationController pushViewController:actDetailController animated:YES];
        }
            break;
        case MessageTypeActivityChangeLauncher:
        {
            //得到活动信息
            ActivityData *activityInfo = [self getActivityInfoFromMsg:msg.message_desc];
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
    if (alertView.tag==100) {
        if (buttonIndex==1) {//接受转让
            ActivityData *activityInfo = (ActivityData *)alertView.someObj;
            if (activityInfo!=nil) {
                [self acceptActivity:activityInfo];
            }
        }
    }
}

- (ActivityData *)getActivityInfoFromMsg:(NSString *)msg
{
    if (msg==nil || msg.length==0) {
        return nil;
    }
    
    ActivityData *activityData = [[ActivityData alloc] initWithJsonString:msg];
    return activityData;
}

- (void)acceptActivity:(ActivityData *)activityInfo
{
    
}


@end
