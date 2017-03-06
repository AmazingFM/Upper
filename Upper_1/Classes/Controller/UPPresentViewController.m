//
//  UPPresentViewController.m
//  Upper
//
//  Created by 张永明 on 2017/2/3.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPPresentViewController.h"
#import <UIKit/UIKit.h>

@interface UPPresentViewController ()
{
    UINavigationBar *_navigationBar;
}
@end

@implementation UPPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
    _navigationBar.topItem.title = self.title;
    
    UIButton* dismissBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
    [dismissBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dismissBtn.backgroundColor=[UIColor clearColor];
    dismissBtn.frame=CGRectMake(0,0,48,44);
    [dismissBtn addTarget:self action:@selector(dismissModalViewController) forControlEvents:UIControlEventTouchUpInside];
    _navigationBar.topItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:dismissBtn];
    
    if([[UIDevice currentDevice].systemVersion intValue]>=7){
        _navigationBar.barTintColor=[UIColor whiteColor];
        _navigationBar.translucent=YES;
        _navigationBar.tintColor=[UIColor blackColor];
        NSDictionary* navTitleAttr=[NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:16],NSFontAttributeName,
                                    [UIColor blackColor],NSForegroundColorAttributeName,
                                    //                                    [NSValue valueWithCGSize:CGSizeMake(2.0,2.0)],UITextAttributeTextShadowOffset,
                                    nil];
        [_navigationBar setTitleTextAttributes:navTitleAttr];
    }else {
        _navigationBar.tintColor= [UIColor clearColor];
    }
    [self.view addSubview:_navigationBar];
}

- (void)setNavigationBarTitle:(NSString *)title
{
    _navigationBar.topItem.title = title;
}
- (void)setNavigationBarTitleView:(UIView *)titleView
{
    _navigationBar.topItem.titleView = titleView;
}
- (void)setNavigationBarRightItem:(UIBarButtonItem *)item
{
    _navigationBar.topItem.rightBarButtonItem = item;
}

- (void)dismissModalViewController
{
    [self dismissModalViewController];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _navigationBar.frame = CGRectMake(0, 0, ScreenWidth, 64);
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
