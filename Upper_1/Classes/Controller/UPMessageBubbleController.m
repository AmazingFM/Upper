//
//  UPMessageBubbleController.m
//  Upper
//
//  Created by 张永明 on 2017/2/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPMessageBubbleController.h"
#import "PersonalCenterController.h"

#import "PrivateMsgCell.h"
#import "PrivateMessage.h"
#import "MessageManager.h"
#import "MBProgressHUD.h"
#import "YMNetwork.h"

#define kPageNum 50

@interface UPMessageBubbleController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    
    NSMutableArray<PrivateMessage *> *priMsgList;
    NSString *_userID;
    NSString *_userName;
    NSString *_userIcon;
    int _pageNo;
}

@end

@implementation UPMessageBubbleController

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName andUserIcon:(NSString *)userIcon
{
    self = [super init];
    if (self) {
        self.navigationItem.title = userName;
        _userID = userID;
        _userName = userName;
        _userIcon = userIcon;
        _pageNo = 0;
        priMsgList = [NSMutableArray new];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _userName;
    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    [self.view addSubview:_mainTableView];
    
    [_mainTableView registerClass:[PrivateMsgCell class] forCellReuseIdentifier:kMessageBubbleOthers];
    [_mainTableView registerClass:[PrivateMsgCell class] forCellReuseIdentifier:kMessageBubbleMe];
    
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showTime)];
    longpress.minimumPressDuration = 5;
    [self.view addGestureRecognizer:longpress];
}

- (void)showTime
{
    NSMutableString *msgStr = [[NSMutableString alloc] init];
    for (int i=0; i<priMsgList.count; i++) {
        PrivateMessage *priMsg = priMsgList[i];
        [msgStr appendFormat:@"%d:%@-%@\n", i, priMsg.msg_desc, priMsg.add_time];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"帮助" message:msgStr delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)userInfoRequest
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"UserQuery"forKey:@"a"];
    [params setObject:_userID forKey:@"qry_usr_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            //处理
            OtherUserData *user = [[OtherUserData alloc] initWithDict:dict[@"resp_data"]];
            [self loadRemoteIcon:user];
        }
    } failure:^(NSError *error) {
    }];
}

-(void)loadRemoteIcon:(OtherUserData *)otherUser
{
    _userIcon = otherUser.user_icon;
    [_mainTableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadMessage];//加载初始消息
    [_mainTableView reloadData];
    
    if (priMsgList.count!=0) {
        [self scrollToBottom:YES];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
    
    [self userInfoRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//初次加载
- (void)loadMessage
{
    @synchronized (priMsgList) {
        [priMsgList addObjectsFromArray:[[MessageManager shared] getMessagesByUser:_userID]];
    }
}

- (void)updateMsg:(NSNotification *)notification
{
    @synchronized (priMsgList) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *msgGroupDict = notification.userInfo;
            NSArray<PrivateMessage *> *usrMsgList = msgGroupDict[UsrMsgKey];
            
            //更新用户信息
            if (usrMsgList.count>0) {
                NSMutableArray<PrivateMessage *> *myMsgs = [NSMutableArray new];
                for (PrivateMessage *msg in usrMsgList) {
                    if ([msg.remote_id isEqualToString:_userID]) {
                        [myMsgs addObject:msg];
                    }
                }
                
                if (myMsgs.count>0) {
                    [priMsgList addObjectsFromArray:myMsgs];
                    [_mainTableView reloadData];
                    [self scrollToBottom:YES];
                }
            }
        });
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _mainTableView.frame = self.view.bounds;
    [self scrollToBottom:NO];
}

- (void)addMessage:(PrivateMessage*)msg
{
    @synchronized (priMsgList) {
        [priMsgList addObject:msg];
        [[MessageManager shared] insertOneMessage:msg];
        
        [_mainTableView reloadData];
        [self scrollToBottom:YES];
    }
}

- (void)scrollToBottom:(BOOL)animated
{
    NSInteger rows = [_mainTableView numberOfRowsInSection:0];
    if (rows > 0) {
            [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainTableView && _didScroll) {_didScroll();}
}

- (void)pushUserDetails:(UIGestureRecognizer *)recognizer
{
    NSString *userID = [@(recognizer.view.tag) stringValue];
    PersonalCenterController *personInfoVC = [[PersonalCenterController alloc] init];
    personInfoVC.user_id = _userID;
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

#pragma mark UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return priMsgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *message = priMsgList[indexPath.row];
    
    PrivateMsgCell *cell = nil;
    if (message.source == MessageSourceMe) {
        cell = [_mainTableView dequeueReusableCellWithIdentifier:kMessageBubbleMe forIndexPath:indexPath];
        
        [cell setContent:message.msg_desc andPortrait:[UPDataManager shared].userInfo.user_icon];
        cell.portrait.tag = [message.remote_id integerValue];
    } else if (message.source == MessageSourceOther) {
        cell = [_mainTableView dequeueReusableCellWithIdentifier:kMessageBubbleOthers forIndexPath:indexPath];
        
        [cell setContent:message.msg_desc andPortrait:_userIcon];
        cell.portrait.tag = [message.remote_id integerValue];
    }
    [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetails:)]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *message = priMsgList[priMsgList.count-1-indexPath.row];
    
    UILabel *_label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont systemFontOfSize:15.f];
    _label.text = message.msg_desc;
    CGSize contentSize = [_label sizeThatFits:CGSizeMake(tableView.frame.size.width-85, MAXFLOAT)];
    return contentSize.height+33;
}

@end
