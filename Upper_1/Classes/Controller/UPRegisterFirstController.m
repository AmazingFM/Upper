//
//  UPRegisterFirstController.m
//  Upper
//
//  Created by 张永明 on 2017/10/31.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRegisterFirstController.h"
#import "UPRegisterSecondController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "ButtonGroupView.h"
#import "CityCell.h"
#import "UPConfig.h"
#import "DrawSomething.h"

#define BtnSpace 40
@interface UPRegisterFirstController () <UITableViewDelegate, UITableViewDataSource, CityCellDelegate>
{
    UIView *_tipsView;
    UILabel *_tipsLab;
    NSTimer *_timer;
    NSIndexPath *_indexPath;
}

@property (nonatomic, retain) NSMutableArray *arrayLocatingCity;
@property (nonatomic, retain) NSMutableArray *arrayHotCity;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) ButtonGroupView *locatingCityGV;
@property (nonatomic, retain) ButtonGroupView *hotCityGV;
@property (nonatomic, retain) UIView *tableHeaderView;

@property (nonatomic, retain) NSString *cityId;
@property (nonatomic, retain) NSString *provId;
@property (nonatomic, retain) NSString *townId;

@property (nonatomic,retain) UILabel *tipsLabel;
@property (nonatomic, retain) UIButton *nextBtn;
@end

@implementation UPRegisterFirstController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册";
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    
    CGFloat y = FirstLabelHeight;
    
    NSString *tipsText = @"Step1:选择城市";
    CGSize tipsSize = SizeWithFont(tipsText, [UIFont systemFontOfSize:12]);
    
    self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, tipsSize.width+5, tipsSize.height)];
    
    self.tipsLabel.text = tipsText;
    self.tipsLabel.font = [UIFont systemFontOfSize:12];
    self.tipsLabel.textColor = [UIColor whiteColor];
    self.tipsLabel.backgroundColor = [UIColor blackColor];
    
    CGSize size = SizeWithFont(@"下一步",kUPThemeMiddleFont);
    size.width +=20;
    size.height += 10;

    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.tag = 12;
    self.nextBtn.titleLabel.font = kUPThemeMiddleFont;
    self.nextBtn.frame = CGRectMake(ScreenWidth-BtnSpace-size.width, ScreenHeight-size.height-20, size.width, size.height);
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    self.nextBtn.backgroundColor = [UIColor whiteColor];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.layer.masksToBounds = YES;
    [_tableView.layer setCornerRadius:5.0];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _arrayHotCity = [NSMutableArray array];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setFd_interactivePopDisabled:YES];
}

- (void)leftClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initHeaderView
{
    _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 250)];
    _tableHeaderView.backgroundColor = [UIColor clearColor];
    
    //热门城市
    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, _locatingCityGV.frame.origin.y+_locatingCityGV.frame.size.height+10, 160, 21)];
    title3.text = @"热门城市";
    title3.font = [UIFont systemFontOfSize:15];
    [_tableHeaderView addSubview:title3];
    
    [_arrayHotCity removeAllObjects];
    [_arrayHotCity addObjectsFromArray:[self GetCityDataSoucre:[[UPConfig sharedInstance].cityContainer getHotCityInfo] withCount:12]];
    long row = _arrayHotCity.count/3;
    if (_arrayHotCity.count%3 > 0) {
        row += 1;
    }
    CGFloat hotViewHight = 45*row;
    _hotCityGV = [[ButtonGroupView alloc]initWithFrame:CGRectMake(0, title3.frame.origin.y+title3.frame.size.height+10, _tableHeaderView.frame.size.width, hotViewHight)];
    _hotCityGV.backgroundColor = [UIColor clearColor];
    _hotCityGV.delegate = self;
    _hotCityGV.columns = 3;
    _hotCityGV.items = _arrayHotCity;
    [_tableHeaderView addSubview:_hotCityGV];
    
    
    _tableHeaderView.frame = CGRectMake(LeftRightPadding, 0, _tableView.frame.size.width-2*LeftRightPadding, _hotCityGV.frame.origin.y+_hotCityGV.frame.size.height);
    _tableView.tableHeaderView.frame = _tableHeaderView.frame;
    _tableView.tableHeaderView = _tableHeaderView;
}

- (NSArray*)GetCityDataSoucre:(NSArray*)ary withCount:(int)cnt
{
    NSMutableArray *cityAry = [[NSMutableArray alloc]init];
    for (int i=0; i<cnt&&i<ary.count; i++) {
        CityInfo *cityInfo = ary[i];
        CityItem *cityItem = [[CityItem alloc] init];
        cityItem.cityInfo = cityInfo;
        
        [cityAry addObject:cityItem];
    }
    
    return cityAry;
}

#pragma mark-tableView
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SectionHeaderHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, SectionHeaderHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, 0, _tableView.frame.size.width-30, SectionHeaderHeight)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.text = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[section].firstLetter;
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    __block NSMutableArray *indexNumber = [NSMutableArray new];
    [[UPConfig sharedInstance].cityContainer.alphaCityInfoArr enumerateObjectsUsingBlock:^(AlphabetCityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexNumber addObject:obj.firstLetter];
    }];
    return indexNumber;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[UPConfig sharedInstance].cityContainer.alphaCityInfoArr count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    [self showTipsWithTitle:title];
    return index;
}

- (void)showTipsWithTitle:(NSString*)title
{
    
    //获取当前屏幕window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!_tipsView) {
        //添加字母提示框
        _tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _tipsView.center = window.center;
        _tipsView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.8];
        //设置提示框圆角
        _tipsView.layer.masksToBounds = YES;
        _tipsView.layer.cornerRadius  = _tipsView.frame.size.width/20;
        _tipsView.layer.borderColor   = [UIColor whiteColor].CGColor;
        _tipsView.layer.borderWidth   = 2;
        [window addSubview:_tipsView];
    }
    if (!_tipsLab) {
        //添加提示字母lable
        _tipsLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _tipsView.frame.size.width, _tipsView.frame.size.height)];
        //设置背景为透明
        _tipsLab.backgroundColor = [UIColor clearColor];
        _tipsLab.font = [UIFont boldSystemFontOfSize:50];
        _tipsLab.textAlignment = NSTextAlignmentCenter;
        
        [_tipsView addSubview:_tipsLab];
    }
    _tipsLab.text = title;//设置当前显示字母
    
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(hiddenTipsView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)hiddenTipsView
{
    [UIView animateWithDuration:0.2f animations:^{
        _tipsView.alpha = 0;
    } completion:^(BOOL finished){
        [_tipsView removeFromSuperview];
        _tipsLab = nil;
        _tipsView = nil;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AlphabetCityInfo *alphaCityInfo = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[section];
    return [alphaCityInfo.citylist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    if (cell == nil) {
        cell = [[CityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
        
        cell.delegate = self;
    }
    
    AlphabetCityInfo *alphaCityInfo = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[indexPath.section];
    CityInfo *cityInfo = [alphaCityInfo.citylist objectAtIndex:indexPath.row];
    CityItem *cityItem = [[CityItem alloc] init];
    cityItem.cityInfo = cityInfo;
    cityItem.width = ScreenWidth;
    cityItem.height = CellHeightDefault;
    cityItem.indexPath = indexPath;
    [cell setCityItem:cityItem];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CityCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self cityCellSelected:cell didClickItem:cell.item];
}

- (void)cityCellSelected:(CityCell *)cell didClickItem:(CityItem *)item
{
    _cityId = item.cityInfo.city_code;
    _provId = item.cityInfo.province_code;
    _townId = item.cityInfo.town_code;
    
    for (CityButton *obj in _hotCityGV.buttons) {
        obj.selected = NO;
    }
    
    if (_indexPath!=nil) {
        CityCell *lastCell = [self.tableView cellForRowAtIndexPath:_indexPath];
        [lastCell setSelected:NO animated:YES];
    }
    [cell setSelected:YES animated:YES];
    _indexPath = item.indexPath;
}

-(void)ButtonGroupView:(ButtonGroupView *)buttonGroupView didClickedItem:(CityButton *)item
{
    _cityId = item.cityItem.cityInfo.city_code;
    _provId = item.cityItem.cityInfo.province_code;
    _townId = item.cityItem.cityInfo.town_code;
    
    for (CityButton *obj in buttonGroupView.buttons) {
        obj.selected = NO;
    }
    if (_indexPath!=nil) {
        CityCell *lastCell = [self.tableView cellForRowAtIndexPath:_indexPath];
        [lastCell setSelected:NO animated:YES];
    }
    item.selected = YES;
}

- (void)loadAlphabetCitInfo
{
    [self initHeaderView];
    [_tableView reloadData];
}

-(void)clearValue
{
    _cityId=nil;
}

- (void)nextStep:(UIButton *)nextButton
{
    if (_cityId==nil || _cityId.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择城市" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    
    UPRegisterSecondController *secondController = [[UPRegisterSecondController alloc] init];
    secondController.cityId = self.cityId;
    secondController.provId = self.provId;
    secondController.townId = self.townId;
    [self.navigationController pushViewController:secondController animated:YES];
}

@end
