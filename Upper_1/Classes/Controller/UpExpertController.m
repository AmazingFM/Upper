//
//  UpExpertController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//
#import "AFHTTPRequestOperationManager.h"
#import "MainController.h"
#import "UpExpertController.h"
#import "UpExpertView.h"
#import "CityItem.h"

@interface UpExpertController ()

@property (nonatomic, retain) UIButton *leftButton;

- (void)makeAction:(id)sender;
@end

@implementation UpExpertController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"专家社区";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightTitle:@"上海" target:self action:@selector(rightClick)];
    
    self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, FirstLabelHeight, 100, 22)];
    [self.leftButton setTitle:@"专家社区" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.leftButton.tag = 0;
    self.leftButton.backgroundColor = [UIColor clearColor];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.leftButton addTarget:self action:@selector(makeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-100, FirstLabelHeight, 100, 22)];
    [rightButton setTitle:@"精彩活动" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.tag = 1;
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightButton addTarget:self action:@selector(makeAction:) forControlEvents:UIControlEventTouchUpInside];

    CGFloat y = self.leftButton.frame.origin.y+self.leftButton.frame.size.height+20;
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, ScreenWidth-20*2, 17)];
    
    NSString *tipsText = @"覆盖30个行业，注册专家超过10000个";
    tipsLabel.text = tipsText;
    tipsLabel.font = [UIFont systemFontOfSize:13];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.backgroundColor = [UIColor redColor];
    
    
    UIScrollView *activitiesScro = [[UIScrollView alloc] initWithFrame:CGRectMake(20, tipsLabel.frame.origin.y+tipsLabel.height+20, ScreenWidth-20*2, ScreenHeight-y-17-5)];
    activitiesScro.showsHorizontalScrollIndicator = NO;
    activitiesScro.showsVerticalScrollIndicator = YES;
    activitiesScro.scrollEnabled = YES;
    CGFloat scroWidth = activitiesScro.width;
    CGFloat scroHeight = activitiesScro.height;

    int rowNum = 10;
    for (int i = 0; i < rowNum; i++) {
        UpExpertView *expertV = [[UpExpertView alloc]initWithFrame:CGRectMake(0, i*(scroHeight/10+5), scroWidth,scroHeight/10)];
        [activitiesScro addSubview:expertV];
    }
    [activitiesScro setContentSize:CGSizeMake(scroWidth, (scroHeight/10+5)*rowNum)];
    //activitiesScro.delegate = self;
    [self.view addSubview:self.leftButton];
    [self.view addSubview:rightButton];
    [self.view addSubview:tipsLabel];
    [self.view addSubview:activitiesScro];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)startRequest
{

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

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)makeAction:(id)sender
{

}

@end
