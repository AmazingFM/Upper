//
//  UPChatViewController.m
//  Upper
//
//  Created by 张永明 on 2017/2/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPChatViewController.h"
#import "UPMessageBubbleController.h"

#import "MBProgressHUD.h"
#import "PrivateMessage.h"

@interface UPChatViewController ()
@property (nonatomic, retain) UPMessageBubbleController *msgBubbleVC;
@end

@implementation UPChatViewController

- (instancetype)initWithUserID:(NSString *)userID andUserName:(NSString *)userName
{
    self = [super initWithModeSwitchButton:NO];
    if (self) {
        self.navigationItem.title = userName;
        _remote_id = userID;
        _remote_name = userName;
        _msgBubbleVC = [[UPMessageBubbleController alloc] initWithUserID:userID andUserName:userName];
        [self addChildViewController:_msgBubbleVC];
        
        [self setUpBlock];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"xxxxxx";
    [self setLayout];
}

- (void)setUpBlock
{
    __weak UPChatViewController *weakSelf = self;
    _msgBubbleVC.didScroll = ^ {
        [weakSelf.editingBar.editView resignFirstResponder];
    };
}

- (void)setLayout
{
    [self.view addSubview:_msgBubbleVC.view];
    
    for (UIView *view in self.view.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = @{@"messageBubbleTableView": _msgBubbleVC.view, @"editingBar": self.editingBar};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[messageBubbleTableView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[messageBubbleTableView][editingBar]"
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
    
    NSDictionary *headParam1 = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params1 = [NSMutableDictionary dictionaryWithDictionary:headParam1];
    [params1 setValue:@"MessageSend" forKey:@"a"];
    
    [params1 setValue:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params1 setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
    [params1 setValue:@"3" forKey:@"to_id"];//[params1 setValue:self.remote_id forKey:@"to_id"];
    [params1 setValue:@"0"forKey:@"message_type"];
    [params1 setValue:self.editingBar.editView.text forKey:@"message_desc"];
    [params1 setValue:@"" forKey:@"expire_time"];
    
    PrivateMessage *message = [[PrivateMessage alloc] init];
    
    message.source = MessageSourceMe;
    message.localMsgType = MessageTypeCommonText;
    message.local_id = [UPDataManager shared].userInfo.ID;
    message.local_name = [UPDataManager shared].userInfo.nick_name;
    message.remote_id = self.remote_id;
    message.remote_name = self.remote_name;
    message.msg_desc = self.editingBar.editView.text;
    message.status = @"1";
    message.add_time = [UPTools dateString:[NSDate date] withFormat:@"yyyyMMddHHmmss"];
    [_msgBubbleVC addMessage:message];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params1 success:^(id json) {
        
        NSDictionary *dict = (NSDictionary *)json;
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
        } else {
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
            HUD.labelText = dict[@"resp_desc"];
            [HUD hide:YES afterDelay:1];
        }
    } failture:^(id error) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
        HUD.labelText = @"网络异常，私信发送失败";
        
        [HUD hide:YES afterDelay:1];
    }];
}

@end
