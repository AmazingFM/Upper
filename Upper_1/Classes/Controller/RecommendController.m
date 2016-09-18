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

#define kUPShopPostURL @"http://api.qidianzhan.com.cn/AppServ/index.php?a=ShopAdd"

@interface RecommendController () <UITableViewDelegate, UITableViewDataSource, CitySelectDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UITableView *_tableView;
    CityItem *_selectedCity;
    YMImageLoadView *_imageLoadView;
}
@property (nonatomic, retain) NSMutableArray *itemList;
@property (nonatomic, retain) NSMutableArray *imgDataList;
@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"推荐商户";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    
    
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
    
    NSArray *types = @[@"餐厅", @"咖啡馆", @"夜店Club", @"酒吧Pub", @"Lounge Bar", @"威士忌/雪茄吧",@"会所",@"公园", @"KTV", @"茶馆/下午茶", @"户外", @"农家乐",@"赛车场/卡丁车馆", @"攀岩", @"射箭/射击",@"健身会所/舞蹈",@"滑雪/溜冰", @"真人CS", @"密室脱逃", @"体育场馆",@"其他"];
    UPComboxCellItem *item2 = [[UPComboxCellItem alloc] init];
    item2.title = @"商家分类";
    item2.comboxItems = types;
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
    
    UPFieldCellItem *item5 = [[UPFieldCellItem alloc] init];
    item5.title = @"联系电话";
    item5.placeholder = @"请输入联系电话";
    item5.fieldType = UPFieldTypeNumber;
    item5.key = @"contact_no";

    UPFieldCellItem *item6 = [[UPFieldCellItem alloc] init];
    item6.title = @"人均消费";
    item6.placeholder = @"请输入人均消费";
    item6.fieldType = UPFieldTypeNumber;
    item6.key = @"avg_cost";
    
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
        //industry_id, province_code, city_code, town_code, limit_count, limit_low
        NSArray *paramKey = @[@"shop_name", @"shop_desc", @"shop_address", @"shop_class", @"contact_no", @"avg_cost"];
        
        NSDictionary *headParam = [UPDataManager shared].getHeadParams;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
        [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        for (UPBaseCellItem *cellItem in self.itemList) {
            if ([paramKey containsObject:cellItem.key]) {
                if (![self check:cellItem]) {
                    return;
                }
                [params setObject:cellItem.value forKey:cellItem.key];
            }
        }
        
        [params setObject:_selectedCity.province_code forKey:@"province_code"];
        [params setObject:_selectedCity.city_code forKey:@"city_code"];
        [params setObject:_selectedCity.town_code forKey:@"town_code"];
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        //manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:kUPShopPostURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                NSString *resp_id = respDict[@"resp_id"];
                NSString *resp_desc = respDict[@"resp_desc"];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:resp_id message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else if([cellItem.key isEqualToString:@"imageUpload"]){
        [self openMenu];
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
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
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
    if (cellItem.value==nil) {
        //
    }
    return YES;
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

@end
