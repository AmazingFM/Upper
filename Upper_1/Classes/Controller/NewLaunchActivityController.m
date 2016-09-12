//
//  NewLaunchActivityController.m
//  Upper
//
//  Created by 张永明 on 16/8/10.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "NewLaunchActivityController.h"
#import "RecommendController.h"
#import "DrawSomething.h"
#import "UPCellItems.h"
#import "UPCells.h"
#import "UPTheme.h"
#import "UPDataManager.h"
#import "NSObject+MJKeyValue.h"
#import "AFHTTPRequestOperationManager.h"
#import "UPTools.h"

#define kUPFilePostURL @"http://api.qidianzhan.com.cn/AppServ/index.php?a=ActivityAdd"

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
}

@end


@interface NewLaunchActivityController () <UITableViewDelegate, UITableViewDataSource, UPCellDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITableView *_tableView;
    CityItem *_selectedCity;
    NSString *_lowLimit;
    NSString *_highLimit;
    
    NSData *_imgData;
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
    
    NSArray *types = @[@"不限", @"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动",@"郊游、徒步"];
    UPComboxCellItem *item5 = [[UPComboxCellItem alloc] init];
    item5.title = @"活动类型";
    item5.comboxItems = types;
    item5.style = UPItemStyleIndex;
    item5.key = @"activity_class";

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
    item8.detail = @"推荐";
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
    
    _itemList = [NSMutableArray new];
    [_itemList addObject:item0];
    [_itemList addObject:item1];
    [_itemList addObject:item2];
    [_itemList addObject:item3];
    [_itemList addObject:item4];
    [_itemList addObject:item5];
    [_itemList addObject:item6];
    [_itemList addObject:item7];
    [_itemList addObject:item8];
    [_itemList addObject:item9];
    [_itemList addObject:item10];
    [_itemList addObject:item11];
    [_itemList addObject:item12];
    [_itemList addObject:item13];
    
    [_itemList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UPBaseCellItem *cellItem = (UPBaseCellItem *)obj;
        
        cellItem.cellWidth = ScreenWidth;
        if ([cellItem.key isEqualToString:@"imageUpload"]) {
            cellItem.cellHeight = 200;
        } else if ([cellItem.key isEqualToString:@"activity_desc"]) {
            cellItem.cellHeight = 100;
        }else {
            cellItem.cellHeight = kUPCellDefaultHeight;
        }
        
        *stop = NO;
    }];
    
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftRightPadding, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight-20) style:UITableViewStylePlain];
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
    
    [self.view addSubview:_tableView];

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
        itemCell.detailTextLabel.text=@"";
        UIButton *recoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGSize size = SizeWithFont(@"推荐", kUPThemeSmallFont);
        recoBtn.frame = CGRectMake(0,0,size.width+10,kUPCellDefaultHeight);
        [recoBtn setTitle:@"推荐" forState:UIControlStateNormal];
        recoBtn.titleLabel.font = kUPThemeSmallFont;
        [recoBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [recoBtn addTarget:self action:@selector(recommend:) forControlEvents:UIControlEventTouchUpInside];
        itemCell.accessoryView = recoBtn;
        
    } else if ([cellItem.key isEqualToString:@"limit_count"]) {
        CGFloat cellWidth = cellItem.cellWidth;
        UIView *detailView = [[UIView alloc] initWithFrame:CGRectMake(cellWidth/2-30,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+30,kUPCellHeight-2*kUPCellVBorder)];
        detailView.backgroundColor = [UIColor clearColor];
        
        CGFloat detailWidth = detailView.size.width;
        CGFloat detailHeight = detailView.size.height;
        CGSize sizeOneChar = SizeWithFont(@"至", kUPThemeNormalFont);
        CGFloat perWidth = sizeOneChar.width;
        CGFloat perHeight = sizeOneChar.height+4;
        UITextField *lowField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-6*perWidth-3*kUPThemeBorder, (detailHeight-perHeight)/2, 2*perWidth, perHeight)];
        lowField.tag = 1001;
        lowField.borderStyle = UITextBorderStyleLine;
        [lowField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        lowField.delegate = self;
    
        UITextField *highField = [[UITextField alloc] initWithFrame:CGRectMake(detailWidth-3*perWidth-kUPThemeBorder, (detailHeight-perHeight)/2, 2*perWidth, perHeight)];
        highField.tag = 1002;
        highField.borderStyle = UITextBorderStyleLine;
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
        itemCell.accessoryView = detailView;
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
    if (textField.tag==1001) {
        _lowLimit = textField.text;
    } else if (textField.tag==1002) {
        _highLimit = textField.text;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered
{
    unichar c = [textEntered characterAtIndex:[textEntered length]-1];
    if(c==0||c=='\n'){
        return YES;
    }
    
    if (textField.tag==1001 || textField.tag==1002) {
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
}

- (void)buttonClicked:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    
    //提交
    if([cellItem.key isEqualToString:@"submit"]){
        
        //industry_id, province_code, city_code, town_code, limit_count, limit_low
        NSArray *paramKey = @[@"activity_name", @"activity_desc", @"activity_class", @"end_time", @"start_time", @"activity_place_code", @"activity_place", @"is_prepaid", @"industry_id", @"clothes_need"];
        
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
                    params[cellItem.key] = [UPTools dateTransform:cellItem.value fromFormat:@"yyyy-MM-dd" toFormat:@"yyyyMMddHHmmss"];
                } else {
                   [params setObject:cellItem.value forKey:cellItem.key];
                }
            }
        }
        
        [params setObject:_selectedCity.province_code forKey:@"province_code"];
        [params setObject:_selectedCity.city_code forKey:@"city_code"];
        [params setObject:_selectedCity.town_code forKey:@"town_code"];
        [params setObject:_highLimit forKey:@"limit_count"];
        [params setObject:_lowLimit forKey:@"limit_low"];
        
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
            [formData appendPartWithFileData:_imgData name:@"file" fileName:@"act" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *resp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Success:%@,", resp);
            
            NSObject *jsonObj = [UPTools JSONFromString:resp];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *respDict = (NSDictionary *)jsonObj;
                NSString *resp_id = respDict[@"resp_id"];
                NSString *resp_desc = respDict[@"resp_desc"];
                
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
    if (cellItem.value==nil) {
        //
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

@end

/*******
 
 dressTypeItems = new ArrayList<SpinnerItem>();
 dressTypeItems.add(new SpinnerItem("1", "随性"));
 dressTypeItems.add(new SpinnerItem("2", "西装领带"));
 dressTypeItems.add(new SpinnerItem("3", "便装"));
 
 actionTypeItems = new ArrayList<SpinnerItem>();
 actionTypeItems.add(new SpinnerItem("1", "不限"));
 actionTypeItems.add(new SpinnerItem("2", "派对、酒会"));
 actionTypeItems.add(new SpinnerItem("3", "桌游、座谈、棋牌"));
 actionTypeItems.add(new SpinnerItem("4", "KTV"));
 actionTypeItems.add(new SpinnerItem("5", "户外烧烤"));
 actionTypeItems.add(new SpinnerItem("6", "运动"));
 actionTypeItems.add(new SpinnerItem("7", "郊游、徒步"));
 
 payTypeItem = new ArrayList<SpinnerItem>();
 payTypeItem.add(new SpinnerItem("1", "土豪请客"));
 payTypeItem.add(new SpinnerItem("2", "AA付款"));
 
 timeRangeItems = new ArrayList<SpinnerItem>();
 timeRangeItems.add(new SpinnerItem("1", "当天"));
 timeRangeItems.add(new SpinnerItem("2", "3天内"));
 timeRangeItems.add(new SpinnerItem("3", "未来一周"));
 timeRangeItems.add(new SpinnerItem("4", "未来一个月"));
 ******/
