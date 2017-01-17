//
//  NewLaunchActivityController.m
//  Upper
//
//  Created by 张永明 on 16/8/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "NewLaunchActivityController.h"
#import "RecommendController.h"
#import "UPActTypeController.h"
#import "DrawSomething.h"
#import "UPCellItems.h"
#import "UPCells.h"
#import "UPTheme.h"
#import "UPDataManager.h"
#import "NSObject+MJKeyValue.h"
#import "AFHTTPRequestOperationManager.h"
#import "UPTools.h"

#define kUPFilePostURL @"http://api.qidianzhan.com.cn/AppServ/index.php?a=ActivityAdd"

#define kFieldTagForPrepay          1004
#define kFieldTagForFemaleLowLimit  1003
#define kFieldTagForPepleHighLimit  1002
#define kFieldTagForPepleLowLimit   1001

static CGFloat const FixRatio = 4/3.0;

//#define GB18030_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)


@interface UPCitySelectController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *cityItems;
@property (nonatomic, retain) UITableView *tableView;
@property (retain, nonatomic) NSMutableDictionary *cityDict;
@property (retain, nonatomic) NSArray *keyArray;
@end
@implementation UPCitySelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(backView)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    if (![UPDataManager shared].hasLoadCities) {
        [self cityInfoRequest];
    } else {
        [self loadCityData:[UPDataManager shared].cityList];
    }
}

- (void)backView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *)cityItems
{
    if (_cityItems==nil) {
        _cityItems = [NSMutableArray array];
    }
    return _cityItems;
}

-(void)cityInfoRequest
{
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setValue:@"CityQuery" forKey:@"a"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *respData = dict[@"resp_data"];
            
            NSMutableArray *allCities = respData[@"city_list"];
            NSArray<CityItem *> *cityArr = [CityItem objectArrayWithKeyValuesArray:allCities];
            [[UPDataManager shared] initWithCityItems:cityArr];
            
            [self loadCityData:cityArr];
        }
    } failture:^(id error) {
        NSLog(@"%@",error);
    }];
}

- (void)loadCityData:(NSArray *)cityArr
{
    NSMutableArray *tmpKeyList = [NSMutableArray array];
    
    _cityDict = [NSMutableDictionary dictionary];
    for (int i=0; i<cityArr.count; i++) {
        CityItem *city = cityArr[i];
        NSString *firstLetter = city.first_letter;
        
        if (NSNotFound == [tmpKeyList indexOfObject:firstLetter]) {
            [tmpKeyList addObject:firstLetter];
            NSMutableArray *tmpArr = [NSMutableArray array];
            [_cityDict setObject:tmpArr forKey:firstLetter];
        }
    }
    _keyArray = [tmpKeyList sortedArrayUsingSelector:@selector(compare:)];
    
    for (int i=0; i<cityArr.count; i++) {
        CityItem *city = cityArr[i];
        city.width = ScreenWidth;
        city.height = CellHeightDefault;
        
        if ([[_cityDict objectForKey:city.first_letter] isKindOfClass:[NSMutableArray class]]) {
            [[_cityDict objectForKey:city.first_letter] addObject:city];
        }
    }
    [_tableView reloadData];
}

#pragma mark UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, 15)];
    bgView.backgroundColor = [UIColor grayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, _tableView.frame.size.width-30, 15)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.text = [_keyArray objectAtIndex:section];
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _keyArray[section];
    NSArray *cities = [_cityDict objectForKey:key];
    return cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_keyArray objectAtIndex:indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
    }
    CityItem *rowCityItem = [[_cityDict objectForKey:key] objectAtIndex:indexPath.row];
    cell.textLabel.text = rowCityItem.city;
    cell.textLabel.font= kUPThemeNormalFont;
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    NSMutableArray *indexNumber = [NSMutableArray arrayWithArray:_keyArray];
    //添加搜索前的＃号
    return indexNumber;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [_keyArray objectAtIndex:indexPath.section];
    CityItem *rowCityItem = [[_cityDict objectForKey:key] objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(cityDidSelect:)]) {
        [self.delegate cityDidSelect:rowCityItem];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self resignFirstResponder];
}

@end


@interface NewLaunchActivityController () <UITableViewDelegate, UITableViewDataSource, UPCellDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UPActTypeSelectDelegate>
{
    UITableView *_tableView;
    CityItem *_selectedCity;
    
    int _typeCode;
    
    NSString *_lowLimit;
    NSString *_highLimit;
    NSString *_femaleLowLimit;
    NSString *_activityFee;
    
    NSData *_imgData;
    
    BOOL needFemale;
    
    BOOL malePay;
}
@property (nonatomic, retain) NSMutableArray *itemList;
@end

@implementation NewLaunchActivityController

- (NSMutableArray *)itemList
{
    if (_itemList==nil) {
        _itemList = [NSMutableArray new];
    }
    return _itemList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发起活动";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:nil target:self action:@selector(leftClick)];
    
    _typeCode = -1;
    _lowLimit = 0;
    _highLimit = 0;
    _activityFee = 0;
    _femaleLowLimit = 0;
    
    [self setNewData];
    
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorColor = [UIColor lightGrayColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        _tableView.separatorInset = UIEdgeInsetsZero;
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        _tableView.layoutMargins = UIEdgeInsetsMake(0,0,0,0);
    }
#endif
    _tableView.tableFooterView = [[UIView alloc] init];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    gesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:gesture];
    
    [self.view addSubview:_tableView];
    
    [self loadNotificationCell];
}

- (void)setNewData
{
    [self.itemList removeAllObjects];
    
    needFemale = NO;
    
    UPButtonCellItem *item0 = [[UPButtonCellItem alloc] init];
    item0.btnStyle = UPBtnStyleImage;
    item0.btnImage = [UIImage imageNamed:@"camera"];
    item0.btnTitle = @"单击上传活动图片";
    item0.tintColor = [UIColor redColor];
    item0.key = @"imageUpload";
    
    UPFieldCellItem *item1 = [[UPFieldCellItem alloc] init];
    item1.title = @"活动主题";
    item1.placeholder = @"添加活动主题";
    item1.key = @"activity_name";
    
    UPTextCellItem *item2 = [[UPTextCellItem alloc] init];
    item2.placeholder = @"添加活动介绍";
    item2.actionLen = 200;
    item2.key = @"activity_desc";
    
    //begin_time 为报名开始时间，即当前时间
    UPDateCellItem *item3 = [[UPDateCellItem alloc] init];
    item3.title = @"报名截止时间";
    item3.date = @"选择日期";
    item3.key = @"end_time";
    
    UPDateCellItem *item4 = [[UPDateCellItem alloc] init];
    item4.title = @"活动开始时间";
    item4.date = @"选择日期";
    item4.key = @"start_time";
    
    UPDetailCellItem *item5 = [[UPDetailCellItem alloc] init];
    item5.title = @"活动类型";
    item5.detail = @"选择类型";
    item5.key = @"activity_class";
    
    UPTitleCellItem *item15 = [[UPTitleCellItem alloc] init];
    item15.key = @"fmale_low";
    
    UPDetailCellItem *item6 = [[UPDetailCellItem alloc] init];
    item6.title = @"活动地点区域";
    item6.detail = @"选择城市";
    item6.key = @"activity_area";
    
    UPFieldCellItem *item7 = [[UPFieldCellItem alloc] init];
    item7.title = @"活动地址";
    item7.placeholder = @"请输入活动地址";
    item7.key = @"activity_place_code";
    
    UPFieldCellItem *item8 = [[UPFieldCellItem alloc] init];
    item8.title = @"活动场所";
    item8.placeholder = @"请输入活动场所";
    item8.more = YES;
    item8.detail = @"";
    item8.detailColor = [UIColor redColor];
    item8.key = @"activity_place";
    
    //limit_count, limit_low
    UPTitleCellItem *item9 = [[UPTitleCellItem alloc] init];
    item9.title = @"活动人数";
    item9.key = @"limit_count";
    
    UPComboxCellItem *item10 = [[UPComboxCellItem alloc] init];
    item10.title = @"着装要求";
    item10.style = UPItemStyleIndex;
    item10.comboxItems = @[@"随性", @"西装领带", @"便装"];
    item10.style = UPItemStyleIndex;
    item10.key = @"clothes_need";
    
    UPComboxCellItem *item11 = [[UPComboxCellItem alloc] init];  //使用 是否预付的 字段传参
    item11.title = @"付费方式";
    item11.style = UPItemStyleIndex;
    item11.comboxItems = @[@"现场AA", @"本壕请客", @"绅士均摊"];
    item11.style = UPItemStyleIndex;
    item11.key = @"is_prepaid";
    
    /**为了平衡性别比例，从付费方式和活动募集两方面补充规则
    付费方式：除了现有现场AA和土豪请客两种外，增加一种：绅士分摊，女士免费
    选择最后一种，预估费用后面出现提示：费用会随男女比例而浮动
    活动募集：给夜店派对和家庭派对两种活动增加男女比例选项，男女需分别达到人数才能募集成功。男数量为硬上限，达到后男不能报名，女数量为不低于，达到后可继续报名挤占男数量。   另外发起时为这两种派对活动增加一项奖励机制。发起人可设定，男士携__名女士同行可免单。
     */

//    UPTitleCellItem *item17 = [[UPTitleCellItem alloc] init];  //使用 是否预付的 字段传参
//    item17.title = @"设定";
//    item17.style = UPItemStyleIndex;
//    item17.key = @"goodNum";
    
    UPTitleCellItem *item16 = [[UPTitleCellItem alloc] init];
    item16.key = @"activity_fee";

    
    UPSwitchCellItem *item12 = [[UPSwitchCellItem alloc] init];
    item12.title=@"仅限本行业";
    item12.isOn = YES;
    item12.isLock = YES;
    item12.key = @"industry_id";
    
    UPButtonCellItem *item13 = [[UPButtonCellItem alloc] init];
    item13.btnTitle = @"提交活动";
    item13.btnStyle = UPBtnStyleSubmit;
    item13.tintColor = [UIColor redColor];
    item13.key = @"submit";
    
    self.itemList = [NSMutableArray new];
    [self.itemList addObject:item0];
    [self.itemList addObject:item1];
    [self.itemList addObject:item2];
    [self.itemList addObject:item3];
    [self.itemList addObject:item4];
    [self.itemList addObject:item5];
    [self.itemList addObject:item15];
    [self.itemList addObject:item6];
    [self.itemList addObject:item7];
    [self.itemList addObject:item8];
    [self.itemList addObject:item9];
    [self.itemList addObject:item10];
    [self.itemList addObject:item11];
    [self.itemList addObject:item16];
    [self.itemList addObject:item12];
    [self.itemList addObject:item13];
    
    [self.itemList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UPBaseCellItem *cellItem = (UPBaseCellItem *)obj;
        
        cellItem.cellWidth = ScreenWidth;
        if ([cellItem.key isEqualToString:@"imageUpload"]) {
            cellItem.cellHeight = 200;
        } else if ([cellItem.key isEqualToString:@"activity_desc"]) {
            cellItem.cellHeight = 100;
        }else if ([cellItem.key isEqualToString:@"fmale_low"]) {
            cellItem.cellHeight=0;
        } else
        {
            cellItem.cellHeight = kUPCellDefaultHeight;
        }
        
        *stop = NO;
    }];
}

- (void)tap:(UITapGestureRecognizer *)gestureReco
{
//    [self resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)loadNotificationCell
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    if (self.view.hidden == YES) {
        return;
    }
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25f];
    NSArray *subviews = [self.view subviews];
    for (UIView *sub in subviews) {
        if ([sub isKindOfClass:[UITableView class]]) {
            sub.frame = CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight-rect.size.height);
        }
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notif {
    if (self.view.hidden == YES) {
        return;
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    _tableView.frame=CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight);
    [UIView commitAnimations];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UPBaseCellItem *)self.itemList[indexPath.row]).cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    cellItem.indexPath = indexPath;
    
    UPBaseCell *itemCell = [self cellWithItem:cellItem];
    
    itemCell.delegate=self;
    
    [itemCell setItem:cellItem];
    
    if ([cellItem.key isEqualToString:@"activity_place"] &&cellItem.more ) {
        itemCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIButton *recoBtn = [UIButton buttonWithType:UIButtonTypeCustom];

        
        CGSize size = SizeWithFont(@"推荐", kUPThemeSmallFont);
        recoBtn.frame = CGRectMake(0,0,size.width+10,kUPCellDefaultHeight);
        [recoBtn setTitle:@"推荐" forState:UIControlStateNormal];
        recoBtn.titleLabel.font = kUPThemeSmallFont;
        [recoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [recoBtn addTarget:self action:@selector(recommend:) forControlEvents:UIControlEventTouchUpInside];
        itemCell.accessoryView = recoBtn;
        
    }else if ([cellItem.key isEqualToString:@"activity_fee"]) {
        CGFloat cellWidth = cellItem.cellWidth;
        if (malePay) {
            itemCell.textLabel.text = @"预估费用(按男女比例调整)";
        } else {
            itemCell.textLabel.text = @"预估费用";
        }
        
        UIView *detailView = itemCell.accessoryView;
        if (detailView==nil) {
            detailView = [[UIView alloc] initWithFrame:CGRectMake(cellWidth/2-30,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+30,kUPCellHeight-2*kUPCellVBorder)];
            detailView.backgroundColor = [UIColor clearColor];
            itemCell.accessoryView = detailView;
        }
    
        for (UIView *subView in detailView.subviews) {
            [subView removeFromSuperview];
        }

        CGFloat detailWidth = detailView.size.width;
        CGFloat detailHeight = detailView.size.height;
        CGSize sizeOneChar = SizeWithFont(@"元", kUPThemeNormalFont);
        CGFloat perWidth = sizeOneChar.width;
        CGFloat perHeight = sizeOneChar.height+4;
        
        UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-3*perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 2*perWidth, perHeight)];
        lowField.tag = kFieldTagForPrepay;
        lowField.text = @"0";
        lowField.keyboardType = UIKeyboardTypeNumberPad;
        lowField.borderStyle = UITextBorderStyleLine;
        [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        lowField.delegate = self;
        
        UILabel *renLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailWidth-perWidth,(detailHeight-perHeight)/2, perWidth, perHeight)];
        renLabel.text = @"元";
        renLabel.font = kUPThemeNormalFont;
        renLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:lowField];
        [detailView addSubview:renLabel];

    }else if ([cellItem.key isEqualToString:@"fmale_low"]) {
        CGFloat cellWidth = cellItem.cellWidth;
        CGFloat cellHeight = cellItem.cellHeight;
        
        if (cellHeight==0) {
            itemCell.textLabel.text = @"";
            itemCell.accessoryView = nil;
        } else {
            itemCell.textLabel.text = @"女性人数下限";
            UIView *detailView = itemCell.accessoryView;
            if (detailView==nil) {
                detailView = [[UIView alloc] initWithFrame:CGRectMake(cellWidth/2-30,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+30,kUPCellHeight-2*kUPCellVBorder)];
                detailView.backgroundColor = [UIColor clearColor];
                itemCell.accessoryView = detailView;
            }
            for (UIView *subView in detailView.subviews) {
                [subView removeFromSuperview];
            }
            
            CGFloat detailWidth = detailView.size.width;
            CGFloat detailHeight = detailView.size.height;
            CGSize sizeOneChar = SizeWithFont(@"至", kUPThemeNormalFont);
            CGFloat perWidth = sizeOneChar.width;
            CGFloat perHeight = sizeOneChar.height+4;
            
            UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-3*perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 2*perWidth, perHeight)];
            lowField.tag = kFieldTagForFemaleLowLimit;
            lowField.keyboardType = UIKeyboardTypeNumberPad;
            lowField.borderStyle = UITextBorderStyleLine;
            [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            lowField.delegate = self;
            
            UILabel *renLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailWidth-perWidth,(detailHeight-perHeight)/2, perWidth, perHeight)];
            renLabel.text = @"人";
            renLabel.font = kUPThemeNormalFont;
            renLabel.backgroundColor = [UIColor clearColor];
            [detailView addSubview:lowField];
            [detailView addSubview:renLabel];
        }
    }else if ([cellItem.key isEqualToString:@"limit_count"]) {
        CGFloat cellWidth = cellItem.cellWidth;
        
        UIView *detailView = itemCell.accessoryView;
        if (detailView==nil) {
            detailView = [[UIView alloc] initWithFrame:CGRectMake(cellWidth/2-30,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+30,kUPCellHeight-2*kUPCellVBorder)];
            detailView.backgroundColor = [UIColor clearColor];
            itemCell.accessoryView = detailView;
        }
        for (UIView *subView in detailView.subviews) {
            [subView removeFromSuperview];
        }

        CGFloat detailWidth = detailView.size.width;
        CGFloat detailHeight = detailView.size.height;
        CGSize sizeOneChar = SizeWithFont(@"至", kUPThemeNormalFont);
        CGFloat perWidth = sizeOneChar.width;
        CGFloat perHeight = sizeOneChar.height+4;
        UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-6*perWidth-3*kUPThemeBorder, (detailHeight-perHeight)/2, 2*perWidth, perHeight)];
        lowField.tag = kFieldTagForPepleLowLimit;
        lowField.keyboardType = UIKeyboardTypeNumberPad;
        lowField.borderStyle = UITextBorderStyleLine;
        [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        lowField.delegate = self;
    
        UITextField *highField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-3*perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 2*perWidth, perHeight)];
        highField.tag = kFieldTagForPepleHighLimit;
        highField.borderStyle = UITextBorderStyleLine;
        highField.keyboardType = UIKeyboardTypeNumberPad;
        [highField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        highField.delegate = self;
        
        UILabel *zhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailWidth-4*perWidth-2*kUPThemeBorder,(detailHeight-perHeight)/2, perWidth, perHeight)];
        zhiLabel.text = @"至";
        zhiLabel.font = kUPThemeNormalFont;
        zhiLabel.backgroundColor = [UIColor clearColor];
        
        UILabel *renLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailWidth-perWidth,(detailHeight-perHeight)/2, perWidth, perHeight)];
        renLabel.text = @"人";
        renLabel.font = kUPThemeNormalFont;
        renLabel.backgroundColor = [UIColor clearColor];
        [detailView addSubview:lowField];
        [detailView addSubview:highField];
        [detailView addSubview:zhiLabel];
        [detailView addSubview:renLabel];
    }
    itemCell.backgroundColor=[UIColor whiteColor];
    return itemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UPBaseCellItem *cellItem = cell.item;
    if ([cellItem.key isEqualToString:@"activity_area"]) {
        UPCitySelectController *citySelectController = [[UPCitySelectController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:citySelectController];
        citySelectController.delegate = self;
        [self presentViewController:nav animated:YES completion:nil];
    } else if([cellItem.key isEqualToString:@"activity_class"]){
        UPActTypeController *actTypeSelectVC = [[UPActTypeController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:actTypeSelectVC];
        actTypeSelectVC.delegate = self;
        [self presentViewController:nav animated:YES completion:nil];
    }
}

- (UPBaseCell *)cellWithItem:(UPBaseCellItem*)cellItem
{
    NSString *className = NSStringFromClass([cellItem class]);
    NSString *cellIdentifier = [className substringToIndex:className.length-4];
    
    UPBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cellIdentifier) {
        cell = [(UPBaseCell*)[NSClassFromString(cellIdentifier) alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (NSString *)cellIdentifierForItem:(UPBaseCellItem *)item
{
    NSString *cellItemName = NSStringFromClass([item class]);
    return cellItemName;
}

#pragma mark UITextFieldDelegate
-(void)textFieldChanged:(UITextField*)textField
{
    if (textField.tag==kFieldTagForPepleLowLimit) {
        _lowLimit = textField.text;
    } else if (textField.tag==kFieldTagForPepleHighLimit) {
        _highLimit = textField.text;
    } else if (textField.tag==kFieldTagForFemaleLowLimit) {
        _femaleLowLimit = textField.text;
    } else if (textField.tag==kFieldTagForPrepay) {
        _activityFee = textField.text;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered
{
    unichar c = [textEntered characterAtIndex:[textEntered length]-1];
    if(c==0||c=='\n'){
        return YES;
    }
    
    if (textField.tag==1001 || textField.tag==1002 || textField.tag==1003) {
        int actionLen = 2;
        if (textField.text.length+textEntered.length>actionLen) {
            return NO;
        }
        
        NSCharacterSet *cs = nil;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *filtered = [[textEntered componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [textEntered isEqualToString:filtered];
        return basicTest;
    }
    return YES;
}


#pragma mark Other Delegate
- (void)cityDidSelect:(CityItem *)cityItem
{
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"activity_area"]) {
            UPDetailCellItem *item = (UPDetailCellItem*)cellItem;
            NSString *area = [NSString stringWithFormat:@"%@ %@", cityItem.province, cityItem.city];
            item.detail = area;
            [_tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    
    _selectedCity = cityItem;
}

- (void)comboxSelected:(int)selectedIndex withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    UPComboxCellItem *comboxItem = (UPComboxCellItem*)cellItem;
    [comboxItem setSelectedIndex:selectedIndex];
    
    if ([cellItem.key isEqualToString:@"activity_class"]) {
        [self.itemList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UPBaseCellItem *cellItem = (UPBaseCellItem *)obj;
            if ([cellItem.key isEqualToString:@"fmale_low"]) {
                if (selectedIndex==1||selectedIndex==2) { //夜店派对，家庭派对
                    cellItem.cellHeight=kUPCellDefaultHeight;
                    needFemale = YES;
                } else {
                    cellItem.cellHeight=0;
                    needFemale = NO;
                }
                *stop = YES;
            } else {
                *stop = NO;
            }
        }];
        
        NSIndexPath *indexP = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:0];
        [_tableView reloadRowsAtIndexPaths:@[indexP] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)buttonClicked:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    
    //提交
    if([cellItem.key isEqualToString:@"submit"]){
        
        //industry_id, province_code, city_code, town_code, limit_count, limit_low
        NSArray *paramKey = @[@"activity_name", @"activity_desc", @"end_time", @"start_time", @"activity_place_code", @"activity_place", @"is_prepaid", @"industry_id", @"clothes_need"];
        
        NSDictionary *headParam = [UPDataManager shared].getHeadParams;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
        [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        for (UPBaseCellItem *cellItem in self.itemList) {
            if ([paramKey containsObject:cellItem.key]) {
                if (![self check:cellItem]) {
                    return;
                }
                if ([cellItem.key isEqualToString:@"industry_id"]) {
                    params[cellItem.key] = ((int)cellItem.value==1)?[UPDataManager shared].userInfo.industry_id:@"-1";
                } else if([cellItem.key isEqualToString:@"start_time"]|[cellItem.key isEqualToString:@"end_time"]) {
                    if ([cellItem.key isEqualToString:@"start_time"]) {
                        params[cellItem.key] = [UPTools dateTransform:cellItem.value fromFormat:@"yyyy-MM-dd" toFormat:@"yyyyMMdd000000"];
                    } else {
                        params[cellItem.key] = [UPTools dateTransform:cellItem.value fromFormat:@"yyyy-MM-dd" toFormat:@"yyyyMMdd235959"];
                    }
                    
                } else {
                   [params setObject:cellItem.value forKey:cellItem.key];
                }
            }
        }
        
        NSString *msg = nil;
        if (_selectedCity==nil) {
            msg = @"请选择城市";
        } else if (_highLimit==nil || _highLimit.length==0) {
            msg = @"请输入人数上限";
        } else if (_highLimit==nil || _highLimit.length==0) {
            msg = @"请输入人数下限";
        } else if ((_femaleLowLimit==nil || _femaleLowLimit.length==0)&&needFemale) {
            msg = @"请输入女性人数要求";
        }

        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if (_typeCode==-1) {
            msg = @"请选择活动类型";
        }
        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        [params setObject:[NSString stringWithFormat:@"%d", _typeCode] forKey:@"activity_class"];
        
        [params setObject:_selectedCity.province_code forKey:@"province_code"];
        [params setObject:_selectedCity.city_code forKey:@"city_code"];
        [params setObject:_selectedCity.town_code forKey:@"town_code"];
        [params setObject:_highLimit forKey:@"limit_count"];
        [params setObject:_lowLimit forKey:@"limit_low"];
        [params setObject:(_femaleLowLimit&&_femaleLowLimit.length>0)?_femaleLowLimit:@"0" forKey:@"fmale_low"];
        [params setObject:_activityFee forKey:@"activity_fee"];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        NSString *begin_time = [formatter stringFromDate:[NSDate date]];
        [params setObject:begin_time forKey:@"begin_time"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        //manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:kUPFilePostURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (_imgData!=nil) {
                 [formData appendPartWithFileData:_imgData name:@"file" fileName:@"act" mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *resp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Success:%@,", resp);
            
            NSObject *jsonObj = [UPTools JSONFromString:resp];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *respDict = (NSDictionary *)jsonObj;
                NSString *resp_id = respDict[@"resp_id"];
                NSString *resp_desc = respDict[@"resp_desc"];
                if ([resp_id intValue]==0) {
                    [self setNewData];
                    [_tableView reloadData];
                    
                } else {
                    //
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:resp_id message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } else if([cellItem.key isEqualToString:@"imageUpload"]){
        [self openMenu];
    }
}

- (BOOL)check:(UPBaseCellItem *)cellItem
{
    NSDictionary *paramKey = @{@"activity_name":@"请输入活动名称", @"activity_desc":@"请输入活动描述", @"end_time":@"请输入报名截止时间", @"start_time":@"请输入活动开始时间", @"activity_place_code":@"请填写活动场所", @"activity_place":@"请输入详细地址信息"};

    NSString *msg = nil;
    NSString *valueStr = cellItem.value;
    if (valueStr==nil || valueStr.length==0 || [valueStr isEqualToString:@"选择日期"]) {
        msg = paramKey[cellItem.key];
    }
    
    if (msg!=nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)switchOn:(BOOL)isOn withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    UPSwitchCellItem *switchItem = (UPSwitchCellItem*)cellItem;
    switchItem.isOn = isOn;
}
- (void)viewValueChanged:(NSString*)value  withIndexPath:(NSIndexPath*)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    NSString *className = NSStringFromClass([cellItem class]);
    if ([className isEqualToString:@"UPFieldCellItem"]) {
        UPFieldCellItem *fieldItem = (UPFieldCellItem*)cellItem;
        [fieldItem fillWithValue:value];
    }
    
    if ([className isEqualToString:@"UPTextCellItem"]) {
        UPTextCellItem *fieldItem = (UPTextCellItem*)cellItem;
        [fieldItem fillWithValue:value];
    }
}

- (void)recommend:(UIButton *)sender
{
    RecommendController *recommendController = [[RecommendController alloc] init];
    [self.navigationController pushViewController:recommendController animated:YES];
}

#pragma mark take photo methods
- (void)openMenu
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传活动图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"取消");
    }];
    [alertController addAction:action];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"从手机相册中获取" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction *action) {
            NSLog(@"从手机相册中获取");
            [self localPhoto];
        }];
        action;
    })];
    
    [alertController addAction:({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction *action) {
            NSLog(@"打开照相机");
            [self takePhoto];
        }];
        action;
    })];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//开始拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    } else
    {
        NSLog(@"模拟器无法打开照相机");
    }
}
//打开本地相册
- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        CGSize imgSize = [image size];
        CGFloat kWidth;
        
        CGFloat ratio = imgSize.width/imgSize.height;
        if (ratio<FixRatio) {
            kWidth = imgSize.width;
        } else {
            kWidth = FixRatio*imgSize.height;
        }
        UIImage *cutImage = [UPTools cutImage:image withSize:CGSizeMake(kWidth, kWidth/FixRatio)];
        
        //压缩图片到一定大小size
        float scale = 0.8f;
        NSData *data = UIImageJPEGRepresentation(cutImage, scale);
        while ([data base64EncodedDataWithOptions:0].length>20*1024 && scale>0) {
            cutImage = [UPTools image:cutImage scaledToSize:CGSizeMake(cutImage.size.width*scale, cutImage.size.height*scale)];
            data = UIImageJPEGRepresentation(cutImage, scale);
            scale-=0.1;
        }
        
        _imgData = [[NSData alloc] initWithData:data];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
                
        UPButtonCellItem *btnItem = self.itemList[0];
        btnItem.btnImage = image;
        [_tableView reloadRowsAtIndexPaths:@[btnItem.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//pragma mark - 上传图片
- (void)uploadImage:(NSString *)imagePath
{
    NSLog(@"图片的路径是：%@", imagePath);
    
}

- (void)actionTypeDidSelect:(ActTypeInfo *)actInfo {
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"activity_class"]) {
            UPDetailCellItem *item = (UPDetailCellItem*)cellItem;
            item.detail = actInfo.actTypeName;
            [_tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    
    UPBaseCellItem *femaleItem = nil;
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"fmale_low"]) {
            femaleItem = cellItem;
        }
    }
    if (actInfo.femalFlag) {
        femaleItem.cellHeight=kUPCellDefaultHeight;
        needFemale = YES;
    } else {
        femaleItem.cellHeight=0;
        needFemale = NO;
    }
    [_tableView reloadRowsAtIndexPaths:@[femaleItem.indexPath] withRowAnimation:UITableViewRowAnimationNone];

    _typeCode = [actInfo.itemID intValue];
}

- (void)resignKeyboard
{
    [self.view endEditing:YES];
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

@end

