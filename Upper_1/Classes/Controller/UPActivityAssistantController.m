//
//  UPActivityAssistantController.m
//  Upper
//
//  Created by freshment on 16/9/12.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActivityAssistantController.h"
#import "UPActAsistDetailController.h"

#import "UPTools.h"

@interface UPActivityAssistantController() <UIGestureRecognizerDelegate>
{
    NSArray *assistBtnArr;
    
//    NSMutableArray *itemsArr;
}

@end

@implementation UPActivityAssistantController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    backView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backView];
    
    float verticalPadding = 8.f;
    float perHeight = (ScreenHeight-FirstLabelHeight-6*verticalPadding)/3;
    float offsety = 0;
    
    NSArray *imgArr = @[@"jhsj", @"xqsj", @"zysj"];
    for (int i=0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftRightPadding,offsety+verticalPadding, backView.size.width-2*LeftRightPadding,perHeight)];
        imageView.tag = 100+i;
        imageView.layer.cornerRadius = 10;
        imageView.layer.masksToBounds = YES;
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
    
//    itemsArr = [[NSMutableArray alloc] initWithCapacity:3];
//    
//    NSDictionary *actDict = [UPTools loadBundleFile:@"introduce.json"];
//    
//    for (NSString *key in @[@"jhsj", @"xqsj", @"zysj"]) {
//        NSArray *tmpArr = actDict[key];
//        NSMutableArray *sjArr = [NSMutableArray new];
//        for (NSDictionary *dict in tmpArr) {
//            UPActHelpItem *item = [UPActHelpItem new];
//            item.name = dict[@"name"];
//            item.desc = dict[@"desc"];
//            item.place = dict[@"place"];
//            item.tips = dict[@"tips"];
//            [sjArr addObject:item];
//        }
//        [itemsArr addObject:sjArr];
//    }
}

- (void)tap:(UITapGestureRecognizer *)gesture
{
    UIImageView *imageView = (UIImageView *)gesture.view;
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        int index = (int)imageView.tag-100;
        UPActAsistDetailController *detailVC = [[UPActAsistDetailController alloc] initWithType:index];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
@end
