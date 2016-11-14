//
//  MessageCenterController.m
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "MessageCenterController.h"
#import "MessageManager.h"
#import "UPDataManager.h"
#import "UPTimerManager.h"
#import "UPTools.h"
#import "Info.h"
#import "UUMessage.h"
#import "UPTheme.h"
#import "UPMessageCell.h"

#import "BubbleChatViewController.h"

@implementation UserChatItem
@end

@interface MessageCenterController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_messageTable;
    UILabel *tipsLabel ;
    
    NSMutableArray *sysMsgList;
    NSMutableArray *usrMsgList;
}

@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.navigationItem.rightBarButtonItem = nil;
    
    usrMsgList = [NSMutableArray array];
    
    tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight/2, ScreenWidth-40, 40)];
    tipsLabel.text = @"暂时没有消息";
    tipsLabel.font = kUPThemeMiddleFont;
    tipsLabel.backgroundColor = [UIColor whiteColor];
    tipsLabel.hidden = YES;
    [self.view addSubview:tipsLabel];
    
    _messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
    _messageTable.backgroundColor = [UIColor clearColor];
    _messageTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _messageTable.separatorColor = [UIColor grayColor];
    _messageTable.separatorInset = UIEdgeInsetsMake(0,80, 0, 80);
    _messageTable.delegate = self;
    _messageTable.dataSource = self;
    _messageTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    if ([_messageTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_messageTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([_messageTable respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [_messageTable setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    [self.view addSubview:_messageTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [usrMsgList removeAllObjects];
    [self loadMessage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageGroupUpdate object:nil];
}

- (void)loadMessage
{
    NSRange range = NSMakeRange(0, 100);
    NSMutableArray *groupMsgList = [[MessageManager shared] getMessageGroup:range];
    [self fillMessage:groupMsgList];
}

- (void)updateMsg:(NSNotification *)notification
{
    NSMutableArray *msgList = notification.object;
    
    [self fillMessage:msgList];
}

- (void)fillMessage:(NSMutableArray *)groupMsgList
{
    @synchronized (self) {
        for (UUMessage *msg in groupMsgList) {
            UserChatItem *item = [self getItem:msg.strId];
            if (item==nil) {
                item = [[UserChatItem alloc] init];
                [usrMsgList insertObject:item atIndex:0];
            }
            item.userId = msg.strId;
            item.userName = msg.strName;
            item.recentMsg = msg.strContent;
            item.time = msg.strTime;
            item.status = msg.status;
        }
    }

    [_messageTable reloadData];
}

//调整收到的消息的位置
- (UserChatItem *)getItem:(NSString *)userId
{
    int hitIndex = -1;
    UserChatItem *tmpItem = nil;
    for (int i=0; i<usrMsgList.count; i++) {
        tmpItem = usrMsgList[i];
        if ([tmpItem.userId isEqualToString:userId]) {
            hitIndex = i;
            break;
        }
    }
    //调整到head位置
    if (hitIndex!=-1&&hitIndex>0) {
        [usrMsgList removeObject:tmpItem];
        [usrMsgList insertObject:tmpItem atIndex:0];
        return tmpItem;
    } else {
        return nil;
    }
}

#pragma mark UITableViewDelegate, datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (usrMsgList.count==0) {
        tipsLabel.hidden = NO;
    } else {
        tipsLabel.hidden = YES;
    }
    return usrMsgList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UPMessageCell *msgCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (msgCell==nil) {
        msgCell = [[UPMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UserChatItem *item = usrMsgList[indexPath.row];
    
    [msgCell.icon setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head"]];
    msgCell.nameLabel.text = item.userName;
    msgCell.contentLabel.text = item.recentMsg;
    if ([item.status intValue]==0) {
        msgCell.badgeLabel.hidden = NO;
    } else {
        msgCell.badgeLabel.hidden = YES;
    }
    
    return msgCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserChatItem *item = usrMsgList[indexPath.row];
    
    [[MessageManager shared] updateGropuMessageStatus:item.userId];//设置状态已读
    
    
    BubbleChatViewController *chatController = [[BubbleChatViewController alloc] initWithUserID:item.userId andUserName:item.userName];
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierMessageGroupUpdate object:nil];
}

@end
