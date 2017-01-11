//
//  UPGuideViewController.m
//  Upper
//
//  Created by 张永明 on 16/4/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPGuideViewController.h"

#import "UPGlobals.h"

#define kUPPageControlHeight 37

@interface UPGuideViewController () <UIScrollViewDelegate>
{
    UIScrollView *_guideScrollView;
    UIButton *_ignoreBtn;
    UIButton *_finishBtn;
//    UIPageControl *_pageControl;
}
    
@end

@implementation UPGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.view.backgroundColor=RGBCOLOR(28, 43, 72);
    [self initGuide];
}

- (void)initGuide
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    _guideScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    
    _guideScrollView.pagingEnabled=YES;
    _guideScrollView.backgroundColor = [UIColor clearColor];
    _guideScrollView.scrollEnabled=YES;
    _guideScrollView.bounces=NO;
//    _guideScrollView.showsHorizontalScrollIndicator = YES;
//    _guideScrollView.showsVerticalScrollIndicator = NO;
    
    
    _guideScrollView.delegate=self;
    NSArray *array = [NSArray arrayWithObjects:@"guide_p1",@"guide_p2",@"guide_p3",nil];
    
    
    for (int i=0; i<array.count; i++) {
        UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*screenWidth, 0, screenWidth, screenHeight)];
        imageView.backgroundColor=[UIColor clearColor];
        imageView.image = [UIImage imageNamed:array[i]];
        [_guideScrollView addSubview:imageView];
    }
    _guideScrollView.contentSize=CGSizeMake(screenWidth*array.count, screenHeight);
    [self.view addSubview:_guideScrollView];
    
    float btnWidth = screenWidth>320?80:60;
    float btnHeight = screenWidth>320?35:30;
    _ignoreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ignoreBtn.frame = CGRectMake(screenWidth-15-btnWidth, 15, btnWidth, btnHeight);
    _ignoreBtn.backgroundColor = [UIColor clearColor];
    [_ignoreBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [_ignoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _ignoreBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    _ignoreBtn.layer.cornerRadius = 4.0;
    _ignoreBtn.layer.borderWidth = 1.0;
    _ignoreBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _ignoreBtn.clipsToBounds = YES;
    _ignoreBtn.tag = 0;
    [_ignoreBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btnWidth = screenWidth/2;
    _finishBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _finishBtn.frame = CGRectMake((screenWidth-btnWidth)/2, screenHeight-100, btnWidth, 44);
    _finishBtn.backgroundColor = [UIColor clearColor];
    [_finishBtn setTitle:@"立即体验" forState:UIControlStateNormal];
    [_finishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _finishBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    _finishBtn.layer.cornerRadius = 23.0;
    _finishBtn.layer.borderWidth = 1.0;
    _finishBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _finishBtn.clipsToBounds = YES;
    _finishBtn.hidden = YES;
    _finishBtn.tag = 1;
    [_finishBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ignoreBtn];
    [self.view addSubview:_finishBtn];
}

- (void)buttonClick:(UIButton *)sender
{
    [self finishedLoadGuideView];
}

- (void)finishedLoadGuideView
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:YES forKey:@"firstLaunch"];
    [userDefault synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    [g_appDelegate setRootViewController];
}

#pragma mark - UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int  offset = scrollView.contentOffset.x;
    int width = ScreenWidth;
    if (offset % width == 0) {
//        _pageControl.currentPage=(int)scrollView.contentOffset.x/ScreenWidth;
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point=scrollView.contentOffset;
    int pageID=point.x/ScreenWidth;
    
    _ignoreBtn.hidden=pageID!=2?NO:YES;
    _finishBtn.hidden=pageID==2?NO:YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
