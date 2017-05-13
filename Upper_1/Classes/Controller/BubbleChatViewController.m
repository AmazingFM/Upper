//
//  ChatController.m
//  Upper
//
//  Created by freshment on 16/6/6.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "BubbleChatViewController.h"
#import "MessageBubbleViewController.h"

#import "MessageManager.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "MJRefreshComponent.h"
//#import "UUMessageCell.h"
#import "ChatModel.h"
//#import "UUMessageFrame.h"
#import "UUMessage.h"

#import "Info.h"
#import "MBProgressHUD.h"
#import "YMNetwork.h"

@interface BubbleChatViewController ()

@property (nonatomic, retain) MessageBubbleViewController *messageBubbleVC;

@end

@implementation BubbleChatViewController

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName
{
    self = [super initWithModeSwitchButton:NO];
    if (self) {
        self.navigationItem.title = userName;
        
        _toUserId = userID;
        _messageBubbleVC = [[MessageBubbleViewController alloc] initWithUserID:userID andUserName:userName];
        [self addChildViewController:_messageBubbleVC];
        
        [self setUpBlock];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setLayout];
}

- (void)setUpBlock
{
    __weak BubbleChatViewController *weakSelf = self;
    _messageBubbleVC.didScroll = ^ {
        [weakSelf.editingBar.editView resignFirstResponder];
    };
}

- (void)setLayout
{
    [self.view addSubview:_messageBubbleVC.view];
    
    for (UIView *view in self.view.subviews) {view.translatesAutoresizingMaskIntoConstraints = NO;}
    NSDictionary *views = @{@"messageBubbleTableView": _messageBubbleVC.view, @"editingBar": self.editingBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[messageBubbleTableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[messageBubbleTableView][editingBar]"
                                                                      options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight
                                                                      metrics:nil views:views]];
}

- (void)sendContent
{
    [self.editingBar.editView resignFirstResponder];
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    HUD.labelText = @"私信发送中";
    
    NSMutableDictionary *params1 = [NSMutableDictionary new];
    [params1 setValue:@"MessageSend" forKey:@"a"];

    [params1 setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
    [params1 setValue:_toUserId forKey:@"to_id"];
    
    UPServerMsgType msgType = ServerMsgTypeNormal;
    [params1 setValue:[@(msgType) stringValue] forKey:@"message_type"];
    [params1 setValue:self.editingBar.editView.text forKey:@"message_desc"];
    [params1 setValue:@"" forKey:@"expire_time"];
    
    UUMessage *message = [[UUMessage alloc] init];
    
    message.from = UUMessageFromMe;
    message.type = UPMessageTypeNormal;
    message.strToId = [UPDataManager shared].userInfo.ID;
    message.strId = _toUserId;
    message.strContent = self.editingBar.editView.text;
    message.strName = [UPDataManager shared].userInfo.nick_name;
    message.status = @"1";
    message.strTime = [UPTools dateString:[NSDate date] withFormat:@"yyyyMMddHHmmss"];
    [_messageBubbleVC addMessage:message];

    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params1 success:^(id responseObject) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSLog(@"MessageSend, %@", dict);
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            //            NSDictionary *resp_data = dict[@"resp_data"];
            NSLog(@"send message successful!");
            self.editingBar.editView.text = @"";
            [self updateInputBarHeight];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            HUD.labelText = @"发送私信成功";
            [HUD hide:YES afterDelay:1];
        }
    } failure:^(NSError *error) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.labelText = @"网络异常，私信发送失败";
        
        [HUD hide:YES afterDelay:1];
    }];
}


@end
