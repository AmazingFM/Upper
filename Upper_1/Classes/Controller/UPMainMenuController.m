//
//  UPMainMenuController.m
//  Upper
//
//  Created by 张永明 on 16/11/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMainMenuController.h"

#import "UpperController.h"
#import "MainController.h"
#import "NewLaunchActivityController.h"
#import "UPMyFriendsViewController.h"
#import "UpMyActivityController.h"

#import "UpExpertController.h"

@interface UPMainMenuController ()

@property (nonatomic, retain) NSMutableArray<UIViewController *> *controllers;

@end

@implementation UPMainMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UpperController *uppeVC = [[UpperController alloc] init];
    MainController *hallVC = [[MainController alloc] init];
    UpExpertController *expertVC = [[UpExpertController alloc] init];
    NewLaunchActivityController *launchVC = [[NewLaunchActivityController alloc] init];
    UpMyActivityViewController *myActVC = [[UpMyActivityViewController alloc] init];
    
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
