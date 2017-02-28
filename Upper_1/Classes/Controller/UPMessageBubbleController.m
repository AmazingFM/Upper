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

#define kPageNum 50

@interface UPMessageBubbleController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    
    NSMutableArray<PrivateMessage *> *priMsgList;
    NSString *_userID;
    NSString *_userName;
    int _pageNo;
}

@end

@implementation UPMessageBubbleController

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName
{
    self = [super init];
    if (self) {
        self.navigationItem.title = userName;
        _userID = userID;
        _userName = userName;
        _pageNo = 0;
        priMsgList = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = _userName;
    
    [self loadMessage];//加载初始消息
    
    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    [self.view addSubview:_mainTableView];
    
    [_mainTableView registerClass:[PrivateMsgCell class] forCellReuseIdentifier:kMessageBubbleOthers];
    [_mainTableView registerClass:[PrivateMsgCell class] forCellReuseIdentifier:kMessageBubbleMe];
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
    if (priMsgList.count!=0) {
        [self scrollToBottom];
    }
}

//初次加载
- (void)loadMessage
{
    [priMsgList addObjectsFromArray:[[MessageManager shared] getMessagesByUser:_userName]];
}

- (void)updateMsg:(NSNotification *)notification
{
    NSDictionary *msgGroupDict = notification.userInfo;
    NSArray<PrivateMessage *> *usrMsgList = msgGroupDict[UsrMsgKey];
    
    //更新用户信息
    if (usrMsgList.count>0) {
        @synchronized (priMsgList) {
            [priMsgList addObjectsFromArray:usrMsgList];
            [_mainTableView reloadData];
        }
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _mainTableView.frame = self.view.bounds;
}

- (void)addMessage:(PrivateMessage*)msg
{
    @synchronized (priMsgList) {
        [priMsgList addObject:msg];
        [[MessageManager shared] insertOneMessage:msg];
        
        [_mainTableView reloadData];
        [self scrollToBottom];
    }
}

- (void)scrollToBottom
{
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:priMsgList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _mainTableView && _didScroll) {_didScroll();}
}

- (void)pushUserDetails:(UIGestureRecognizer *)recognizer
{
    NSString *userID = [@(recognizer.view.tag) stringValue];
    PersonalCenterController *personInfoVC = [[PersonalCenterController alloc] init];
    personInfoVC.userID = userID;
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

#pragma mark UITableViewDelegate UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return priMsgList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *message = priMsgList[priMsgList.count-1-indexPath.row];
    
    PrivateMsgCell *cell = nil;
    if (message.source == MessageSourceMe) {
        cell = [_mainTableView dequeueReusableCellWithIdentifier:kMessageBubbleMe forIndexPath:indexPath];
        
        [cell setContent:message.msg_desc andPortrait:nil];
        cell.portrait.tag = [message.remote_id integerValue];
    } else if (message.source == MessageSourceOther) {
        cell = [_mainTableView dequeueReusableCellWithIdentifier:kMessageBubbleOthers forIndexPath:indexPath];
        
        [cell setContent:message.msg_desc andPortrait:nil];
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
