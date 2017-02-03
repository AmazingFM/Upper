//
//  UPRulesController.m
//  Upper
//
//  Created by 张永明 on 2017/2/3.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRulesController.h"
#import "UPGlobals.h"

@interface UPRulesController ()
{
    UITextView *_rulesTextView;
}

@end

@implementation UPRulesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rulesTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,44, ScreenWidth, ScreenHeight)];
    _rulesTextView.font = kUPThemeNormalFont;
    
    _rulesTextView.textAlignment = NSTextAlignmentLeft;
    _rulesTextView.textColor = [UIColor blackColor];
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
