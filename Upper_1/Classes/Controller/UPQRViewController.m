//
//  UPQRViewController.m
//  Upper
//
//  Created by 张永明 on 16/5/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPQRViewController.h"
#import "YMNetwork.h"
#import "AppDelegate.h"
#import "UserQueryModal.h"
#import "UPGlobals.h"
#import "Info.h"
#import "UPDataManager.h"

@implementation UPQRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
//    self.view.backgroundColor = [UIColor whiteColor];
    

    [self start2weimaRequest];
}

- (void)start2weimaRequest
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:@"UserQuery" forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"qry_usr_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            
            UserQueryModal *tmp = [UserQueryModal alloc];
            UserQueryModal *userInfo = [[UserQueryModal alloc] initWithDict:resp_data];
            
            tmp.ID = resp_data[@"id"];
            tmp.node_id = resp_data[@"node_id"];
            tmp.industry_id = resp_data[@"industry_id"];
            tmp.true_name = resp_data[@"true_name"];
            tmp.sexual = resp_data[@"sexual"];
            tmp.user_icon = resp_data[@"user_icon"];
            tmp.join_icon = resp_data[@"join_icon"];
            tmp.creator_icon = resp_data[@"creator_icon"];
            tmp.user_image = resp_data[@"user_image"];
            
            NSLog(@"id:%@, 2weima:%@", tmp.ID, tmp.user_image);
            
            //NSData *_decodedImageData   = [[NSData alloc] initWithBase64Encoding:tmp.user_image];
            NSData *_decodedImageData = [[NSData alloc] initWithBase64EncodedString:tmp.user_image options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            UIImage *_2weimaImage      = [UIImage imageWithData:_decodedImageData];
            
            NSLog(@"===Decoded image size: %@", NSStringFromCGSize(_2weimaImage.size));
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:_2weimaImage];
            imageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
            imageView.bounds = CGRectMake(0, 0, ScreenWidth-50*2, ScreenWidth-50*2);
            imageView.contentMode = UIViewContentModeScaleToFill;
            [self.view addSubview:imageView];
            
        }
        else
        {
            NSLog(@"%@", @"获取失败");
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
