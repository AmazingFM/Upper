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

#import "ChatController.h"

@implementation UserChatItem
@end

@interface MessageCenterController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_messageTable;
    UILabel *tipsLabel ;
    NSMutableArray *userList;
}

@end

@implementation MessageCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息列表";
    self.navigationItem.rightBarButtonItem = nil;
    
    userList = [NSMutableArray array];
    
    tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, ScreenHeight/2, ScreenWidth-40, 40)];
    tipsLabel.text = @"暂时没有消息";
    tipsLabel.font = kUPThemeMiddleFont;
    tipsLabel.backgroundColor = [UIColor whiteColor];
    tipsLabel.hidden = YES;
    [self.view addSubview:tipsLabel];
    
    _messageTable = [[UITableView alloc] initWithFrame:CGRectMake(LeftRightPadding, FirstLabelHeight, ScreenWidth-2*LeftRightPadding, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
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
    
    [self loadMessage];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageGroupUpdate object:nil];
}

- (void)loadMessage
{
    NSRange range = NSMakeRange(0, 100);
    NSMutableDictionary *msgDict = [[MessageManager shared] getMessageGroup:range];
    [self fillMessage:msgDict];
}

- (void)updateMsg:(NSNotification *)notification
{
    NSDictionary *msgList = notification.object;
    
    [self fillMessage:msgList];
}

- (void)fillMessage:(NSDictionary *)userMsgDict
{
    @synchronized (self) {
        NSArray *users = [userMsgDict allKeys];
        for (NSString *userId in users) {
            UUMessage *msg = userMsgDict[userId];
            
            UserChatItem *item = [self getItem:userId];
            if (item==nil) {
                item = [[UserChatItem alloc] init];
                [userList insertObject:item atIndex:0];
            }
            item.userId = userId;
            item.userName = msg.strName;
            item.recentMsg = msg.strContent;
            item.time = msg.strTime;
            item.status = msg.status;
        }
    }
    
    [_messageTable reloadData];
}

- (UserChatItem *)getItem:(NSString *)userId
{
    int hitIndex = -1;
    UserChatItem *item = nil;
    for (int i=0; i<userList.count; i++) {
        item = userList[i];
        if ([item.userId isEqualToString:userId]) {
            hitIndex = i;
            break;
        }
    }
    //调整到head位置
    if (hitIndex!=-1&&hitIndex>0) {
        userList[hitIndex] = userList[0];
        userList[0] = item;
    }
    return item;
}
#pragma mark UITableViewDelegate, datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (userList.count==0) {
        tipsLabel.hidden = NO;
    } else {
        tipsLabel.hidden = YES;
    }
    return userList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        badgeLabel.size = CGSizeMake(20, 20);
        badgeLabel.backgroundColor = [UIColor redColor];
        badgeLabel.center = CGPointMake(ScreenWidth-30, 33);
        badgeLabel.tag = 1001;
        badgeLabel.hidden = YES;
        [cell addSubview:badgeLabel];
    }
    UserChatItem *item = userList[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"head"];
    cell.imageView.contentMode =UIViewContentModeScaleAspectFit;

    cell.textLabel.text = item.userName;
    cell.detailTextLabel.text = item.recentMsg;
    if ([item.status intValue]==0) {
        UILabel *badgeLb = [cell viewWithTag:1001];
        badgeLb.hidden = NO;
    } else {
        UILabel *badgeLb = [cell viewWithTag:1001];
        badgeLb.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserChatItem *item = userList[indexPath.row];
    
    [[MessageManager shared] updateGropuMessageStatus:item.userId];//设置状态已读
    
    ChatController *chatController = [[ChatController alloc]init];
    chatController.toUserId = item.userId;
    chatController.toUserName = item.userName;
    chatController.title = chatController.toUserName;
    [self.navigationController pushViewController:chatController animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierMessageGroupUpdate object:nil];
}

@end
