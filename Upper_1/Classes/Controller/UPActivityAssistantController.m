//
//  UPActivityAssistantController.m
//  Upper
//
//  Created by freshment on 16/9/12.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActivityAssistantController.h"

@interface UPActivityAssistantController() <UIGestureRecognizerDelegate>
{
    NSArray *assistBtnArr;
}

@end

@implementation UPActivityAssistantController

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    float verticalPadding = 0.f;
    float perHeight = (ScreenHeight-FirstLabelHeight-6*verticalPadding)/3;
    float offsety = 0;
    
    NSArray *imgArr = @[@"assist1", @"assist2", @"assist3"];
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftRightPadding,offsety+verticalPadding, backView.size.width-2*LeftRightPadding,perHeight)];
        imageView.tag = 100+i;
        imageView.backgroundColor = [UIColor clearColor];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [imageView setImage:[UIImage imageNamed:imgArr[i]]];
        [imageView setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [singleTap setNumberOfTapsRequired:1];
        [singleTap setNumberOfTouchesRequired:1];
        [imageView addGestureRecognizer:singleTap];
        
        [backView addSubview:imageView];
        
        offsety += 2*verticalPadding+perHeight;
    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        NSArray *title = @[@"兴趣社交", @"专业社交", @"聚会社交"];
        [[[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"你点击了%@", title[imageView.tag-100]] delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
    }
}
@end
