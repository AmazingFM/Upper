//
//  ChatController.m
//  Upper
//
//  Created by freshment on 16/6/6.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "ChatController.h"

#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"

#import "Info.h"


@interface ChatController () <UUInputFunctionViewDelegate,UUMessageCellDelegate, UITableViewDelegate, UITableViewDataSource>
{
    MJRefreshComponent *myRefreshView;
}
@property (strong, nonatomic) ChatModel *chatModel;

@property (strong, nonatomic) UITableView *chatTableView;
@property (weak, nonatomic) NSLayoutConstraint *bottomConstraint;

@end

@implementation ChatController
{
    UUInputFunctionView *IFView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self createTable];
    [self initBar];
    [self addRefreshViews];
    [self loadBaseViewsAndData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //add notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMsg:) name:kNotifierMessageComing object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createTable
{
    CGRect bounds = CGRectMake(0,64, ScreenWidth, ScreenHeight-64-40);
    self.chatTableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStylePlain];
    self.chatTableView.separatorColor = [UIColor grayColor];
    self.chatTableView.delegate = self;
    self.chatTableView.dataSource = self;
    self.chatTableView.backgroundColor = [UIColor whiteColor];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.chatTableView];
}
- (void)initBar
{
    self.navigationItem.title = self.toUserName;
    
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
}

- (void)addRefreshViews
{
    __weak typeof(self) weakSelf = self;
    
    //load more
    int pageNum = 3;

    self.chatTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.chatModel addRandomItemsToDataSource:pageNum];
        
        myRefreshView = weakSelf.chatTableView.header;
        myRefreshView.autoChangeAlpha = YES;
        if (weakSelf.chatModel.dataSource.count > pageNum) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:pageNum inSection:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.chatTableView reloadData];
                [weakSelf.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
        }
        [myRefreshView endRefreshing];
    }];
}

- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource:self.toUserId];
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    IFView.delegate = self;
    [self.view addSubview:IFView];
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40;
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = IFView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
    return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic];
}

- (void)dealTheFunctionData:(NSDictionary *)dic
{
    [self.chatModel addSpecifiedItem:dic];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

#pragma mark - tableView delegate & datasource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}


@end
