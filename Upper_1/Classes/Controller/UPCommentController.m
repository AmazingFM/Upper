//
//  UPCommentController.m
//  Upper
//
//  Created by 张永明 on 16/7/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPCommentController.h"
#import "RadioButton.h"
#import "UPTextView.h"
#import "MBProgressHUD+MJ.h"
#import "UPTools.h"
#import "Info.h"
#import "UPTheme.h"
#import "YMImageLoadView.h"
#import "AFHTTPRequestOperationManager.h"
#import "YMNetwork.h"

#define kUPReviewCommentPostURL @"http://api.qidianzhan.com.cn/AppServ/index.php?a=ActivityModify"


@interface UPCommentController () <UIGestureRecognizerDelegate,UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIScrollView *scrollView;
    UPTextView *commentTextView;
    UIView *radioBackView;
    UIButton *likeOrDislike;
    YMImageLoadView *_imageLoadView;
    
    UIImagePickerController *pickerController;
    NSData *imgData;
    
    NSString *commentLevel;
    
//    BOOL hasRequestPeople;
    
    UITableView *tableView;
}
@property (nonatomic, retain) NSMutableArray<NSString *> *likes;
@property (nonatomic, retain) NSMutableArray<NSString *> *disLikes;
@property (nonatomic, retain) NSMutableArray<UserData *> *userArr;
@end

@implementation UPCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
    
    [self doInit];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight)];
    scrollView.scrollEnabled = YES;
    scrollView.bounces = YES;
    scrollView.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [scrollView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(80, ScreenHeight, ScreenWidth-2*80, 100)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self.view addSubview:tableView];
    
    [self initBaseUI];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftTitle:@"取消" target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightTitle:@"提交" target:self action:@selector(submit)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    if (textView.text.length + text.length > 200){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    } 
    return YES;
}

#pragma mark - UIGestureRecognizerDelegate

//
-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [commentTextView resignFirstResponder];
}

- (void)doInit {
    commentLevel = @"0";
    
    pickerController = [UIImagePickerController new];
    pickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    pickerController.delegate = self;
}

static const int textViewContentHeight = 150;

- (void)initBaseUI
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, LeftRightPadding, ScreenWidth, textViewContentHeight)];
    contentView.backgroundColor = [UIColor clearColor];
    
    commentTextView = [[UPTextView alloc] initWithFrame:CGRectMake(LeftRightPadding, 5, ScreenWidth-2*LeftRightPadding, textViewContentHeight-2*5)];
    commentTextView.font = kUPThemeNormalFont;
    commentTextView.delegate = self;
    commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    commentTextView.layer.borderWidth = 1;
    commentTextView.placeholder = @"请输入你的评论...";
    [contentView addSubview:commentTextView];
    [scrollView addSubview:contentView];
    
    if (self.type==UPCommentTypeReview) {
        likeOrDislike = [[UIButton alloc] initWithFrame:CGRectMake(LeftRightPadding, textViewContentHeight+5, ScreenWidth-2*LeftRightPadding, 40)];
        [likeOrDislike setTitle:@"踩或赞活动参与人" forState:UIControlStateNormal];
        likeOrDislike.backgroundColor = [UIColor clearColor];
        likeOrDislike.titleLabel.font = kUPThemeNormalFont;
        [likeOrDislike setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        likeOrDislike.layer.cornerRadius = 5.0f;
        [likeOrDislike addTarget:self action:@selector(showAnticipates:) forControlEvents:UIControlEventTouchUpInside];
        
         _imageLoadView = [[YMImageLoadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(likeOrDislike.frame)+10, ScreenWidth-2*LeftRightPadding, 300) withMaxCount:3];
        [scrollView addSubview:likeOrDislike];
        [scrollView addSubview:_imageLoadView];
    } else if (self.type==UPCommentTypeReview) {
        radioBackView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightPadding, textViewContentHeight+5, ScreenWidth-2*LeftRightPadding, 40)];
        radioBackView.backgroundColor = [UIColor clearColor];
        CGFloat viewWidth = ScreenWidth-2*LeftRightPadding;
        
        NSArray *radiotitles = @[@"好评", @"中评", @"差评"];
        for (int i=0; i<3; i++) {
            RadioButton *radio = [[RadioButton alloc] init];
            [radio setWidth:viewWidth/3 andHeight:40];
            [radio setText:radiotitles[i]];
            radio = [radio initWithGroupId:@"comment" index:i];
            radio.frame = CGRectMake(viewWidth*i/3, 0, viewWidth/3, 40);
            [radioBackView addSubview:radio];
        }
        
        [RadioButton addObserverForGroupId:@"comment" observer:self];
        
        [scrollView addSubview:radioBackView];
    }
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId
{
    commentLevel = [NSString stringWithFormat:@"%lu",(unsigned long)index+1];
    NSLog(@"%@, %@", commentLevel, groupId);
}

- (void)submit {
    [self checkNetStatus];
    
    if (!commentTextView.text.length) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的评论" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    
    if (self.type==0) {
        [MBProgressHUD showMessage:@"正在提交回顾...." toView:self.view];
        NSDictionary *headParam = [UPDataManager shared].getHeadParams;
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
//        [params setObject:@"ActivityModify"forKey:@"a"];
        [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        [params setObject:self.actID  forKey:@"activity_id"];
        [params setObject:@"4" forKey:@"activity_status"];
        NSString *likeStr = [self.likes componentsJoinedByString:@","]?:@"";
        NSString *dislikeStr = [self.disLikes componentsJoinedByString:@","]?:@"";
        NSString *commentStr = [UPTools encodeToPercentEscapeString:commentTextView.text];
        NSString *evaluateStr = [NSString stringWithFormat:@"%@^%@^%@", commentStr, likeStr, dislikeStr];
        
        [params setObject:evaluateStr forKey:@"evaluate_text"];
        [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:kUPReviewCommentPostURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                
                [formData appendPartWithFileData:[UPTools compressImage:cutImage] name:[NSString stringWithFormat:@"image_%d",i] fileName:[NSString stringWithFormat:@"review_%d.jpg",i] mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
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
            [MBProgressHUD hideHUDForView:self.view];
        }];

    } else if (self.type==1) {
        
        [MBProgressHUD showMessage:@"正在提交评论...." toView:self.view];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"ActivityJoinModify"forKey:@"a"];
        [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        [params setObject:self.actID forKey:@"activity_id"];
        [params setObject:commentTextView.text forKey:@"evaluate_text"];
        NSString *userStatus = @"5";
        [params setObject:userStatus forKey:@"user_status"];
        [params setObject:commentLevel forKey:@"evaluate_level_1"];
        [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
        
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            
            NSDictionary *dict = (NSDictionary *)json;
            NSString *resp_id = dict[@"resp_id"];
            if ([resp_id intValue]==0) {
                NSString *resp_desc = dict[@"resp_desc"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                NSString *resp_desc = dict[@"resp_desc"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
            
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view];
            });
            NSLog(@"%@",[error localizedDescription]);
            
        }];
    }
}

- (NSMutableArray *)likes
{
    if (_likes==nil) {
        _likes = [NSMutableArray new];
    }
    return _likes;
}

- (NSMutableArray *)disLikes
{
    if (_disLikes==nil) {
        _disLikes = [NSMutableArray new];
    }
    return _disLikes;
}

- (NSMutableArray *)userArr
{
    if (_userArr==nil) {
        _userArr = [NSMutableArray new];
    }
    return _userArr;
}


- (void)showAnticipates:(UIButton *) sender
{
    
    [self requestPeopleEnrolled];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)requestPeopleEnrolled
{
    [MBProgressHUD showMessage:@"正在请求参与人" toView:self.view];
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityJoinInfo"forKey:@"a"];
    
    [params setObject:self.actID forKey:@"activity_id"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        NSString *resp_desc = dict[@"resp_desc"];
        
        NSLog(@"%@:%@", resp_id, resp_desc);
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            int totalCount = [resp_data[@"total_count"] intValue];
            if (totalCount>0) {
                NSString *userList = resp_data[@"user_list"];
                if ([userList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *userDict in (NSArray *)userList) {
                        UserData *user = [[UserData alloc] init];
                        user.ID = userDict[@"user_id"];
                        user.nick_name = userDict[@"nick_name"];
                        user.sexual = userDict[@"sexual"];
                        user.user_icon = userDict[@"user_icon"];
                        
                        [self.userArr addObject:user];
                    }
                }
                
            } else{
                //目前黑没有参与者
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该活动目前无人参加！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
    } failture:^(id error) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",error);
    }];
}

@end
