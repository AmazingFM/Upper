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
#import "UPMainMenuController.h"
#import "UPGlobals.h"
#import "YMNetWork.h"
#import "UPConfig.h"
#import "UPFriendListController.h"
#import "CRNavigationController.h"
#import "CRNavigationBar.h"
#import "MBProgressHUD+MJ.h"
#import "MessageManager.h"
#import "WXApiManager.h"
#import "CRNavigationController.h"

#define kUPFilePostURL [NSString stringWithFormat:@"%@?a=ActivityAdd", kBaseURL]

#define kFieldTagForPrepay          1004
#define kFieldTagForFemaleLowLimit  1003
#define kFieldTagForPepleHighLimit  1002
#define kFieldTagForPepleLowLimit   1001

static CGFloat const FixRatio = 4/3.0;

//#define GB18030_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)


@interface UPCitySelectController() <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@end
@implementation UPCitySelectController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"选择城市";
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backView)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [UPConfig sharedInstance].refreshBlock = ^{
        [self.tableView reloadData];
    };
    [[UPConfig sharedInstance] requestCityInfo];
}

- (void)backView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    titleLabel.text = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[section].firstLetter;
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[UPConfig sharedInstance].cityContainer.alphaCityInfoArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AlphabetCityInfo *alphaCityInfo = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[section];
    return [alphaCityInfo.citylist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cityCell"];
    }
    
    AlphabetCityInfo *alphaCityInfo = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[indexPath.section];
    CityInfo *cityInfo = [alphaCityInfo.citylist objectAtIndex:indexPath.row];
    cell.textLabel.text = cityInfo.city;
    cell.textLabel.font= kUPThemeNormalFont;
    return cell;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    __block NSMutableArray *indexNumber = [NSMutableArray new];
    [[UPConfig sharedInstance].cityContainer.alphaCityInfoArr enumerateObjectsUsingBlock:^(AlphabetCityInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexNumber addObject:obj.firstLetter];
    }];
    //添加搜索前的＃号
    return indexNumber;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlphabetCityInfo *alphaCityInfo = [UPConfig sharedInstance].cityContainer.alphaCityInfoArr[indexPath.section];
    CityInfo *cityInfo = [alphaCityInfo.citylist objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(cityDidSelect:)]) {
        [self.delegate cityDidSelect:cityInfo];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self resignFirstResponder];
}

@end


@interface NewLaunchActivityController () <UITableViewDelegate, UITableViewDataSource, UPCellDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UPActTypeSelectDelegate, UIActionSheetDelegate>
{
    UITableView *_tableView;
    CityInfo *_selectedCity;
    BaseType *_clothType;
    BaseType *_payType;
    
    ActivityType *_actType;
    NSString *_lowLimit;
    NSString *_highLimit;
    NSString *_femaleLowLimit;
    NSString *_activityFee;
    
    
    NSData *_imgData;
    
    BOOL needFemale;
    
    BOOL malePay;
    
    BOOL waiting;
    
    NSMutableDictionary *actParams;
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
    waiting = NO;
    
    self.navigationItem.title = @"发起活动";
    actParams = [NSMutableDictionary new];
    
    if (self.type==ActOperTypeLaunch) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:nil target:self action:@selector(leftClick)];
    }
    
    if (self.type==ActOperTypeEdit) {
        
        
        [self getImageDataFromURL:self.actData.activity_image];
        
        _actType = [[UPConfig sharedInstance] getActivityTypeByID:self.actData.activity_class];
        
        _lowLimit = @"0";
        _highLimit = self.actData.limit_count;
        
        _activityFee = self.actData.activity_fee;
        _femaleLowLimit = @"0";
        
        _selectedCity = [[CityInfo alloc] initWithDict:@{@"province_code"   :self.actData.province_code,
                                                         @"city_code"       :self.actData.city_code,
                                                         @"town_code"       :@"",
                                                         @"province"        :self.actData.province,
                                                         @"city"            :self.actData.city,
                                                         @"town"            :@""}];
        
        _clothType = [[UPConfig sharedInstance] getClothTypeByID:self.actData.clothes_need];
        _payType = [[UPConfig sharedInstance] getPayTypeByID:self.actData.is_prepaid];
    } else {
        [self clearValue];
    }
    
    [self setNewData];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor lightGrayColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.tableView.separatorInset = UIEdgeInsetsMake(0,10,0,0);
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        self.tableView.layoutMargins = UIEdgeInsetsMake(0,10,0,0);
    }
#endif
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    gesture.cancelsTouchesInView = NO;
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

-(void)getImageDataFromURL:(NSString *)imageUrl
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self reloadImageData:data];
    }];
    
    [task resume];
}

- (void)reloadImageData:(NSData *)imageData
{
    _imgData = imageData;
    
    for (UPBaseCellItem *item in self.itemList) {
        if ([item.key isEqualToString:@"imageUpload"]) {
            UPButtonCellItem *imageItem = (UPButtonCellItem *)item;
            imageItem.btnImage = [UIImage imageWithData:_imgData];
            imageItem.defaultImage = NO;
            break;
        }
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)clearValue
{
    self.actData = nil;
    
    _actType = nil;
    needFemale = NO;
    _lowLimit = @"0";
    _highLimit = @"0";
    _activityFee = @"0";
    _femaleLowLimit = @"0";
    _selectedCity = nil;
    _clothType = nil;
    _payType = nil;
    
    _imgData = nil;
}

- (void)setNewData
{
    [self.itemList removeAllObjects];
    
    UPButtonCellItem *item0 = [[UPButtonCellItem alloc] init];
    item0.btnStyle = UPBtnStyleImage;
    if (_imgData==nil) {
        item0.defaultImage = YES;
        item0.btnImage = [UIImage imageNamed:@"icon-camera"];
    } else {
        item0.defaultImage = NO;
        item0.btnImage = [UIImage imageWithData:_imgData];
    }
    
    item0.tintColor = RGBCOLOR(231, 231, 231);
    item0.key = @"imageUpload";
    
    UPOnlyFieldCellItem *item1 = [[UPOnlyFieldCellItem alloc] init];
    item1.fieldText = self.actData.activity_name;
    item1.placeholder = @"活动主题";
    item1.key = @"activity_name";
    
    UPTextCellItem *item2 = [[UPTextCellItem alloc] init];
    item2.placeholder = @"活动介绍";
    item2.actionLen = 200;
    item2.fieldText = self.actData.activity_desc;
    item2.key = @"activity_desc";
    
    //begin_time 为报名开始时间，即当前时间
    NSString *time = nil;
    if (self.actData!=nil) {
        time = self.actData.end_time;
    } else {
        time = nil;
    }

    UPDateCellItem *item3 = [[UPDateCellItem alloc] init];
    item3.title = @"报名截止时间";
    item3.date = (time.length==0)?@"选择日期":[UPTools dateTransform:time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy-MM-dd"];
    item3.key = @"end_time";
    
    UPDateCellItem *item4 = [[UPDateCellItem alloc] init];
    item4.title = @"活动开始时间";
    
    if (self.actData!=nil) {
        time = self.actData.start_time;
    } else {
        time = nil;
    }
    item4.date = time.length==0?@"选择日期":[UPTools dateTransform:time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy-MM-dd"];
    item4.key = @"start_time";
    
    UPDetailCellItem *item5 = [[UPDetailCellItem alloc] init];
    item5.title = @"活动类型";
    item5.detail = (_actType==nil)?@"选择类型":_actType.name;
    item5.key = @"activity_class";
    
    UPTitleCellItem *item15 = [[UPTitleCellItem alloc] init];
    item15.key = @"fmale_low";
    item15.title = @"女性人数下限";
    
    UPDetailCellItem *item6 = [[UPDetailCellItem alloc] init];
    item6.title = @"活动区域";
    item6.detail = (_selectedCity==nil?@"城市":_selectedCity.city);
    item6.key = @"activity_area";
    
    UPFieldCellItem *item7 = [[UPFieldCellItem alloc] init];
    item7.title = @"活动地址";
    item7.placeholder = @"请输入详细地址";
    item7.fieldText = self.actData.activity_addr;
    item7.key = @"activity_addr";
    
    UPFieldCellItem *item8 = [[UPFieldCellItem alloc] init];
    item8.title = @"活动场所";
    item8.placeholder = @"请输入活动场所";
    item8.fieldText =  self.actData.activity_place;
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
    __block NSMutableArray *clothNames = [NSMutableArray new];
    [[UPConfig sharedInstance].clothTypeArr enumerateObjectsUsingBlock:^(BaseType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [clothNames addObject:obj.name];
    }];
    item10.comboxItems = clothNames;
    item10.selectedIndex = _clothType!=nil?([_clothType.ID intValue]-1):0;
    item10.style = UPItemStyleIndex;
    item10.key = @"clothes_need";
    
    UPComboxCellItem *item11 = [[UPComboxCellItem alloc] init];  //使用 是否预付的 字段传参
    item11.title = @"付费方式";
    item11.style = UPItemStyleIndex;
    __block NSMutableArray *payNames = [NSMutableArray new];
    [[UPConfig sharedInstance].payTypeArr enumerateObjectsUsingBlock:^(BaseType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [payNames addObject:obj.name];
    }];
    item11.comboxItems = payNames;
    item11.selectedIndex = _payType!=nil?([_payType.ID intValue]-1):0;
    item11.style = UPItemStyleIndex;
    item11.key = @"is_prepaid";
    
    /**为了平衡性别比例，从付费方式和活动募集两方面补充规则
    付费方式：除了现有现场AA和土豪请客两种外，增加一种：绅士分摊，女士免费
    选择最后一种，预估费用后面出现提示：费用会随男女比例而浮动
    活动募集：给夜店派对和家庭派对两种活动增加男女比例选项，男女需分别达到人数才能募集成功。男数量为硬上限，达到后男不能报名，女数量为不低于，达到后可继续报名挤占男数量。   另外发起时为这两种派对活动增加一项奖励机制。发起人可设定，男士携__名女士同行可免单。
     */
    
    UPTitleCellItem *item16 = [[UPTitleCellItem alloc] init];
    item16.key = @"activity_fee";
    item16.title = @"预估人均费用";
    
    UPComboxCellItem *item12 = [[UPComboxCellItem alloc] init];  //活动可见范围
    item12.title = @"可见范围";
    item12.style = UPItemStyleIndex;

    item12.comboxItems = @[@"不限", @"本行业可见", @"屏蔽本行业"];
    item12.selectedIndex = 0;
    item12.style = UPItemStyleIndex;
    item12.key = @"industry_id";
    
    NSString *submitTitle = nil;
    if (self.actData) {
        submitTitle = @"变更活动";
    } else {
        submitTitle = @"提交活动";
    }
    UPButtonCellItem *item13 = [[UPButtonCellItem alloc] init];
    item13.btnTitle = submitTitle;
    item13.btnStyle = UPBtnStyleSubmit;
    item13.tintColor = kUPThemeMainColor;
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
            cellItem.cellHeight = ScreenWidth*3/4;
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
    [self.view endEditing:YES];
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
    
    if (indexPath.row==0) {
        UILabel *tipsLabel = [itemCell viewWithTag:100];
        if (tipsLabel==nil) {
            tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, cellItem.cellHeight-80, cellItem.cellWidth-60, 80)];
            tipsLabel.text = @"活动配图(可选)，不上传会使用系统配图";
            tipsLabel.backgroundColor = [UIColor clearColor];
            tipsLabel.font = [UIFont systemFontOfSize:13];
            tipsLabel.textColor = kUPThemeMainColor;
            tipsLabel.tag = 100;
            tipsLabel.numberOfLines = 0;
            tipsLabel.textAlignment = NSTextAlignmentCenter;
            [itemCell addSubview:tipsLabel];
        }
    }
    
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
//        if (malePay) {
//            itemCell.textLabel.text = @"预估人均费用(按男女比例调整)";
//            itemCell.
//        } else {
//            itemCell.textLabel.text = @"预估人均费用";
//        }
        
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
        
        UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-100-perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 100, perHeight)];
        lowField.tag = kFieldTagForPrepay;
        lowField.text = @"0";
        lowField.keyboardType = UIKeyboardTypeDecimalPad;
        lowField.returnKeyType = UIReturnKeyDone;
        lowField.borderStyle = UITextBorderStyleRoundedRect;
        [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        lowField.delegate = self;
        lowField.text = _activityFee;
        lowField.layer.borderColor = [UPTools colorWithHex:0x666666].CGColor;
        
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
            itemCell.accessoryView = nil;
        } else {
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
            
            UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-4*perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 3*perWidth, perHeight)];
            lowField.tag = kFieldTagForFemaleLowLimit;
            lowField.keyboardType = UIKeyboardTypeDefault;
            lowField.returnKeyType = UIReturnKeyDone;
            lowField.borderStyle = UITextBorderStyleRoundedRect;
            [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            lowField.delegate = self;
            lowField.text = _femaleLowLimit;
            lowField.layer.borderColor = [UPTools colorWithHex:0x666666].CGColor;
            
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
        UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-8*perWidth-3*kUPThemeBorder, (detailHeight-perHeight)/2, 3*perWidth, perHeight)];
        lowField.tag = kFieldTagForPepleLowLimit;
        lowField.keyboardType = UIKeyboardTypeDefault;
        lowField.returnKeyType = UIReturnKeyDone;
        lowField.borderStyle = UITextBorderStyleRoundedRect;
        [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        lowField.delegate = self;
        lowField.text = _lowLimit;
        lowField.layer.borderColor = [UPTools colorWithHex:0x666666].CGColor;
    
        UITextField *highField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-4*perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 3*perWidth, perHeight)];
        highField.tag = kFieldTagForPepleHighLimit;
        highField.keyboardType = UIKeyboardTypeDefault;
        highField.returnKeyType = UIReturnKeyDone;
        highField.borderStyle = UITextBorderStyleRoundedRect;
        [highField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        highField.delegate = self;
        highField.text = _highLimit;
        highField.layer.borderColor = [UPTools colorWithHex:0x666666].CGColor;
        
        UILabel *zhiLabel = [[UILabel alloc] initWithFrame:CGRectMake(detailWidth-5*perWidth-2*kUPThemeBorder,(detailHeight-perHeight)/2, perWidth, perHeight)];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            cell.layoutMargins=UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
            cell.separatorInset=UIEdgeInsetsMake(0, ScreenWidth, 0, 0);
        }
        
        if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
            [cell setPreservesSuperviewLayoutMargins:NO];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UPBaseCellItem *cellItem = cell.item;
    if ([cellItem.key isEqualToString:@"activity_area"]) {
        UPCitySelectController *citySelectController = [[UPCitySelectController alloc] init];
        CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:citySelectController];
        citySelectController.delegate = self;
        [self presentViewController:nav animated:YES completion:nil];
    } else if([cellItem.key isEqualToString:@"activity_class"]){
        UPActTypeController *actTypeSelectVC = [[UPActTypeController alloc] init];
        CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:actTypeSelectVC];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self resignKeyboard];
    return YES;
}
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
    } else if (textField.tag == kFieldTagForPrepay) {
        int actionLen = 4;
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
- (void)cityDidSelect:(CityInfo *)cityInfo
{
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"activity_area"]) {
            UPDetailCellItem *item = (UPDetailCellItem*)cellItem;
            NSString *area = [NSString stringWithFormat:@"%@ %@", cityInfo.province, cityInfo.city];
            item.detail = area;
            [self.tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    
    _selectedCity = cityInfo;
}

- (void)comboxSelected:(int)selectedIndex withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    UPComboxCellItem *comboxItem = (UPComboxCellItem*)cellItem;
    [comboxItem setSelectedIndex:selectedIndex];

    if (indexPath.row==12) {
        UPTitleCellItem *cellItem = self.itemList[13];//费用
        if (selectedIndex==2) {//绅士买单
            malePay = YES;
            cellItem.title = @"预估人均费用(按男女比例调整)";
        } else {
            malePay = NO;
            cellItem.title = @"预估人均费用";
        }
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:13 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag ==1000) {
        [self showLaunchResultView];
        waiting = NO;
    }
}

- (void)jumpToMyAct
{
    [g_homeMenu switchController:4];//4跳转到我发起的活动
}

- (void)buttonClicked:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    
    //提交
    if([cellItem.key isEqualToString:@"submit"]){
        if (waiting) {
            return;
        }
        //industry_id, province_code, city_code, town_code, limit_count, limit_low
        NSArray *paramKey = @[@"activity_name", @"activity_desc", @"end_time", @"start_time", @"activity_addr", @"activity_place", @"is_prepaid", @"industry_id", @"clothes_need"];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        for (UPBaseCellItem *cellItem in self.itemList) {
            if ([paramKey containsObject:cellItem.key]) {
                if (![self check:cellItem]) {
                    return;
                }
                if ([cellItem.key isEqualToString:@"industry_id"]) {
//                    不限-0, 本行业可见-行业id, 屏蔽本行业-行业id*-1;
                    int index = [cellItem.value intValue];
                    int factor = index<=1?index:-1;
                    int industry_id = [[UPDataManager shared].userInfo.industry_id intValue];
                    params[cellItem.key] = @(industry_id*factor).stringValue;
                } else if([cellItem.key isEqualToString:@"start_time"]|[cellItem.key isEqualToString:@"end_time"]) {
                    if ([cellItem.key isEqualToString:@"start_time"]) {
                        params[cellItem.key] = [UPTools dateTransform:cellItem.value fromFormat:@"yyyy-MM-dd" toFormat:@"yyyyMMdd000000"];
                    } else {
                        params[cellItem.key] = [UPTools dateTransform:cellItem.value fromFormat:@"yyyy-MM-dd" toFormat:@"yyyyMMdd235959"];
                    }
                    
                } else if([cellItem.key isEqualToString:@"clothes_need"]) {
                    _clothType = [UPConfig sharedInstance].clothTypeArr[[cellItem.value intValue]];
                } else if([cellItem.key isEqualToString:@"is_prepaid"]) {
                    _payType = [UPConfig sharedInstance].payTypeArr[[cellItem.value intValue]];
                } else {
                   [params setObject:cellItem.value forKey:cellItem.key];
                }
            }
        }
        
        NSString *msg = nil;
        if (_selectedCity==nil) {
            msg = @"请选择城市";
        } else if ([_lowLimit intValue]<2) {
            msg = @"活动至少需要2人（包括本人）";
        } else if ([_highLimit intValue]==0) {
            if ([_highLimit intValue]<[_lowLimit intValue]) {
                msg = @"人数上限必须大于下限";
            } else {
                msg = @"请输入人数下限";   
            }
        } else if (([_femaleLowLimit intValue]==0)&&needFemale) {
            msg = @"请输入女性人数要求";
        }
        
        if (_clothType==nil) {
            msg = @"请选择着装";
        }
        if (_payType==nil) {
            msg = @"请选择付款方式";
        }
        if (_actType==nil) {
            msg = @"请选择活动类型";
        }

        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }

        [params setObject:_clothType.ID forKey:@"clothes_need"];
        [params setObject:_payType.ID forKey:@"is_prepaid"];
        [params setObject:_actType.ID forKey:@"activity_class"];
        
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
        
        {
            waiting = YES;
        }

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        //manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:kUPFilePostURL parameters:[self addDescParams:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (_imgData!=nil) {
                 [formData appendPartWithFileData:_imgData name:@"file" fileName:@"activity.jpg" mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *resp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Success:%@,", resp);
            
            NSObject *jsonObj = [UPTools JSONFromString:resp];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *respDict = (NSDictionary *)jsonObj;
                NSString *resp_id = respDict[@"resp_id"];
                if ([resp_id intValue]==0) {
                    [self clearValue];
                    [self setNewData];
                    [self.tableView reloadData];
                    
                    [actParams removeAllObjects];
                    [actParams addEntriesFromDictionary:params];
                    NSDictionary *respData = respDict[@"resp_data"];
                    [actParams setObject:respData[@"activity_id"] forKey:@"ID"];
                    [actParams setObject:respData[@"imag_url"] forKey:@"activity_image"];
                    
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"活动发起成功，如需修改变更或取消，请点击活动规则查看相关规则和操作方式。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
                    alert.tag=1000;
                    [alert show];
                } else {
                    showDefaultAlert(@"提示", respDict[@"resp_desc"]);
                    waiting = NO;
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            waiting = NO;
        }];
    } else if([cellItem.key isEqualToString:@"imageUpload"]){
        [self openMenu];
    }
}

- (BOOL)check:(UPBaseCellItem *)cellItem
{
    NSDictionary *paramKey = @{@"activity_name":@"请输入活动名称", @"activity_desc":@"请输入活动描述", @"end_time":@"请输入报名截止时间", @"start_time":@"请输入活动开始时间", @"activity_place":@"请填写活动场所", @"activity_addr":@"请输入活动地址信息"};

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
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self localPhoto];
    } else if (buttonIndex==1) {
        [self takePhoto];
    }
}

- (void)openMenu
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传活动图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册中获取", @"打开照相机", nil];
    [actionSheet showInView: self.view];
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
        picker.edgesForExtendedLayout = UIRectEdgeNone;
        picker.sourceType = sourceType;
        picker.navigationBar.barTintColor = kUPThemeMainColor;
        picker.navigationBar.tintColor = [UIColor whiteColor];
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
    picker.edgesForExtendedLayout = UIRectEdgeNone;
    picker.navigationBar.barTintColor = kUPThemeMainColor;
    picker.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        CGSize imgSize = [image size];
        CGFloat kWidth;
        
        CGFloat ratio = imgSize.width/imgSize.height;
        if (ratio<FixRatio) {
            kWidth = imgSize.width;
        } else {
            kWidth = FixRatio*imgSize.height;
        }
        UIImage *cutImage = [UPTools cutImage:image withSize:CGSizeMake(kWidth, kWidth/FixRatio)];
        
        _imgData = [UPTools compressImage:cutImage];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
                
        UPButtonCellItem *btnItem = self.itemList[0];
        btnItem.btnImage = [UIImage imageWithData:_imgData];;
        btnItem.defaultImage = NO;
        [self.tableView reloadRowsAtIndexPaths:@[btnItem.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//pragma mark - 上传图片
- (void)uploadImage:(NSString *)imagePath
{
    NSLog(@"图片的路径是：%@", imagePath);
    
}

- (void)actionTypeDidSelect:(ActivityType *)actType {
    NSMutableArray *indexpaths = [NSMutableArray new];
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"activity_class"]) {
            UPDetailCellItem *item = (UPDetailCellItem*)cellItem;
            item.detail = actType.name;
            [indexpaths addObject:item.indexPath];
            break;
        }
    }
    
    UPButtonCellItem *item0 = self.itemList[0];
    item0.btnStyle = UPBtnStyleImage;
    if (_imgData==nil) {
        item0.btnImage = [UIImage imageNamed:[NSString stringWithFormat:@"default_activity_%@", actType.ID]];
        item0.defaultImage = NO;
    }
    
    UPBaseCellItem *femaleItem = nil;
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"fmale_low"]) {
            femaleItem = cellItem;
        }
    }
    if (actType.femaleFlag) {
        femaleItem.cellHeight=kUPCellDefaultHeight;
        needFemale = YES;
    } else {
        femaleItem.cellHeight=0;
        needFemale = NO;
    }
    
    [indexpaths addObject:item0.indexPath];
    [indexpaths addObject:femaleItem.indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexpaths withRowAnimation:UITableViewRowAnimationNone];

    _actType = actType;
}

- (void)resignKeyboard
{
    [self.view endEditing:YES];
}

-(void)leftClick
{
    [g_sideController showLeftViewController:YES];
}

- (void)willShowSlideView
{
    [self resignKeyboard];
}


- (NSDictionary *)addDescParams:(NSDictionary *)parameters
{
    NSString *uuid = [UPConfig sharedInstance].uuid;
    NSString *currentDate = [UPConfig sharedInstance].currentDate;
    NSString *reqSeq = [UPConfig sharedInstance].newReqSeqStr;
    
    NSMutableDictionary *newParamsDic = [NSMutableDictionary dictionaryWithDictionary:@{@"app_id":uuid, @"req_seq":reqSeq, @"time_stamp":currentDate}];
    
    NSString *actionName = parameters[@"a"];
    [newParamsDic addEntriesFromDictionary:parameters];
    [newParamsDic removeObjectForKey:@"a"];
    
    
    if ([UPDataManager shared].isLogin) {
        [newParamsDic setObject:[UPDataManager shared].token forKey:@"token"];
        
        NSString *user_id = newParamsDic[@"user_id"];
        if (user_id==nil || user_id.length==0) {
            [newParamsDic setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        }
    }
    
    NSString *md5Str = newParamsDic[@"sign"];
    
    if (md5Str==nil || md5Str.length==0) {
        NSArray *keys = newParamsDic.allKeys;
        NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(compare:)];
        
        NSMutableString *mStr = [NSMutableString stringWithString:@"upper"];
        for (int i=0; i<sortedKeys.count; i++) {
            [mStr appendFormat:@"%@%@", sortedKeys[i], newParamsDic[sortedKeys[i]]];
        }
        [mStr appendString:@"upper"];
        md5Str = [UPTools md5HexDigest:mStr];
        newParamsDic[@"sign"] = md5Str;
    }
    newParamsDic[@"a"] = actionName;
    return newParamsDic;
}

- (void)showLaunchResultView
{
    LaunchActivityResultController *resultVC = [[LaunchActivityResultController alloc] init];
    resultVC.actData = [[ActivityData alloc] initWithDict:actParams];
    [self.navigationController pushViewController:resultVC animated:YES];
}

@end

@interface LaunchActivityResultController()  <UPFriendListDelegate,UIActionSheetDelegate>

@end

@implementation LaunchActivityResultController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"发起活动成功";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *successImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-success"]];
    successImageV.frame = CGRectMake(ScreenWidth/2-20, FirstLabelHeight+30, 40, 40);
    successImageV.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:successImageV];
    
    
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(successImageV.frame)+20, ScreenWidth, 50)];
    descLabel.backgroundColor = [UIColor clearColor];
    descLabel.font = [UIFont boldSystemFontOfSize:18.f];
    descLabel.textColor = [UIColor blackColor];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.numberOfLines = 0;
    descLabel.text = @"恭喜您发起活动成功！\n点击\"分享\"或\"邀请好友\"让更多人参与吧！";
    [self.view addSubview:descLabel];

    CGSize size = [UPTools sizeOfString:@"查看详情" withWidth:320 font:[UIFont systemFontOfSize:15.f]];
    UIButton *detailBtn = [self createButton:CGRectMake(ScreenWidth/2-30-size.width, CGRectGetMaxY(descLabel.frame)+20, size.width+20, size.height+8) imageName:nil title:@"查看详情"];
    detailBtn.tag = 1000;
    detailBtn.layer.cornerRadius = 5.f;
    detailBtn.layer.masksToBounds = YES;
    detailBtn.layer.borderColor = kUPThemeLineColor.CGColor;
    detailBtn.layer.borderWidth = 0.6f;
    
    UIButton *inviteBtn = [self createButton:CGRectMake(ScreenWidth/2+10, CGRectGetMaxY(descLabel.frame)+20, size.width+20, size.height+8) imageName:nil title:@"邀请好友"];
    inviteBtn.tag = 1001;
    inviteBtn.layer.cornerRadius = 5.f;
    inviteBtn.layer.masksToBounds = YES;
    inviteBtn.layer.borderColor = kUPThemeLineColor.CGColor;
    inviteBtn.layer.borderWidth = 0.6f;

    
    UIButton *shareBtn = [self createButton:CGRectMake(10, CGRectGetMaxY(detailBtn.frame)+20, ScreenWidth-20, 30) imageName:@"icon_wx_session" title:@"分享到微信"];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    shareBtn.tag = 1002;
    
    [self.view addSubview:detailBtn];
    [self.view addSubview:inviteBtn];
    [self.view addSubview:shareBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
}

- (UIButton *)createButton:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title
{
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = frame;
    shareBtn.backgroundColor = [UIColor clearColor];
    [shareBtn setTitle:title forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    shareBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    return shareBtn;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [UPConfig sharedInstance].refreshBlock = nil;
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag == 1000) {
        [self jumpToMyAct];
    } else if (sender.tag == 1001) {
        [self inviteFriend];
    } else if (sender.tag == 1002) {
        [self shareToWX];
    }
}

- (void)shareToWX
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享给朋友", @"分享到朋友圈", nil];
    [actionSheet showInView:self.view];
}

- (void)inviteFriend
{
    UPFriendListController *inviteFriend = [[UPFriendListController alloc] init];
    inviteFriend.type = 0; //我的好友列表
    inviteFriend.delegate = self;
    CRNavigationController *nav = [[CRNavigationController alloc] initWithRootViewController:inviteFriend];
    [self presentViewController:nav animated:YES completion:nil];

}

- (void)cancel
{
    [self jumpToMyAct];
}

- (void)jumpToMyAct
{
    [g_homeMenu switchController:4];//4跳转到我发起的活动
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark UPInviteFriendDelegate
- (void)inviteFriends:(NSArray *)friendId
{
    if (friendId.count==0) {
        return;
    }
    [self sendInvitation:friendId];
}

- (void)sendInvitation:(NSArray *)friendIds
{
    __block int count = 0;
    
    //activity_name-活动名称,activity_class-活动类型, start_time-活动开始时间，ID-活动id，nick_name-发起人昵称
    NSDictionary *actDataDict = @{@"activity_name":self.actData.activity_name,@"activity_class":self.actData.activity_class,@"start_time":self.actData.start_time,@"id":self.actData.ID, @"nick_name":[UPDataManager shared].userInfo.nick_name};
    
    NSString *msgDesc = [UPTools stringFromJSON:actDataDict];
    
    for (NSString *to_id in friendIds) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:@"MessageSend" forKey:@"a"];
        [params setValue:[UPDataManager shared].userInfo.ID forKey:@"from_id"];
        [params setValue:to_id forKey:@"to_id"];
        
        UPServerMsgType msgType = ServerMsgTypeInviteFriend;
        [params setValue:[@(msgType) stringValue] forKey:@"message_type"];
        [params setValue:msgDesc forKey:@"message_desc"];
        [params setValue:@"" forKey:@"expire_time"];
        
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
            
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSLog(@"MessageSend, %@", dict);
            NSString *resp_id = dict[@"resp_id"];
            if ([resp_id intValue]==0) {
                [MBProgressHUD showSuccess:@"已发送邀请给对方"];
                count++;
//                [self cancel];
            } else {
                count++;
            }
        } failure:^(NSError *error) {
            [MBProgressHUD showError:@"发送消息失败，请重新操作"];
            count++;
        }];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actId = self.actData.ID;
    
    NSData *actIdData = [actId dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [actIdData base64EncodedStringWithOptions:0];
    
    NSString *md5Str = [UPTools md5HexDigest:[NSString stringWithFormat:@"%@upperinterface", actId]];
    NSString *shareLinkUrl = [NSString stringWithFormat:@"%@/?a=%@&t=%@", kShareActivityURL, base64Encoded, md5Str];
    
    ActivityType *activityType = [[UPConfig sharedInstance] getActivityTypeByID:self.actData.activity_class];
    NSString *actDesc = [NSString stringWithFormat:@"活动类型：%@\n活动描述：%@", activityType.name,self.actData.activity_desc];
    NSString *actImageName = [NSString stringWithFormat:@"default_activity_%@", activityType.ID];
    
    if (buttonIndex==0) {
        [[WXApiManager sharedManager] sendLinkURL:shareLinkUrl TagName:@"UPPER上行" Title:@"我发起了一个活动" Description:actDesc ThumbImageName:actImageName InScene:WXSceneSession];
    } else if (buttonIndex==1) {
        [[WXApiManager sharedManager] sendLinkURL:shareLinkUrl TagName:@"UPPER上行" Title:@"我发起了一个活动" Description:actDesc ThumbImageName:actImageName InScene:WXSceneTimeline];
    } else {
        //取消
    }
}

@end

