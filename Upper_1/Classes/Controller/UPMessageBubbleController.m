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
    
    NSMutableArray<PrivateMessage *> *_msglist;
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
        _msglist = [NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _msglist = [[MessageManager shared] getMessages:NSMakeRange(_pageNo, kPageNum) withUserId:_userID];
    
    _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    [self.view addSubview:_mainTableView];
    
    [_mainTableView registerClass:[PrivateMsgCell class] forCellReuseIdentifier:kMessageBubbleOthers];
    [_mainTableView registerClass:[PrivateMsgCell class] forCellReuseIdentifier:kMessageBubbleMe];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_msglist.count!=0) {
        [self scrollToBottom];
    }
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _mainTableView.frame = self.view.bounds;
}

- (void)updateMsg:(NSNotification *)notice
{
    NSMutableArray *msglist = notice.object;
    if (msglist.count!=0) {
        [self addMessages:msglist];
    }
}

- (void)addMessage:(PrivateMessage*)msg
{
    [_msglist insertObject:msg atIndex:0];
//    [[MessageManager shared] updateOneMessage:msg];
    
    [_mainTableView reloadData];
    [self scrollToBottom];
}

- (void)addMessages:(NSMutableArray *)msglist
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, msglist.count)];
    [_msglist insertObjects:msglist atIndexes:indexSet];
    [_mainTableView reloadData];
    [self scrollToBottom];
}

- (void)scrollToBottom
{
    [_mainTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_msglist.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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
    return _msglist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrivateMessage *message = _msglist[_msglist.count-1-indexPath.row];
    
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
    PrivateMessage *message = _msglist[_msglist.count-1-indexPath.row];
    
    UILabel *_label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont systemFontOfSize:15.f];
    _label.text = message.msg_desc;
    CGSize contentSize = [_label sizeThatFits:CGSizeMake(tableView.frame.size.width-85, MAXFLOAT)];
    return contentSize.height+33;
}

@end
