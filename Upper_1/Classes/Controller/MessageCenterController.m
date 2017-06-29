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
#import "PrivateMessage.h"
#import "Info.h"
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
    BOOL showBadgeSys;
    BOOL showBadgeAct;
}

@end

@implementation MessageCenterController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        priMsgList = [NSMutableArray new];
        showBadgeSys = [self loadBadgeFlag:@"SysBadgeKey"];
        showBadgeAct = [self loadBadgeFlag:@"ActBadgeKey"];
    }
    return self;
}

- (BOOL)loadBadgeFlag:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

- (void)setBadgeFlag:(NSString *)key flag:(BOOL)flag
{
    [[NSUserDefaults standardUserDefaults] setBool:flag forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

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
    [priMsgList addObjectsFromArray:[[MessageManager shared] getMessagesByType:MessageTypeCommon]];
}

- (void)updateMsg:(NSNotification *)notification
{
    NSDictionary *msgGroupDict = notification.userInfo;
    NSArray<PrivateMessage *> *usrMsgList = msgGroupDict[UsrMsgKey];
    
    //更新系统消息、活动消息红点
    showBadgeSys = [self loadBadgeFlag:@"SysBadgeKey"];
    showBadgeAct = [self loadBadgeFlag:@"ActBadgeKey"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //更新用户信息
        if (usrMsgList.count>0) {
            [self loadMessage];//重新加载
            [_messageTable reloadData];
        } else  {
            [self reloadSysAndActBadge];
        }
    });
}

- (void)reloadSysAndActBadge
{
    NSMutableArray<NSIndexPath *> *indexPaths = [[NSMutableArray alloc] init];
    if (showBadgeSys) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    if (showBadgeAct) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:1 inSection:0]];
    }
    
    if (indexPaths.count>0) {
        [_messageTable reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    }
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
                if (showBadgeSys) {
                    cell.unreadCount = @1;//[notificationDict objectForKey:@"system"];
                } else {
                    cell.unreadCount = @0;
                }
                break;
            case 1:
                cell.type = ToMessageTypeInvitation;
                if (showBadgeAct) {
                    cell.unreadCount = @1;//[notificationDict objectForKey:@"invite"];
                } else {
                    cell.unreadCount = @0;
                }
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
    if (indexPath.row<2) {
        MessageListController *msgListController = [[MessageListController alloc] init];
        if (indexPath.row==0) {
            showBadgeSys = NO;
            [self setBadgeFlag:@"SysBadgeKey" flag:showBadgeSys];
            
            msgListController.messageType = MessageTypeSystem;
        } else if (indexPath.row==1) {
            showBadgeAct = NO;
            [self setBadgeFlag:@"ActBadgeKey" flag:showBadgeAct];
            
            msgListController.messageType = MessageTypeActivity;
        }

        [self.navigationController pushViewController:msgListController animated:YES];
        
    } else {
        PrivateMessage *msg = [priMsgList objectAtIndex:indexPath.row-2];
        [[MessageManager shared] updateMessageReadStatus:msg];
        msg.read_status = @"1";

        UPChatViewController *chatController = [[UPChatViewController alloc] initWithUserID:msg.remote_id andUserName:msg.remote_name andUserIcon:@""];
        [self.navigationController pushViewController:chatController animated:YES];
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
