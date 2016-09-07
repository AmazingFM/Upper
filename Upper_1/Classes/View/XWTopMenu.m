//
//  XWTopMenu.m
//  新闻
//
//  Created by user on 15/9/4.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "XWTopMenu.h"
#import "Info.h"
#import "UPGlobals.h"

@interface XWTopMenu ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSourceFirst;
@property (nonatomic, strong) NSMutableArray *allDataSource;
@property (nonatomic, assign) BOOL tableViewShow;
@property (nonatomic, assign) NSInteger lastSelectedIndex;
@property (nonatomic, strong) NSMutableArray *bgLayers;

@end

@implementation XWTopMenu


- (void)createMenuTitleArray:(NSArray *)menuTitleArray dataSource:(NSArray *)dataArr
{
    [self setupMenu:menuTitleArray];
    for (int i = 0; i<menuTitleArray.count; i++) {
        [self.allDataSource addObject:dataArr[i]];
    }
    
    [self createTableViewFirst];
}


- (void)showCarverView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, ScreenHeight-self.frame.origin.y);
    }];
}

- (void)hideCarverView
{
    [UIView animateWithDuration:0.1 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, selectMenuH);
        
    }];
    
}

- (void)remover{
    CALayer *layer = self.bgLayers[self.lastSelectedIndex-100];
    layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
    
    self.tableViewShow = NO;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), ScreenWidth/2, 0);
    }];

    [self hideCarverView];
}

- (void)showFirstTableView:(UIButton *)btn{
    if (self.lastSelectedIndex != btn.tag && self.lastSelectedIndex !=-1) {
        CALayer *layer = self.bgLayers[self.lastSelectedIndex-100];
        layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), ScreenWidth/2, 0);
            
        }completion:^(BOOL finished) {
            
            self.tableViewShow = NO;
            [self showFirstAndSecondTableView:btn.tag];
        }];
        
    }else{
        [self showFirstAndSecondTableView:btn.tag];
    }
}

- (void)createTableViewFirst
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.width, 0) style:UITableViewStylePlain];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self insertSubview:self.tableView belowSubview:self.backView];
}

- (void)showFirstAndSecondTableView:(NSInteger)index{
    
    [self changeMenuDataWithIndex:index-100];
    
    if (self.tableViewShow == NO) {
        
        self.tableViewShow = YES;
        [self showCarverView];
        CALayer *layer = self.bgLayers[index-100];
        layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
        
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.width, selectMenuH*self.dataSourceFirst.count);
        }];
        
    }else{
        
        CALayer *layer = self.bgLayers[index-100];
        layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
        self.tableViewShow = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), self.width, 0);
        }];
        [self hideCarverView];
        
    }
    self.lastSelectedIndex = index;
}


- (void)changeMenuDataWithIndex:(NSInteger)index{
    [self createWithFirstData:self.allDataSource[index]];
}

- (void)createWithFirstData:(NSArray *)dataFirst
{
    self.dataSourceFirst = [NSMutableArray arrayWithArray:dataFirst];
    [self.tableView reloadData];
}


- (CALayer *)createBgLayerWithColor:(UIColor *)color andPosition:(CGPoint)position{
    CALayer *layer = [CALayer layer];
    layer.position = position;
    layer.bounds = CGRectMake(0, 0, 20, 20);
    layer.backgroundColor = color.CGColor;
    return layer;
}

- (CAShapeLayer *)createIndicatorWithColor:(UIColor *)color andPosition:(CGPoint)point
{
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(8, 0)];
    [path addLineToPoint:CGPointMake(4, 5)];
    [path closePath];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.8;
    layer.fillColor = [UIColor colorWithRed:0xcc/255.0 green:0xcc/255.0 blue:0xcc/255.0 alpha:0xcc/255.0].CGColor;
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    CGPathRelease(bound);
    layer.position = point;
    
    return layer;
}

//添加按钮
-(void)setupMenu:(NSArray *)menuTitleArray
{
    
    self.lastSelectedIndex = -1;
    self.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.2];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.width, selectMenuH);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remover)];
    [self addGestureRecognizer:tap];
    tap.delegate = self;
    
    self.bgLayers = [[NSMutableArray alloc]init];
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, selectMenuH)];
    self.backView.userInteractionEnabled = YES;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    
    NSInteger num = menuTitleArray.count;
    for (int i = 0; i < num; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.width/num*i, 0, self.width/num-1, selectMenuH)];
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:menuTitleArray[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(showFirstTableView:) forControlEvents:UIControlEventTouchUpInside];
        
        CGPoint bgLayerPoint = CGPointMake(self.width/num-30, selectMenuH/2);
        CALayer *bgLayer = [self createBgLayerWithColor:[UIColor clearColor] andPosition:bgLayerPoint];
        CGPoint indicatorPoint = CGPointMake(10, 10);
        CAShapeLayer *indicator = [self createIndicatorWithColor:[UIColor lightGrayColor] andPosition:indicatorPoint];
        [bgLayer addSublayer:indicator];
        
        [self.bgLayers addObject:bgLayer];
        [btn.layer addSublayer:bgLayer];
        
        UILabel *lineLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 4, 1, selectMenuH-8)];
        lineLb.backgroundColor = [UIColor lightGrayColor];
        if (i == num - 1) {
            lineLb.hidden = YES;
        }
        [self.backView addSubview:btn];
        [self.backView insertSubview:lineLb aboveSubview:btn];
    }
    
    UILabel *VlineLbTop = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.backView.frame.size.width, 1)];
    VlineLbTop.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *VlineLbBom = [[UILabel alloc]initWithFrame:CGRectMake(0, selectMenuH, self.backView.frame.size.width, 1)];
    VlineLbBom.backgroundColor = [UIColor lightGrayColor];
    
    [self.backView addSubview:VlineLbTop];
    [self.backView addSubview:VlineLbBom];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceFirst.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellFirst";
    UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell1 == nil) {
        cell1 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    int i = indexPath.row;
    cell1.textLabel.text = self.dataSourceFirst[indexPath.row];
    cell1.textLabel.font = [UIFont systemFontOfSize:12];
    
    //cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell1.accessoryType = UITableViewCellAccessoryNone;
    return cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CALayer *layer = self.bgLayers[self.lastSelectedIndex-100];
    layer.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1);
    
    UIButton *btn = (id)[self viewWithTag:self.lastSelectedIndex];
    [btn setTitle:self.dataSourceFirst[indexPath.row] forState:UIControlStateNormal];
    self.tableViewShow = NO;

    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = CGRectMake(ScreenWidth/2,CGRectGetMaxY(self.backView.frame), ScreenWidth/2, 0);
    }];
    [self hideCarverView];

    [_delegate topMenu:self menuType:self.lastSelectedIndex-100 andDetailIndex:indexPath.row];
}


- (NSMutableArray *)allDataSource
{
    if (_allDataSource == nil) {
        _allDataSource = [NSMutableArray array];
    }
    return _allDataSource;
}

@end
