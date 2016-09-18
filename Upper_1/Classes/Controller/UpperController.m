//
//  UpperController.m
//  Upper_1
//
//  Created by aries365.com on 16/1/31.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UpperController.h"
#import "Info.h"
#import "MainController.h"
#import "AppDelegate.h"
#import "UPCells.h"
#import "UPTheme.h"
#import "UPDataManager.h"
#import "MBProgressHUD.h"
#import "UPTools.h"
#import "UPGlobals.h"

#define kUPTableViewHeight 10

extern NSString * const g_loginFileName;

@interface UpperController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIButton *_quitBtn;
    
    NSMutableDictionary *paramsDict;
    
    UPBaseCellItem *selectedItem;
    UIView *_datePanelView;
    UIButton *_hideBtn;
    
    UIDatePicker *datePicker;
}

@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSArray *firstArray;
@property (nonatomic, retain) NSArray *secondArray;
@property (nonatomic, retain) NSArray *iconArray;
@property (nonatomic, strong) UIImageView *myQRCodeImageView;
@property (nonatomic, retain) NSMutableArray *itemList;
@end

@implementation UpperController

- (NSMutableArray *)itemList
{
    if (_itemList==nil) {
        _itemList = [[NSMutableArray alloc] init];
    }
    return _itemList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    paramsDict = [NSMutableDictionary dictionary];
    
    self.title = @"Upper";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"back" highIcon:@"" target:self action:@selector(goBack)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightIcon:@"top_navigation_righticon" highIcon:@"" target:self action:@selector(scanQR)];
    
    _quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _quitBtn.frame = CGRectMake(20, ScreenHeight-80, ScreenWidth-40, 35);
    [_quitBtn.layer setMasksToBounds:YES];
    [_quitBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径

    _quitBtn.backgroundColor = [UIColor whiteColor];
    [_quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_quitBtn addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    
    UPImageDetailCellItem *imageDetailItem1 = [[UPImageDetailCellItem alloc] init];
    imageDetailItem1.title = @"头像";
    imageDetailItem1.imageName = @"head";
    imageDetailItem1.imageData = @"";
    imageDetailItem1.style = UPItemStyleUserImg;

    UPImageDetailCellItem *imageDetailItem2 = [[UPImageDetailCellItem alloc] init];
    imageDetailItem2.title = @"我的二维码";
    imageDetailItem2.imageName = @"qrcode";
    imageDetailItem2.style = UPItemStyleUserQrcode;
    
    UPImageDetailCellItem *imageDetailItem3 = [[UPImageDetailCellItem alloc] init];
    imageDetailItem3.title = @"昵称";
    imageDetailItem3.detail = @"设置一个昵称";
    imageDetailItem3.style = UPItemStyleUserNickName;
    
    
    UPImageDetailCellItem *imageDetailItem4 = [[UPImageDetailCellItem alloc] init];
    imageDetailItem4.title = @"性别";
    imageDetailItem4.detail = @"请选择";
    imageDetailItem4.style = UPItemStyleUserSexual;
    
    UPImageDetailCellItem *imageDetailItem5 = [[UPImageDetailCellItem alloc] init];
    imageDetailItem5.title = @"出生日期";
    imageDetailItem5.detail = @"请选择日期";
    imageDetailItem5.style = UPItemStyleUserBirth;
    
    UPTitleCellItem *titleCellItem1 = [[UPTitleCellItem alloc] init];
    titleCellItem1.title = @"社区";
    titleCellItem1.iconName = @"shequ";
//    titleCellItem1.more = YES;
//    titleCellItem1.hasBackground = NO;
    
    UPTitleCellItem *titleCellItem2 = [[UPTitleCellItem alloc] init];
    titleCellItem2.title = @"我的活动";
    titleCellItem2.iconName = @"huodong";
//    titleCellItem2.more = YES;
//    titleCellItem2.hasBackground = NO;
    
    UPTitleCellItem *titleCellItem3 = [[UPTitleCellItem alloc] init];
    titleCellItem3.title = @"设置";
    titleCellItem3.iconName = @"shezhi";
    
    if ([UPDataManager shared].isLogin) {
        imageDetailItem1.imageName = @"head";
        imageDetailItem1.imageData=[UPDataManager shared].userInfo.user_icon;
        imageDetailItem3.detail = [UPDataManager shared].userInfo.nick_name;
        imageDetailItem4.detail = [[UPDataManager shared].userInfo.sexual intValue]==0?@"男":@"女";
        
        NSString *birth = [UPDataManager shared].userInfo.birthday;
        if (birth==nil ||birth.length==0) {
            imageDetailItem5.detail =  @"请选择日期";
        } else {
            imageDetailItem5.detail = [UPTools dateTransform:birth fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy-MM-dd"];
        }
        
        [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    } else {
        imageDetailItem1.imageName = @"head";
        imageDetailItem1.imageData=@"";
        [_quitBtn setTitle:@"请登录" forState:UIControlStateNormal];
    }

    [self.itemList addObject:imageDetailItem1];
    [self.itemList addObject:imageDetailItem2];
    [self.itemList addObject:imageDetailItem3];
    [self.itemList addObject:imageDetailItem4];
    [self.itemList addObject:imageDetailItem5];
    [self.itemList addObject:titleCellItem1];
    [self.itemList addObject:titleCellItem2];
    [self.itemList addObject:titleCellItem3];
    
    [_itemList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([obj isKindOfClass:[UPBaseCellItem class]]) {
            ((UPBaseCellItem *)obj).cellWidth = ScreenWidth;
            if (idx<=4) {
                ((UPBaseCellItem *)obj).cellHeight = kUPCellHeight+2;
            } else {
                ((UPBaseCellItem *)obj).cellHeight = kUPCellHeight;

            }
        }
    }];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, _quitBtn.y-FirstLabelHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.leftButton];
    [self.view addSubview:_quitBtn];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recvLogin) name:kNotifierLogin object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([UPDataManager shared].isLogin) {
        [self recvLogin];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifierLogin object:nil];
}

- (void)recvLogin
{
    UPImageDetailCellItem *item = _itemList[0];
    item.imageData = [UPDataManager shared].userInfo.user_icon;
    NSIndexPath *idxPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
    
    [_quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kUPTableViewHeight  ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((UPBaseCellItem *)_itemList[indexPath.row]).cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.frame.size.width, kUPTableViewHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _itemList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UPBaseCellItem *cellItem = (UPBaseCellItem *)_itemList[indexPath.row];
    cellItem.indexPath = indexPath;
    UPBaseCell *itemCell = [self cellWithItem:cellItem];
    [itemCell setItem:cellItem];
    itemCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return itemCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UPBaseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    selectedItem = cell.item;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSUInteger row = [indexPath row];
    NSUInteger section = [indexPath section];
    if (section == 0)
    {
        switch (row) {
            case 0:
            {
                [self openMenu];
            }
                break;
            case 1:
            {
//                NSString *arg = @"0";
//                [self.parentController OnAction:self withType:CHANGE_VIEW toView:(QR_VIEW) withArg:arg];
                [self showQRCode];
                break;
            }
            case 2:
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"输入新昵称" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
                alertView.tag = 2;
                alertView.delegate = self;
                [alertView show];
            }
                break;
            case 3:
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择性别" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"男",@"女", nil];
                alertView.tag = 3;
                alertView.delegate = self;
                [alertView show];
            }
                break;
            case 4:
            {
                if (datePicker==nil) {
                    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0,320, 100)];
                    datePicker.datePickerMode = UIDatePickerModeDate;
                    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
                    datePicker.locale = locale;
                    datePicker.maximumDate = [NSDate date];
                    datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:0];
                }
                
                UPImageDetailCellItem *imageCellItem = (UPImageDetailCellItem *)selectedItem;
                NSString *birth = imageCellItem.detail;
                if (![birth isEqualToString:@"请选择日期"]) {
                    datePicker.date = [UPTools dateFromString:birth withFormat:@"yyyy-MM-dd"];
                }
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选择日期" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertView.tag = 4;
                
                if (g_nOSVersion>=7) {
                    [alertView setValue:datePicker forKey:@"accessoryView"];
                }
                
                alertView.delegate = self;
                [alertView show];
            }
                break;
        }
    }
    
    if (section == 1) {
        switch (row) {
            case 0: //我的社区
            {
                NSString *arg = @"1";
                [self.parentController OnAction:self withType:CHANGE_VIEW toView:PERSON_CENTER_VIEW withArg:arg];
            }
                break;
            case 1: //我的活动
            {
                [self.parentController OnAction:self withType:CHANGE_VIEW toView:MYACT_VIEW withArg:nil];
            }
                break;
            case 2: //设置
            {
                [self.parentController OnAction:self withType:LEFT_MENU_CHANGE toView:SETTING_VIEW withArg:nil];

            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark take photo methods
- (void)openMenu
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
        image = [UPTools fixOrientation:image];
        
        CGSize imgSize = [image size];
        CGFloat kWidth = imgSize.width<imgSize.height?imgSize.width:imgSize.height;
        UIImage *cutImage = [UPTools cutImage:image withSize:CGSizeMake(kWidth, kWidth)];
        
        float scale = 0.5f;
        cutImage = [UPTools image:cutImage scaledToSize:CGSizeMake(80, 80)];
        NSData *data = UIImageJPEGRepresentation(cutImage, scale);
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        
        [paramsDict removeAllObjects];
        paramsDict[@"user_icon"] = [data base64EncodedStringWithOptions:0];
        [self updateUserInfo];
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


#pragma mark -panel view methods

#pragma mark -UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (alertView.tag) {
        case 2:
        {
            if (buttonIndex==1) {
                UITextField *textField = [alertView textFieldAtIndex:0];
                NSString *newNickName = textField.text;
                if (newNickName!=nil && newNickName.length!=0) {
                    [paramsDict removeAllObjects];
                    paramsDict[@"nick_name"] = newNickName;
                    [self updateUserInfo];
                }
            }
        }
            break;
        case 3:
        {
            if (buttonIndex!=0) {
                [paramsDict removeAllObjects];
                paramsDict[@"sexual"] = [NSString stringWithFormat:@"%ld", (long)buttonIndex-1];
                [self updateUserInfo];
            }
        }
            break;
        case 4:
        {
            if (buttonIndex!=0) {
                [paramsDict removeAllObjects];
                paramsDict[@"birthday"] = [UPTools dateString:datePicker.date withFormat:@"yyyyMMddHHmmss"];
                [self updateUserInfo];
            }
        }
        default:
            break;
    }
}

- (void)showQRCode
{
    MBProgressHUD *HUD = [UPTools createHUD];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.color = [UIColor whiteColor];
    HUD.dimBackground = YES;
    HUD.labelText = @"我的二维码";
    HUD.labelFont = [UIFont systemFontOfSize:13];
    HUD.labelColor = [UIColor grayColor];
    HUD.customView = self.myQRCodeImageView;
    [HUD addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideHUD:)]];
}

- (void)hideHUD:(UIGestureRecognizer *)recognizer
{
    [(MBProgressHUD *)recognizer.view hide:YES];
}

- (UIImageView *)myQRCodeImageView
{
    if (!_myQRCodeImageView) {
        NSString *srcQrStr = [NSString stringWithFormat:@"user_id=%@", [UPDataManager shared].userInfo.ID];
        NSData *data = [srcQrStr dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
        
        UIImage *myQRCode = [UPTools createQRCodeFromString:base64Encoded];
        _myQRCodeImageView = [[UIImageView alloc] initWithImage:myQRCode];
    }
    
    return _myQRCodeImageView;
}



- (void)goBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scanQR
{
    [self.parentController OnAction:self withType:CHANGE_VIEW toView:QR_SCAN_VIEW withArg:nil];
}

- (void)quit:(UIButton *)sender
{
    if ([UPDataManager shared].isLogin) {
        [UPDataManager shared].isLogin = NO;
        [UPDataManager shared].userInfo = nil;//清楚用户信息
        [_quitBtn setTitle:@"请登录" forState:UIControlStateNormal];
        UPImageDetailCellItem *item = _itemList[0];
        
        
        item.imageData = @"";
        NSIndexPath *idxPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[idxPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [[UPDataManager shared] cleanUserDafult];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierLogout object:nil];//发送登出通知
        [g_appDelegate setRootViewController];
    } 
}

- (UPBaseCell *)cellWithItem:(UPBaseCellItem *)cellItem
{
    NSString *className = NSStringFromClass([cellItem class]);
    NSString *cellId = [className substringToIndex:className.length-4];
    UPBaseCell *cell = [_tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [(UPBaseCell *)[NSClassFromString(cellId) alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
//    for (UIView *subView in cell.subviews) {
//        [subView removeFromSuperview];
//    }
    return cell;
}


/***

 $this->user_name = I('user_name');
 $this->user_pass = I('user_pass');
 $this->new_pass = I('new_pass');
 $this->pass_type = I('pass_type');
 $this->true_name = I('true_name');
 $this->employee_id = I('employee_id');
 $this->node_email = I('node_email');
 $this->mobile = I('mobile');
 $this->sexual = I('sexual');
 $this->user_icon = I('user_icon');
 $this->nick_name = I('nick_name');
 */
- (void)updateUserInfo
{
    [self checkNetStatus];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    
//    NSString *userDataPath = [[NSBundle mainBundle] pathForResource:@"UserData" ofType:@"plist"];
//    //所有的数据列表
//    NSMutableDictionary *datalist= [[[NSMutableDictionary alloc]initWithContentsOfFile:userDataPath]mutableCopy];
//
    
    [params setObject:@"UserModify" forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    
    [params setValuesForKeysWithDictionary:paramsDict];
    
    __weak typeof(self) weakSelf = self;
    
    
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            UPImageDetailCellItem *cellItem = (UPImageDetailCellItem *)selectedItem;
            if (cellItem.style&UPItemStyleUserImg) {
                cellItem.imageData=paramsDict[@"user_icon"];
                
            }
            else if (cellItem.style&UPItemStyleUserNickName) {
                cellItem.detail = paramsDict[@"nick_name"];
            }
            else if (cellItem.style&UPItemStyleUserSexual) {
                cellItem.detail = [paramsDict[@"sexual"] intValue]==0?@"男":@"女";
            }
            else if (cellItem.style&UPItemStyleUserBirth) {
                cellItem.detail = [UPTools dateTransform:paramsDict[@"birthday"] fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy-MM-dd"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadRowsAtIndexPaths:@[cellItem.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
            
        }
        else
        {
            NSLog(@"%@", @"获取失败");
        }
        
    } failture:^(id error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

@end
