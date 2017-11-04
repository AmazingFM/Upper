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

#define kUPReviewCommentPostURL [NSString stringWithFormat:@"%@?a=ActivityModify", kBaseURL]

#define kCommentUserRowHeight 30

@implementation CommentUserItem
- (id)copyWithZone:(nullable NSZone *)zone
{
    CommentUserItem *copyObj = [[[self class] allocWithZone:zone] init];
    copyObj.userID = self.userID;
    copyObj.userSexual = self.userSexual;
    copyObj.userNickName = self.userNickName;
    copyObj.userIcon = self.userIcon;
    copyObj.status = self.status;
    return copyObj;
}
@end

@interface UPCommentUserView() <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *userTable;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    UIView *mainView;
    UIView *backgroundView;
    
    UILabel *tips;
    
    CGRect viewFrame;
    NSMutableArray *commentUserItems;
}

@end
@implementation UPCommentUserView

- (instancetype)initWithFrame:(CGRect)frame withCommentUsers:(NSArray *)commentUsers
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self) {
        commentUserItems = [NSMutableArray new];
        
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        backgroundView.backgroundColor = [UIColor clearColor];
        
        viewFrame = frame;
        mainView = [[UIView alloc] initWithFrame:frame];
        mainView.layer.cornerRadius = 5.f;
        mainView.layer.masksToBounds = YES;
        mainView.backgroundColor=[UIColor whiteColor];
        
        CGRect tableRect = CGRectMake(0, 0, frame.size.width, frame.size.height-30);
        userTable = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStylePlain];
        userTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        userTable.backgroundColor = [UIColor clearColor];
        userTable.delegate = self;
        userTable.dataSource = self;
        userTable.tableFooterView = [[UIView alloc] init];
        
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.frame = CGRectMake(0, frame.size.height-30, frame.size.width/2,30);
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = kUPThemeSmallFont;
        [cancelBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.tag = 100;
        
        confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        confirmBtn.frame = CGRectMake( frame.size.width/2, frame.size.height-30, frame.size.width/2,30);
        [confirmBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = kUPThemeSmallFont;
        [confirmBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.tag= 101;

        CGPoint center = CGPointMake(frame.size.width/2, frame.size.height/2-14);
        tips = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        tips.backgroundColor = [UIColor clearColor];
        tips.text = @"该活动暂时没有参与者";
        tips.textAlignment = NSTextAlignmentCenter;
        tips.font = kUPThemeNormalFont;
        tips.center = center;
        tips.hidden = YES;
        
        [mainView addSubview:userTable];
        [mainView addSubview:cancelBtn];
        [mainView addSubview:confirmBtn];
        [mainView addSubview:tips];
        
        [self addCopyItems:commentUsers];

        [self addSubview:backgroundView];
        [self addSubview:mainView];
    }
    return self;
}

- (void)addCopyItems:(NSArray *)commentUsers
{
    for (int i=0; i<commentUsers.count; i++) {
        CommentUserItem *item = commentUsers[i];
        [commentUserItems addObject:[item copy]];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    if (sender.tag==101) {
        
        if (commentUserItems.count>0 && self.delegate && [self.delegate respondsToSelector:@selector(commentUserStatusChanged:)])
        {
            [self.delegate commentUserStatusChanged:commentUserItems];
        }
    }
    [self dismiss];
}

- (void)dismiss{
    [self removeFromSuperview];
}

- (void)reloadData
{
    NSArray *commentUsers = [self.dataSource getCommentUsers];
    
    if (commentUsers.count==0) {
        userTable.hidden = YES;
        tips.hidden = NO;
    } else {
        [commentUserItems removeAllObjects];
        [self addCopyItems:commentUsers];
        
        userTable.hidden = NO;
        tips.hidden = YES;
        [userTable reloadData];
    }
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentUserItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"commentUserID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat width = viewFrame.size.width;
    
        UILabel *userName  = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, width-85, 30)];
        userName.backgroundColor = [UIColor clearColor];
        userName.lineBreakMode = NSLineBreakByTruncatingTail;
        userName.textAlignment = NSTextAlignmentLeft;
        userName.font = kUPThemeNormalFont;
        userName.tag = 100;
        
        UIButton *goodBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [goodBtn setTitle:@"赞" forState:UIControlStateNormal];
        goodBtn.frame = CGRectMake(width-70, 5, 20, 20);
        [goodBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        goodBtn.titleLabel.font = kUPThemeSmallFont;
        [goodBtn addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        goodBtn.layer.cornerRadius = 10;
        goodBtn.layer.masksToBounds = YES;
        goodBtn.layer.borderWidth = 0.2;
        goodBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [goodBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [goodBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
        goodBtn.tag = 101;
        
        UIButton *badBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [badBtn setTitle:@"踩" forState:UIControlStateNormal];
        badBtn.frame = CGRectMake(width-30, 5, 20, 20);
        [badBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        badBtn.titleLabel.font = kUPThemeSmallFont;
        [badBtn addTarget:self action:@selector(statusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        badBtn.layer.cornerRadius = 10;
        badBtn.layer.masksToBounds = YES;
        badBtn.layer.borderWidth = 0.2;
        badBtn.layer.borderColor = [UIColor grayColor].CGColor;
        [badBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [badBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
        badBtn.tag = 102;
        
        [cell addSubview:userName];
        [cell addSubview:goodBtn];
        [cell addSubview:badBtn];
    }
    
    cell.tag = indexPath.row;
    
    CommentUserItem *commentUserItem = commentUserItems[indexPath.row];
    UILabel *userName = [cell viewWithTag:100];
    userName.text = commentUserItem.userNickName;
    
    UIButton *goodBtn = [cell viewWithTag:101];
    UIButton *badBtn = [cell viewWithTag:102];
    if (commentUserItem.status==-1) {
//        goodBtn.backgroundColor = [UIColor whiteColor];
//        badBtn.backgroundColor = [UIColor redColor];
        goodBtn.selected = NO;
        badBtn.selected = YES;
    } else if (commentUserItem.status==0) {
//        goodBtn.backgroundColor = [UIColor whiteColor];
//        badBtn.backgroundColor = [UIColor whiteColor];
        goodBtn.selected = NO;
        badBtn.selected = NO;
    } else if (commentUserItem.status==1) {
//        goodBtn.backgroundColor = [UIColor redColor];
//        badBtn.backgroundColor = [UIColor whiteColor];
        goodBtn.selected = YES;
        badBtn.selected = NO;
    }
    return cell;
}

- (void)statusButtonClick:(UIButton *)statusBtn;
{
    UIView *cell = [statusBtn superview];
    UIButton *goodBtn = [cell viewWithTag:101];
    UIButton *badBtn = [cell viewWithTag:102];

    NSInteger index = cell.tag;
    int status = 0;
    
    if (statusBtn.selected) {
        statusBtn.selected = NO;
        status = 0;
    } else {
        statusBtn.selected = YES;
        if (statusBtn.tag==101) {
            status = 1;
            badBtn.selected = NO;
        } else if (statusBtn.tag==102) {
            status = -1;
            goodBtn.selected = NO;
        }
    }
    
    CommentUserItem *commentUserItem = commentUserItems[index];
    commentUserItem.status = status;
}

@end

@interface UPCommentController () <UIGestureRecognizerDelegate,UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIAlertViewDelegate>
{
    UIScrollView *scrollView;
    UPTextView *commentTextView;
    
    //评论
    UIView *radioBackView;
    
    //回顾
    UIButton *likeOrDislike;
    YMImageLoadView *_imageLoadView;
    
    //投诉
    UILabel *titleLabel;
    UITextField *teleField;
    UIView *line;
    UILabel *descLabel;
    
    UIImagePickerController *pickerController;
    NSData *imgData;
    
    NSString *commentLevel;
    
    BOOL hasLoadEnrolledPeople;
    
    NSString *placeholderString;
}
@property (nonatomic, retain) NSMutableArray *userCommentItems;
@end

@implementation UPCommentController
- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        placeholderString = placeholder;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UPTools colorWithHex:0xf3f3f3];
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
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
    
    [self initBaseUI];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftTitle:@"取消" target:self action:@selector(dismiss)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightTitle:@"提交" target:self action:@selector(submit)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    hasLoadEnrolledPeople = NO;
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


-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
    [commentTextView resignFirstResponder];
    [teleField resignFirstResponder];
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
    
    NSArray *placeholderText = @[@"请输入您的回顾内容...", @"请输入您的评论内容...", @"请输入您的投诉内容...",@"请输入您的意见..."];
    if (placeholderString.length!=0) {
        commentTextView.placeholder = placeholderString;
    } else {
        commentTextView.placeholder = placeholderText[self.type];
    }
    
    [contentView addSubview:commentTextView];
    [scrollView addSubview:contentView];
    
    if (self.type==UPCommentTypeReview) {
        likeOrDislike = [[UIButton alloc] initWithFrame:CGRectMake(LeftRightPadding, CGRectGetMaxY(contentView.frame)+8, ScreenWidth-2*LeftRightPadding, 40)];
        [likeOrDislike setTitle:@"踩或赞活动参与人" forState:UIControlStateNormal];
        likeOrDislike.backgroundColor = [UIColor clearColor];
        likeOrDislike.titleLabel.font = kUPThemeNormalFont;
        [likeOrDislike setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        likeOrDislike.layer.cornerRadius = 5.0f;
        [likeOrDislike addTarget:self action:@selector(showAnticipates:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *tips  = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, CGRectGetMaxY(likeOrDislike.frame)+10, ScreenWidth-100, 20)];
        tips.backgroundColor = [UIColor clearColor];
        tips.textColor = [UIColor redColor];
        tips.textAlignment = NSTextAlignmentLeft;
        tips.font = kUPThemeMinFont;
        tips.text = @"您可以选择上传活动图片";
        
        _imageLoadView = [[YMImageLoadView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tips.frame)-15, ScreenWidth-2*LeftRightPadding, 300) withMaxCount:3];
        [scrollView addSubview:likeOrDislike];
        [scrollView addSubview:tips];
        [scrollView addSubview:_imageLoadView];
    } else if (self.type==UPCommentTypeComment) {
        radioBackView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightPadding, CGRectGetMaxY(contentView.frame)+8, ScreenWidth-2*LeftRightPadding, 40)];
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
    } else if (self.type==UPCommentTypeComplain || self.type==UPCommentTypeFeedback) {
        UIFont *titleFont = [UIFont systemFontOfSize:15];
        CGSize size = [@"联系方式" sizeWithAttributes: @{NSFontAttributeName:titleFont}];
        
        titleLabel = [self createLabelWithFrame:CGRectMake(LeftRightPadding, CGRectGetMaxY(contentView.frame)+8, 90, size.height) withText:@"联系方式"];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = [UIFont systemFontOfSize:15];
        
        teleField = [[UITextField alloc] initWithFrame:CGRectMake(LeftRightPadding+100, CGRectGetMinY(titleLabel.frame), ScreenWidth-2*LeftRightPadding-100, size.height)];
        teleField.textColor = [UIColor blackColor];
        teleField.placeholder = @"请输入邮箱或手机号";
        teleField.keyboardType = UIKeyboardTypeEmailAddress;
        teleField.font = [UIFont systemFontOfSize:15.f];
        
        line = [[UIView alloc] initWithFrame:CGRectMake(LeftRightPadding,  CGRectGetMaxY(titleLabel.frame)+2, ScreenWidth-2*LeftRightPadding, 1)];
        line.backgroundColor = kUPThemeLineColor;
        
        NSString *descStr = @"我们会仔细阅读您的投诉意见，并尽早给您回复。感谢您的理解和支持";
        descLabel = [self createLabelWithFrame:CGRectMake(LeftRightPadding, CGRectGetMaxY(titleLabel.frame)+5, ScreenWidth-2*LeftRightPadding, 50) withText:descStr];
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:13.f];
        
        
        [scrollView addSubview:titleLabel];
        [scrollView addSubview:teleField];
        [scrollView addSubview:line];
        [scrollView addSubview:descLabel];
    }
}

-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId
{
    commentLevel = [NSString stringWithFormat:@"%lu",(unsigned long)index+1];
    NSLog(@"%@, %@", commentLevel, groupId);
}

- (void)submit {
    [self checkNetStatus];
    
    if (commentTextView.text.length==0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的评论" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }

    
    if (self.type==UPCommentTypeReview) {
        [MBProgressHUD showMessage:@"正在提交回顾...." toView:self.view];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:self.actID  forKey:@"activity_id"];
        [params setObject:@"8" forKey:@"activity_status"];
        
        NSMutableArray *likeIDs = [NSMutableArray new];
        NSMutableArray *dislikeIDs = [NSMutableArray new];
        NSMutableArray *likeInfos = [NSMutableArray new];
        NSMutableArray *dislikeInfos = [NSMutableArray new];
        
        BOOL hasLike = NO;
        BOOL hasDislike = NO;
        for(CommentUserItem *commentItem in self.userCommentItems) {
            if (commentItem.status==-1) {
                [dislikeIDs addObject:commentItem.userID];
                [dislikeInfos addObject:commentItem.userNickName];
                hasDislike = YES;
            } else if(commentItem.status==1) {
                [likeIDs addObject:commentItem.userID];
                [likeInfos addObject:commentItem.userNickName];
                hasLike = YES;
            }
        }
        
        NSString *likeIdStr = [likeIDs componentsJoinedByString:@","];
        NSString *dislikeIdStr = [dislikeIDs componentsJoinedByString:@","];
        NSString *likeInfoStr = [likeInfos componentsJoinedByString:@","];
        NSString *dislikeInfoStr = [dislikeInfos componentsJoinedByString:@","];

        NSMutableString *appendCommentStr = [[NSMutableString alloc] initWithString:@""];
        if (hasLike) {
            [appendCommentStr appendString:[NSString stringWithFormat:@"赞：%@", likeInfoStr]];
        }
        if (hasDislike) {
            [appendCommentStr appendString:[NSString stringWithFormat:@" 踩：%@", dislikeInfoStr]];
        }
        
        NSString *commentStr = [UPTools encodeToPercentEscapeString:[NSString stringWithFormat:@"%@ %@", commentTextView.text, appendCommentStr]];
        NSString *evaluateStr = [NSString stringWithFormat:@"%@^%@^%@", commentStr, likeIdStr, dislikeIdStr];
        
        [params setObject:evaluateStr forKey:@"evaluate_text"];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //申明请求的数据是json类型
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager POST:kUPReviewCommentPostURL parameters:[self addDescParams:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
                
                [formData appendPartWithFileData:[UPTools compressImage:cutImage] name:[NSString stringWithFormat:@"image_%d",i+1] fileName:[NSString stringWithFormat:@"review_%d.jpg",i+1] mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            NSString *resp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSObject *jsonObj = [UPTools JSONFromString:resp];
            if ([jsonObj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *respDict = (NSDictionary *)jsonObj;
                NSString *resp_desc = respDict[@"resp_desc"];
                
                [MBProgressHUD showSuccess:resp_desc];
                [self commentSuccess];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络错误"];
        }];

    } else if (self.type==UPCommentTypeComment) {
        if (!teleField.text.length) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }

        [MBProgressHUD showMessage:@"正在提交评论...." toView:self.view];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"ActivityJoinModify"forKey:@"a"];
        [params setObject:self.actID forKey:@"activity_id"];
        [params setObject:commentTextView.text forKey:@"evaluate_text"];
        [params setObject:teleField.text forKey:@"contact_no"];
        NSString *userStatus = @"5";
        [params setObject:userStatus forKey:@"user_status"];
        [params setObject:commentLevel forKey:@"evaluate_level_1"];
        
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            
            NSDictionary *dict = (NSDictionary *)json;
            NSString *resp_desc = dict[@"resp_desc"];
            [MBProgressHUD showSuccess:resp_desc];
            [self commentSuccess];
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"网络错误"];
            });
        }];
    } else if (self.type == UPCommentTypeComplain) {
        if (!teleField.text.length) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }

        [MBProgressHUD showMessage:@"正在提交投诉...." toView:self.view];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"ActivityComplain"forKey:@"a"];
        [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
        [params setObject:self.actID forKey:@"activity_id"];
        [params setObject:commentTextView.text forKey:@"text"];
        [params setObject:teleField.text forKey:@"contact_no"];
        [params setObject:@"0" forKey:@"type"];
        [params setObject:[UPDataManager shared].token forKey:@"token"];
        
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
            [MBProgressHUD hideHUDForView:self.view];
            NSDictionary *dict = (NSDictionary *)json;
            NSString *resp_id = dict[@"resp_id"];
            if ([resp_id intValue]==0) {
                NSString *resp_desc = dict[@"resp_desc"];
                [MBProgressHUD showSuccess:resp_desc];
                [self commentSuccess];
            }
            else
            {
                NSString *resp_desc = dict[@"resp_desc"];
                [MBProgressHUD showError:resp_desc];
            }
            
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"网络错误"];
            });
        }];
    } else if (self.type==UPCommentTypeFeedback) {
        
        NSString *contact_no = teleField.text;
        NSString *commentText = commentTextView.text;
        if (contact_no.length==0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的联系方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        if (commentText.length==0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"请输入您的意见" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        [MBProgressHUD showMessage:@"正在提交意见...." toView:self.view];
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setObject:@"ActivityComplain"forKey:@"a"];
        [params setObject:@"0"forKey:@"user_id"];
        [params setObject:commentText forKey:@"text"];
        [params setObject:contact_no forKey:@"contact_no"];
        [params setObject:@"1" forKey:@"type"];
        
        [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
            NSDictionary *dict = (NSDictionary *)json;
            NSString *resp_id = dict[@"resp_id"];
            if ([resp_id intValue]==0) {
                NSString *resp_desc = dict[@"resp_desc"];
                [MBProgressHUD showSuccess:resp_desc];
                [self commentSuccess];
            }
            else
            {
                NSString *resp_desc = dict[@"resp_desc"];
                [MBProgressHUD showError:resp_desc];
            }
            
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showError:@"网络错误"];
            });
        }];
    }
}

- (void)commentSuccess
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentSuccess)]) {
        [self.delegate commentSuccess];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1000) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSMutableArray *)userCommentItems
{
    if (_userCommentItems==nil) {
        _userCommentItems = [NSMutableArray new];
    }
    return _userCommentItems;
}


- (void)showAnticipates:(UIButton *) sender
{
    UPCommentUserView *commentUserView = [[UPCommentUserView alloc] initWithFrame:CGRectMake(20, (ScreenHeight-150)/2, ScreenWidth-40, 150) withCommentUsers:self.userCommentItems];
    commentUserView.delegate = self;
    commentUserView.dataSource = self;
    commentUserView.tag = 1000;
    [self.view addSubview:commentUserView];
    [UIView animateWithDuration:0.5 animations:^{
        commentUserView.backgroundColor = [UIColor grayColor];
    }];
    
    if (self.userCommentItems.count==0) {
        [self requestPeopleEnrolled];
    }
}

- (void)requestPeopleEnrolled
{
    if (hasLoadEnrolledPeople) {
        UPCommentUserView *commentUserView = [self.view viewWithTag:1000];
        if (commentUserView!=nil) {
            [commentUserView reloadData];
        }
        return;
    } else {
        hasLoadEnrolledPeople = YES;
    }
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityJoinInfo"forKey:@"a"];
    
    [params setObject:self.actID forKey:@"activity_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        NSString *resp_desc = dict[@"resp_desc"];
        
        NSLog(@"%@:%@", resp_id, resp_desc);
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            int totalCount = [resp_data[@"total_count"] intValue];
            if (totalCount>0) {
                [self.userCommentItems removeAllObjects];
                NSString *userList = resp_data[@"user_list"];
                if ([userList isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *userDict in (NSArray *)userList) {
                        CommentUserItem *user = [[CommentUserItem alloc] init];
                        user.userID= userDict[@"user_id"];
                        user.userNickName = userDict[@"nick_name"];
                        user.userSexual = userDict[@"sexual"];
                        user.userIcon = userDict[@"user_icon"];
                        user.status = 0;
                        [self.userCommentItems addObject:user];
                    }
                }
            }
        }
        
        UPCommentUserView *commentUserView = [self.view viewWithTag:1000];
        if (commentUserView!=nil) {
            [commentUserView reloadData];
        }
    } failure:^(NSError *error) {
    }];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UPCommentUserDelegate, UPCommentUserDatasource
- (void)commentUserStatusChanged:(NSArray *)newCommentUserItems
{
    if (newCommentUserItems.count==self.userCommentItems.count) {
        for (int i=0; i<self.userCommentItems.count; i++) {
            CommentUserItem *userItem = self.userCommentItems[i];
            CommentUserItem *newUserItem = newCommentUserItems[i];
            userItem.status = newUserItem.status;
        }
    }
}

- (NSArray*)getCommentUsers
{
    return self.userCommentItems;
}

- (UILabel *)createLabelWithFrame:(CGRect)frame withText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
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
