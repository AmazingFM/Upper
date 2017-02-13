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
#import "PrivateMessage.h"

@implementation UserChatItem
@end

@interface ConversationCell()
@property (nonatomic, retain) UIImageView *userIconView;
@property (nonatomic, retain) UILabel *name, *msg, *time;

@end

@implementation ConversationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftRightPadding, ([ConversationCell cellHeight]-48)/2, 48, 48)];
            _userIconView.layer.masksToBounds = YES;
            _userIconView.layer.cornerRadius = 48/2;
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = [UPTools colorWithHex:0xdddddd].CGColor;
            [self.contentView addSubview:_userIconView];
        }
        if (!_name) {
            _name = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 150, 25)];
            _name.font = [UIFont systemFontOfSize:17];
            _name.textColor = [UPTools colorWithHex:0x222222];
            _name.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_name];
        }
        if (!_time) {
            _time = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-100-LeftRightPadding, 8, 100, 25)];
            _time.font = [UIFont systemFontOfSize:12];
            _time.textAlignment = NSTextAlignmentRight;
            _time.textColor = [UPTools colorWithHex:0x999999];
            _time.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_time];
        }
        if (!_msg) {
            _msg = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, ScreenWidth-75-30-LeftRightPadding, 25)];
            _msg.font = [UIFont systemFontOfSize:15];
            _msg.backgroundColor = [UIColor clearColor];
            _msg.textColor = [UPTools colorWithHex:0x999999];
            [self.contentView addSubview:_msg];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_curPriMsg) {
        return;
    }
    [_userIconView setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head"]];
    
    _name.text = _curPriMsg.nickName;
    _time.text = _curPriMsg.addTime;
    _msg.text = _curPriMsg.msgContent;
}

+ (CGFloat)cellHeight
{
    return 61;
}

@end

@implementation ToMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = kUPThemeTitleFont;
        self.textLabel.textColor = [UPTools colorWithHex:0x222222];
    }
    return self;
}

- (void)setType:(ToMessageType)type
{
    _type = type;
    NSString *imageName, *titleStr;
    switch (type) {
        case ToMessageTypeInvitation:
            imageName = @"messageInvite";
            titleStr = @"活动邀请";
            break;
        case ToMessageTypeSystemNotification:
            imageName = @"messageSystem";
            titleStr = @"系统通知";
            break;
        default:
            break;
    }
    self.imageView.image = [UIImage imageNamed:imageName];
    self.textLabel.text = titleStr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(LeftRightPadding, ([ToMessageCell cellHeight]-48)/2, 48, 48);
    self.textLabel.frame = CGRectMake(75, ([ToMessageCell cellHeight]-48)/2, ScreenWidth-120, 30);
    NSString *badgeTip = @"";
    if (_unreadCount && _unreadCount.integerValue > 0) {
        if (_unreadCount.integerValue > 99) {
            badgeTip = @"99+";
        }else{
            badgeTip = _unreadCount.stringValue;
        }
        self.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self.contentView addBadgeTip:badgeTip withCenterPosition:CGPointMake(ScreenWidth-25, [ToMessageCell cellHeight]/2)];
}

+ (CGFloat)cellHeight
{
    return 61.0;
}

@end

#define kCellIdentifier_Conversation    @"conversationCellId"
#define kCellIdentifier_ToMessage       @"TopMessageCellId"

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
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [tableView registerClass:[ConversationCell class] forCellReuseIdentifier:kCellIdentifier_Conversation];
        [tableView registerClass:[ToMessageCell class] forCellReuseIdentifier:kCellIdentifier_ToMessage];
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self loadMessage];//加载初始消息
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageGroupUpdate object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self clearMessage];
}

- (void)loadMessage
{
    NSRange range = NSMakeRange(0, 100);
    NSMutableArray *groupMsgList = [[MessageManager shared] getMessageGroup:range];
    [self fillMessage:groupMsgList];
}

- (void)clearMessage
{
    
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
    if (indexPath.row<2) {
        //
    } else {
        PrivateMessage *msg = [priMsgList objectAtIndex:indexPath.row-2];
        BubbleChatViewController *chatController = [[BubbleChatViewController alloc] initWithUserID:msg.fromId andUserName:msg.nickName];
        [self.navigationController pushViewController:chatController animated:YES];
    }
//    UserChatItem *item = usrMsgList[indexPath.row];
//    [[MessageManager shared] updateGropuMessageStatus:item.userId];//设置状态已读
//    BubbleChatViewController *chatController = [[BubbleChatViewController alloc] initWithUserID:item.userId andUserName:item.userName];
//    [self.navigationController pushViewController:chatController animated:YES];
}

@end
