//
//  UPBaseViewController.m
//  Upper
//
//  Created by freshment on 16/6/5.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "UIBarButtonItem+Badge.h"
#import "MainController.h"
#import "MessageCenterController.h"

static int kMsgCount = 0;

@interface UPBaseViewController ()
{
    UIBarButtonItem *messageItem;
}

@end

@implementation UPBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.automaticallyAdjustsScrollViewInsets=YES;
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    messageItem = [self barBtnWithIcon:@"message"];
    messageItem.badgeValue = kMsgCount==0?@"":[NSString stringWithFormat:@"%d", kMsgCount];
    messageItem.badgeBGColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem=messageItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addBadgeValue:(NSNotification *)notification
{
    NSArray *msgArr = notification.object;
    long addCount = msgArr.count;
    kMsgCount += addCount;

    messageItem.badgeValue = [NSString stringWithFormat:@"%d", kMsgCount];
}

- (void)setBadgeValue:(int)newValue
{
    messageItem.badgeValue = newValue==0?@"":[NSString stringWithFormat:@"%d", newValue];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    //
}

- (void)keyboardWillHide:(NSNotification *)note
{
    //
}

-(UIBarButtonItem*)barBtnWithIcon:(NSString*)iconName{
    UIBarButtonItem* barItem=nil;//createBarItem(iconName, self, @selector(showSideController));
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
    btn.frame=CGRectMake(0,0,32,32);
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    barItem=[[UIBarButtonItem alloc] initWithCustomView:btn];
    barItem.badgeOriginX=25;
    barItem.badgeOriginY=5;
    return barItem;
}

- (void)checkNetStatus{
//    if ([XWBaseMethod connectionInternet]==NO) {
//        [XWBaseMethod showErrorWithStr:@"网络断开了" toView:self.view];
//    }
}

-(void)rightClick
{
    MessageCenterController *msgCenterController = [[MessageCenterController alloc] init];
    [self.navigationController pushViewController:msgCenterController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
