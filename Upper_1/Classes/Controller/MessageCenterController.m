//
//  MessageCenterController.m
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "MessageCenterController.h"
#import "MessageListController.h"
#import "MessageManager.h"
#import "UPDataManager.h"
#import "UPTimerManager.h"
#import "PrivateMessage.h"
#import "Info.h"
#import "UUMessage.h"
#import "UPTheme.h"
#import "ConversationCell.h"

#import "UPChatViewController.h"

@implementation UserChatItem
@end

#define kCellIdentifier_Conversation    @"kConversationCellId"
#define kCellIdentifier_ToMessage       @"kTopMessageCellId"

@interface MessageCenterController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_messageTable;
    NSMutableArray<PrivateMessage *> *priMsgList;
    
    NSMutableDictionary *notificationDict;
}

@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    self.navigationItem.rightBarButtonItem = nil;
    
    _messageTable = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tableView registerClass:[ConversationCell class] forCellReuseIdentifier:kCellIdentifier_Conversation];
        [tableView registerClass:[ToMessageCell class] forCellReuseIdentifier:kCellIdentifier_ToMessage];
        tableView.tableFooterView = [UIView new];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self loadMessage];//加载初始消息
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadMessage
{
    NSRange range = NSMakeRange(0, 100);
    NSMutableArray *groupMsgList = [[MessageManager shared] getMessageGroup:range];
    [self fillMessage:groupMsgList];
}

- (void)updateMsg:(NSNotification *)notification
{
    //注意加锁
    NSMutableArray *msgList = notification.object;
    
    [self fillMessage:msgList];
}

- (void)fillMessage:(NSMutableArray *)groupMsgList
{
//    @synchronized (self) {
//        //获取第三个普通消息组
//        GroupMessage *usrGroup = groupMsgList[2];
//        
//        for (UUMessage *msg in usrGroup.messageList) {
//            UserChatItem *item = [self getItem:msg.strId];
//            if (item==nil) {
//                item = [[UserChatItem alloc] init];
//                [usrMsgList insertObject:item atIndex:0];
//            }
//            item.userId = msg.strId;
//            item.userName = msg.strName;
//            item.recentMsg = msg.strContent;
//            item.time = msg.strTime;
//            item.status = msg.status;
//        }
//    }
//
//    [_messageTable reloadData];
}

#pragma mark UITableViewDelegate, datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    if (indexPath.row<2) {
        cellHeight = [ToMessageCell cellHeight];
    } else {
        cellHeight = [ConversationCell cellHeight];
    }
    return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row=2;
    if (priMsgList) {
        row+=priMsgList.count;
    }
    return row;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<2) {
        ToMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ToMessage forIndexPath:indexPath];
        switch (indexPath.row) {
            case 0:
                cell.type = ToMessageTypeSystemNotification;
                cell.unreadCount = @10;//[notificationDict objectForKey:@"system"];
                break;
            case 1:
                cell.type = ToMessageTypeInvitation;
                cell.unreadCount = @9;//[notificationDict objectForKey:@"invite"];
                break;
            default:
                break;
        }
        return cell;
    } else {
        ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_Conversation forIndexPath:indexPath];
        PrivateMessage *msg = [priMsgList objectAtIndex:indexPath.row-2];
        cell.curPriMsg = msg;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row<2) {
//        MessageListController *msgListController = [[MessageListController alloc] init];
//        msgListController.messageType = indexPath.row;
//        [self.navigationController pushViewController:msgListController animated:YES];
//    } else {
        PrivateMessage *msg = [priMsgList objectAtIndex:indexPath.row-2];
        UPChatViewController *chatController = [[UPChatViewController alloc] initWithUserID:msg.remote_id andUserName:msg.remote_name];
        [self.navigationController pushViewController:chatController animated:YES];
//    }
//    UserChatItem *item = usrMsgList[indexPath.row];
//    [[MessageManager shared] updateGropuMessageStatus:item.userId];//设置状态已读
//    BubbleChatViewController *chatController = [[BubbleChatViewController alloc] initWithUserID:item.userId andUserName:item.userName];
//    [self.navigationController pushViewController:chatController animated:YES];
}

@end
