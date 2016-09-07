//
//  UpSettingController.m
//  Upper_1
//
//  Created by aries365.com on 15/11/3.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//
#import "MainController.h"
#import "UpSettingController.h"

@interface UpSettingController ()

@end

@implementation UpSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightTitle:@"上海" target:self action:@selector(rightClick)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftClick
{
    [((MainController *)self.parentController).parentController leftClick];
}

-(void)rightClick
{
    
}
@end
