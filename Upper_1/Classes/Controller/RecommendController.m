//
//  RecommendController.m
//  Upper
//
//  Created by 张永明 on 16/8/22.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "RecommendController.h"
#import "DrawSomething.h"
#import "UPCellItems.h"
#import "UPCells.h"
#import "UPTheme.h"
#import "UPTextView.h"
#import "NewLaunchActivityController.h"
#import "AFHTTPRequestOperationManager.h"
#import "UPTools.h"
#import "YMImageLoadView.h"

#define kUPShopPostURL [NSString stringWithFormat:@"%@?a=ShopAdd", kBaseURL]

@interface RecommendController () <UITableViewDelegate, UITableViewDataSource, CitySelectDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    CityInfo *_selectedCity;
    BaseType *_placeType;
    YMImageLoadView *_imageLoadView;
}
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSMutableArray *imgDataList;
@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _selectedCity = nil;
    _placeType = nil;
    
    self.title = @"推荐商户";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    self.navigationItem.rightBarButtonItem=nil;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,FirstLabelHeight,ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >=80000
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
#endif

    UPFieldCellItem *item1 = [[UPFieldCellItem alloc] init];
    item1.title = @"商户名称";
    item1.placeholder = @"添加商户名称";
    item1.key = @"shop_name";
    [item1 fillWithValue:@""];
    
    UPComboxCellItem *item2 = [[UPComboxCellItem alloc] init];
    item2.title = @"商家分类";
    __block NSMutableArray *placeNames = [NSMutableArray new];
    [[UPConfig sharedInstance].placeTypeArr enumerateObjectsUsingBlock:^(BaseType * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [placeNames addObject:obj.name];
    }];
    item2.comboxItems = placeNames;
    item2.style = UPItemStyleIndex;
    item2.comboxType = UPComboxTypePicker;
    item2.key = @"shop_class";
    
    UPDetailCellItem *item3 = [[UPDetailCellItem alloc] init];
    item3.title = @"城市";
    item3.detail = @"选择城市";
    item3.key = @"activity_area";
    
    UPFieldCellItem *item4 = [[UPFieldCellItem alloc] init];
    item4.title = @"商户地址";
    item4.placeholder = @"请输入地址";
    item4.key = @"shop_address";
    [item4 fillWithValue:@""];
    
    UPFieldCellItem *item5 = [[UPFieldCellItem alloc] init];
    item5.title = @"联系电话";
    item5.placeholder = @"请输入联系电话";
    item5.fieldType = UPFieldTypeNumber;
    item5.key = @"contact_no";
    [item5 fillWithValue:@""];

    UPFieldCellItem *item6 = [[UPFieldCellItem alloc] init];
    item6.title = @"人均消费";
    item6.placeholder = @"请输入人均消费";
    item6.fieldType = UPFieldTypeNumber;
    item6.key = @"avg_cost";
    [item6 fillWithValue:@""];
    
    UPTextCellItem *item7 = [[UPTextCellItem alloc] init];
    item7.placeholder = @"一句话描述";
    item7.actionLen = 100;
    item7.key = @"shop_desc";
    
    UPBaseCellItem *item8 = [[UPBaseCellItem alloc] init];
    item8.key = @"imageUpload";
    
    UPButtonCellItem *item9 = [[UPButtonCellItem alloc] init];
    item9.btnTitle = @"提交信息";
    item9.btnStyle = UPBtnStyleSubmit;
    item9.tintColor = [UIColor redColor];
    item9.key = @"submit";

    
    _itemList = [NSMutableArray new];
    [_itemList addObject:item1];
    [_itemList addObject:item2];
    [_itemList addObject:item3];
    [_itemList addObject:item4];
    [_itemList addObject:item5];
    [_itemList addObject:item6];
    [_itemList addObject:item7];
    [_itemList addObject:item8];
    [_itemList addObject:item9];

    
    [_itemList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UPBaseCellItem *cellItem = (UPBaseCellItem *)obj;
        
        cellItem.cellWidth = ScreenWidth;
        if ([cellItem.key isEqualToString:@"shop_desc"]) {
            cellItem.cellHeight = kUPCellDefaultHeight*2;
        } else if([cellItem.key isEqualToString:@"imageUpload"]) {
            cellItem.cellHeight = 200;
        } else {
            cellItem.cellHeight = kUPCellDefaultHeight;
        }
        
        cellItem.cellWidth = ScreenWidth;
        *stop = NO;
    }];

    [self.view addSubview:_tableView];
}

#pragma mark 
#pragma mark UITableViewDelegate , UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UPBaseCellItem *)self.itemList[indexPath.row]).cellHeight;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    cellItem.indexPath = indexPath;
    
    NSString *itemClassName = NSStringFromClass([cellItem class]);
    NSString *cellIdentifier = [itemClassName substringToIndex:itemClassName.length-4];
    
    UPBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[NSClassFromString(cellIdentifier) alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([cellItem.key isEqualToString:@"imageUpload"]) {
            _imageLoadView = [[YMImageLoadView alloc] initWithFrame:CGRectMake(0, 0, cellItem.cellWidth, cellItem.cellHeight) withMaxCount:5];
            [cell addSubview:_imageLoadView];
        }
    }
    cell.delegate = self;
    [cell setItem:cellItem];
    
    return cell;
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

#pragma mark Other Delegate
- (void)cityDidSelect:(CityInfo *)cityInfo
{
    for (UPBaseCellItem *cellItem in self.itemList) {
        if ([cellItem.key isEqualToString:@"activity_area"]) {
            UPDetailCellItem *item = (UPDetailCellItem*)cellItem;
            NSString *area = [NSString stringWithFormat:@"%@ %@", cityInfo.province, cityInfo.city];
            item.detail = area;
            [_tableView reloadRowsAtIndexPaths:@[item.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    
    _selectedCity = cityInfo;
}


//$this->shop_name = I('shop_name');
//$this->shop_desc = I('shop_desc');
//$this->province_code = I('province_code');
//$this->city_code = I('city_code');
//$this->town_code = I('town_code');
//$this->shop_address = I('shop_address');
//$this->industry_id = I('industry_id',-1);
//$this->shop_class = I('shop_class');
//$this->contact_no = I('contact_no');
//$this->avg_cost = I('avg_cost');

- (void)buttonClicked:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    
    //提交
    if([cellItem.key isEqualToString:@"submit"]){
        NSArray *paramKey = @[@"shop_name", @"shop_desc", @"shop_address", @"shop_class", @"contact_no", @"avg_cost"];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        for (UPBaseCellItem *cellItem in self.itemList) {
            if ([paramKey containsObject:cellItem.key]) {
                if (![self check:cellItem]) {
                    return;
                }
                
                if([cellItem.key isEqualToString:@"shop_class"]) {
                    _placeType = [UPConfig sharedInstance].placeTypeArr[[cellItem.value intValue]];
                } else {
                    [params setObject:cellItem.value forKey:cellItem.key];
                }
            }
        }
        
        NSString *msg = nil;
        if (_selectedCity==nil) {
            msg = @"请选择城市";
        }
        if (_placeType==nil) {
            msg = @"请选择商户类型";
        }
        if (msg) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        [params setObject:_placeType.ID forKey:@"shop_class"];
        [params setObject:_selectedCity.province_code forKey:@"province_code"];
        [params setObject:_selectedCity.city_code forKey:@"city_code"];
        [params setObject:_selectedCity.town_code forKey:@"town_code"];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        //manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:kUPShopPostURL parameters:[self addDescParams:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            static float FixRatio = 1.f;
            for (int i=0; i<_imageLoadView.images.count&&i<5; i++) {
                UIImage *image = _imageLoadView.images[i];
                CGSize imgSize = [image size];
                CGFloat kWidth;
                
                CGFloat ratio = imgSize.width/imgSize.height;
                if (ratio<FixRatio) {
                    kWidth = imgSize.width;
                } else {
                    kWidth = FixRatio*imgSize.height;
                }
                UIImage *cutImage = [UPTools cutImage:image withSize:CGSizeMake(kWidth, kWidth/FixRatio)];
 
                [formData appendPartWithFileData:[UPTools compressImage:cutImage] name:[NSString stringWithFormat:@"image_%d",i] fileName:@"pic" mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *resp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Success:%@,", resp);
            
            NSObject *jsonObj = [UPTools JSONFromString:resp];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *respDict = (NSDictionary *)jsonObj;
                NSString *resp_desc = respDict[@"resp_desc"];
                
                showConfirmAlert(@"提示", resp_desc, self);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else if([cellItem.key isEqualToString:@"imageUpload"]){
        [self openMenu];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        picker.showsCameraControls = YES;
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        picker.mediaTypes = @[(NSString *)kUTTypeImage];
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
    static float FixRatio = 1.f;
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
        
        self.imgDataList[0]=[UPTools compressImage:cutImage];

        
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

- (BOOL)check:(UPBaseCellItem *)cellItem
{
    NSDictionary *paramKey = @{@"shop_name":@"请输入商户名称", @"shop_desc":@"请输入商户描述", @"shop_address":@"请输入商户地址", @"contact_no":@"", @"avg_cost":@""};
    
    NSLog(@"%@",cellItem.key);
    NSString *valueStr = cellItem.value;
    NSString *msg = nil;
    if (valueStr==nil || valueStr.length==0) {
        msg = paramKey[cellItem.key];
    }
    
    if (msg!=nil && msg.length!=0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)resignKeyboard
{
    [self.view endEditing:YES];
}

- (void)comboxSelected:(int)selectedIndex withIndexPath:(NSIndexPath *)indexPath
{
    UPBaseCellItem *cellItem = self.itemList[indexPath.row];
    UPComboxCellItem *comboxItem = (UPComboxCellItem *)cellItem;
    [comboxItem setSelectedIndex:selectedIndex];
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

@end
