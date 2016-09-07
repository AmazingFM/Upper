//
//  UpLeftMenu.m
//  Upper_1
//
//  Created by aries365.com on 15/10/29.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpLeftMenu.h"
#import "UpLeftButton.h"
#import "UPTheme.h"

@interface UpLeftMenu ()

@property (nonatomic,weak) UpLeftButton* selectedButton;
@property (nonatomic,strong) NSMutableArray *buttonArr;

@property (nonatomic, strong) NSMutableArray *arrowArr;

@property (nonatomic,weak) UIScrollView *backgroundScroll;

@end

@implementation UpLeftMenu

-(NSMutableArray *)buttonArr
{
    if(_buttonArr==nil){
        _buttonArr=[NSMutableArray array];
    }
    return _buttonArr;
}

-(NSMutableArray *)arrowArr
{
    if(_arrowArr==nil){
        _arrowArr = [NSMutableArray array];
    }
    return _arrowArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //1.清空背景色
        self.backgroundColor=[UIColor clearColor];
        //2.添加背景滚动图
        [self setupScrollView];
        
        UIImage *image = [UIImage imageNamed:@"logo"];
        UIImageView *logoView = [[UIImageView alloc]initWithImage:image];
        //logoView.backgroundColor = [UIColor greenColor];
        logoView.frame = CGRectMake(30, 50, 200, 50);
        logoView.layer.masksToBounds = YES;
        logoView.contentMode = UIViewContentModeScaleAspectFit;
        
        logoView.image = image;
        [self.backgroundScroll addSubview:logoView];
        
        CGFloat alpha=0.0;
        [self setupBtnWithIcon:@"sidebar_ad" title:@"Upper" bgColor:RGBACOLOR(202, 68, 73, alpha) ];
        [self setupBtnWithIcon:@"sidebar_ad" title:@"活动大厅" bgColor:RGBACOLOR(202, 68, 73, alpha)];
        [self setupBtnWithIcon:@"sidebar_ad" title:@"专家社区" bgColor:RGBACOLOR(202, 68, 73, alpha)];
        [self setupBtnWithIcon:@"sidebar_ad" title:@"发起活动" bgColor:RGBACOLOR(202, 68, 73, alpha)];
        [self setupBtnWithIcon:@"sidebar_ad" title:@"我的位置" bgColor:RGBACOLOR(202, 68, 73, alpha)];
        [self setupBtnWithIcon:@"sidebar_ad" title:@"我的活动" bgColor:RGBACOLOR(202, 68, 73, alpha)];
    }
    return self;
}

#pragma mark 添加背景滚动图
-(void)setupScrollView
{
    UIScrollView *backgroundScroll = [[UIScrollView alloc]init];
    backgroundScroll.showsHorizontalScrollIndicator=NO;
    backgroundScroll.showsVerticalScrollIndicator=NO;
    backgroundScroll.contentSize = CGSizeMake(self.width, ScreenHeight+0.5);
    [self addSubview:backgroundScroll];
    self.backgroundScroll=backgroundScroll;
}

- (UIButton *)setupBtnWithIcon:(NSString *)icon title:(NSString *)title bgColor:(UIColor *)bgColor 
{
    //1。创建按钮
    UpLeftButton *btn = [[UpLeftButton alloc] init];
    
    btn.tag = self.subviews.count;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backgroundScroll addSubview:btn];
    
    // 设置图片和文字
    [btn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [btn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    btn.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, 0);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    
    // 设置按钮选中的背景
    [btn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateSelected];
    
    // 设置高亮的时候不要让图标变色
    btn.adjustsImageWhenHighlighted = NO;
    
    // 设置按钮的内容左对齐
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    
    // 设置间距
    btn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
    btn.contentEdgeInsets=UIEdgeInsetsMake(0, 30, 0, 0);
    //在按钮右边添加一个>号
    UIImageView *arrow=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_navigation_back_photo"]];
    [btn addSubview:arrow];
    [self.arrowArr addObject:arrow];
    //把按钮存放到数组中
    [self.buttonArr addObject:btn];
    //如果是第一个按钮默认选中
    if(self.buttonArr.count==1){
        [self buttonClick:btn];
    }
    return btn;
}

#pragma mark 按钮的点击事件
-(void)buttonClick:(UpLeftButton*)sender
{
    if([self.delegate respondsToSelector:@selector(leftMenu:didSelectedFrom:to:)]){
        [self.delegate leftMenu:self didSelectedFrom:self.selectedButton.tag to:sender.tag+1];
    }
    self.selectedButton.selected=NO;
    sender.selected=YES;
    self.selectedButton=sender;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //1.设置背景滚动视图的frame
    self.backgroundScroll.frame=self.bounds;
    //2.设置按钮的frame   按钮上面>的frame
    int btnCount = (int)self.buttonArr.count;
    CGFloat btnW = self.width;
    CGFloat btnH = 0;//self.height / btnCount;
    if(iPhone6 || iPhone6P || iPhone5){
        btnH=60;
    }else{
        btnH=50;
    }
    CGFloat leftMenuButtonY = ScreenHeight/2-btnH*2;
    
    CGFloat arrowW= 30;  //箭头的宽
    CGFloat arrowH=arrowW;   //箭头哦的高
    for (int i = 0; i<btnCount; i++) {
        UIButton *btn = self.buttonArr[i];
        btn.width = btnW;
        btn.height = btnH;
        btn.y = i * btnH+leftMenuButtonY;
        btn.tag=i; //传递tag给button
        UIImageView *arrow=self.arrowArr[i];
        CGFloat arrowX=btn.width-arrowW-10;
        CGFloat arrowY=(btn.height-arrowH)*0.5;
        arrow.frame=CGRectMake(arrowX, arrowY, arrowW, arrowH);
    }
    
    
}

@end
