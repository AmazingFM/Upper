//
//  MessageBubbleViewController.m
//  Upper
//
//  Created by 张永明 on 16/11/13.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "MessageBubbleViewController.h"
#import "PersonalCenterController.h"
#import "UPMsgBubbleCell.h"

#import "UUMessage.h"
#import "MessageManager.h"
#import "MBProgressHUD.h"

#define kPageNum 50
@interface MessageBubbleViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    
    NSMutableArray<UUMessage *> *_msglist;
    NSString *_userID;
    NSString *_userName;
    int _pageNo;
}

@end

@implementation MessageBubbleViewController

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName
{
    self = [super init];
    if (self) {
        self.navigationItem.title = userName;
        
        _userID = userID;
        _userName = userName;
        
        _pageNo = 0;
        _msglist = [NSMutableArray new];
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
    
    [_mainTableView registerClass:[UPMsgBubbleCell class] forCellReuseIdentifier:kMessageBubbleOthers];
    [_mainTableView registerClass:[UPMsgBubbleCell class] forCellReuseIdentifier:kMessageBubbleMe];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
}

- (void)updateMsg:(NSNotification *)notice
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *msglist = notice.object;
        if (msglist.count!=0) {
            [self addMessages:msglist];
        }
    });
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _msglist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUMessage *message = _msglist[_msglist.count-1-indexPath.row];
    
    UPMsgBubbleCell *cell = nil;
    if (message.from == UUMessageFromMe) {
        cell = [_mainTableView dequeueReusableCellWithIdentifier:kMessageBubbleMe forIndexPath:indexPath];
        
        [cell setContent:message.strContent andPortrait:nil];
        cell.portrait.tag = [message.strId integerValue];
    } else if (message.from == UUMessageFromOther) {
        cell = [_mainTableView dequeueReusableCellWithIdentifier:kMessageBubbleOthers forIndexPath:indexPath];
        
        [cell setContent:message.strContent andPortrait:nil];
        cell.portrait.tag = [message.strToId integerValue];
    }
    [cell.portrait addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserDetails:)]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUMessage *message = _msglist[_msglist.count-1-indexPath.row];
    
    UILabel *_label = [UILabel new];
    _label.numberOfLines = 0;
    _label.lineBreakMode = NSLineBreakByWordWrapping;
    _label.font = [UIFont systemFontOfSize:15.f];
    _label.text = message.strContent;
    CGSize contentSize = [_label sizeThatFits:CGSizeMake(tableView.frame.size.width-85, MAXFLOAT)];
    return contentSize.height+33;
}

- (void)pushUserDetails:(UIGestureRecognizer *)recognizer
{
    NSString *userID = [@(recognizer.view.tag) stringValue];
    PersonalCenterController *personInfoVC = [[PersonalCenterController alloc] init];
    personInfoVC.user_id = userID;
    [self.navigationController pushViewController:personInfoVC animated:YES];
}

- (void)addMessage:(UUMessage *)msg
{
    [_msglist insertObject:msg atIndex:0];
    [[MessageManager shared] updateOneMessage:msg];

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
