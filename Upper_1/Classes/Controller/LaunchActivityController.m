//
//  LaunchActivityController.m
//  Upper_1
//
//  Created by aries365.com on 15/12/8.
//  Copyright © 2015年 aries365.com. All rights reserved.
//
#import "MainController.h"
#import "LaunchActivityController.h"
#import "CustomField.h"
#import "Info.h"
#import "UPTheme.h"
#import "XWHttpTool.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperationManager.h"
#import "UPItemView.h"
#import "UPDataManager.h"
#import "CityItem.h"
#import "pinyin.h"
#import "UPTools.h"

static CGFloat const FixRatio = 4/3.0;

#define GB18030_ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)


#define NormalWidth (ScreenWidth-LeftRightPadding*2)
#define kUPButtonTag 100
#define kItemHeight 44
#define kUPFilePostURL @"http://api.qidianzhan.com.cn/AppServ/index.php?a=ActivityAdd"
#define LeftMargin 10
#define TopMargin 5
#define FontForLabel [UIFont systemFontOfSize:15.0f]
#define ColorForLabel [UIColor blackColor]
#define TextFieldTag 0
#define ButtonTag 100

@interface LaunchActivityController () <UITextFieldDelegate,UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate>
{
    //图片2进制路径
//    NSString *filePath;

    NSData *_imgData;
    UIScrollView *activitiesScro;
    UIImageView *_cameraView;
    UITextView *_actDiscTV;
    
    NSMutableArray<UITextField*> *_fieldArr;
//    NSMutableArray<UIButton*> *_btnArr;
    NSMutableArray *_pickerArr;
    
    UIButton *currentBtn;
    
    NSDictionary *_cityDict;
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_actTypeArr;
    NSArray *_clothTypeArr;
    
    UITextField *minText;
    UITextField *maxText;
    UITextField *actPlaceText;
    
    NSString *activity_name;
    NSString *activity_desc;
    
    NSDate *endDate;
    NSDate *startDate;
    CityItem *_selectedCityItem;
    NSString *activity_place;
    int _isPrepaid;
    NSString *activity_fee;
    NSString *limit_high;
    NSString *limit_low;
    int noLimit;
    int _selectedActType;
    int _selectedClothType;
    int _onlySee;
    
    CGRect textFieldFrame;
    
    
}

@property (nonatomic, retain) UIButton *leftButton;

- (void) openMenu;
@end

@implementation LaunchActivityController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    
    NSArray *titleArr = @[@"活动主题", @"活动介绍",@"报名截止时间",@"活动开始时间", @"活动地点区域", @"活动类型", @"活动场所", @"活动人数", @"着装要求",@"是否预付",@"仅本行业可见"];
    NSArray *tipsArr = @[@"添加活动主题",@"添加活动介绍",@"请选择时间",@"请选择时间", @"请选择区域", @"请选择活动类型", @"请填写活动场所",@"请设置活动人数", @"请选择服装类型", @"是否预付", @"仅本行业可见"];
    
    _fieldArr = [NSMutableArray array];
    
    _imgData = [[NSData alloc] init];
    [self addGesture];
    self.title = @"发起活动";
    
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithLeftIcon:@"top_navigation_lefticon" highIcon:@"" target:self action:@selector(leftClick)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithRightTitle:@"上海" target:self action:nil];

    _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, FirstLabelHeight, 100, 22)];
    [_leftButton setTitle:@"精彩活动" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.tag = kUPButtonTag;
    _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];

    CGFloat y = self.leftButton.origin.y+self.leftButton.height+20;
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, NormalWidth, 17)];
    tipsLabel.text = @"填写活动信息";
    tipsLabel.font = [UIFont systemFontOfSize:13];
    tipsLabel.textColor = [UIColor whiteColor];
    tipsLabel.backgroundColor = [UIColor redColor];

    activitiesScro = [[UIScrollView alloc] initWithFrame:CGRectMake(LeftRightPadding, tipsLabel.origin.y+tipsLabel.height+20, NormalWidth, ScreenHeight-tipsLabel.origin.y-tipsLabel.height-20)];
    activitiesScro.showsHorizontalScrollIndicator = NO;
    activitiesScro.showsVerticalScrollIndicator = NO;
    activitiesScro.scrollEnabled = YES;
    activitiesScro.backgroundColor = [UIColor whiteColor];
    

    
    UIImage *image = [UIImage imageNamed:@"camera"];
    _cameraView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, NormalWidth, 150)];
    _cameraView.backgroundColor = [UIColor grayColor];
    _cameraView.contentMode = UIViewContentModeCenter;
    _cameraView.image = image;
    _cameraView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openMenu)];
    [_cameraView addGestureRecognizer:singleTap];
    singleTap.delegate = self;
    
    CGFloat height = _cameraView.y+_cameraView.height;
    CGFloat width = 100;
    CGFloat scroContentHeight=_cameraView.height;
    
    for (int i=0; i<titleArr.count; i++) {
        if (i==1) {
            _actDiscTV = [[UITextView alloc]initWithFrame:CGRectMake(LeftMargin, height+TopMargin, NormalWidth-2*LeftMargin, 100)];
            
            _actDiscTV.delegate = self;
            _actDiscTV.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _actDiscTV.font = [UIFont systemFontOfSize:13];
            _actDiscTV.text = @"添加活动介绍";
            _actDiscTV.layer.borderColor = [UIColor lightGrayColor].CGColor;
            _actDiscTV.layer.cornerRadius = 5.0f;
            _actDiscTV.layer.borderWidth = 1.0f;
            _actDiscTV.layer.masksToBounds = YES;
            [_actDiscTV setAutocorrectionType:UITextAutocorrectionTypeNo];
            [_actDiscTV setAutocapitalizationType:UITextAutocapitalizationTypeNone];

            
            [activitiesScro addSubview:_actDiscTV];
            
            height += 100;
            scroContentHeight+=100;
            continue;
        }
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(LeftMargin, height+TopMargin, width, kItemHeight-TopMargin)];
        label.font = FontForLabel;
        label.textColor = ColorForLabel;
        label.text = titleArr[i];
        [activitiesScro addSubview:label];

        if (i==0) {
            CustomField *field = [[CustomField alloc] initWithFrame:CGRectMake(width+LeftMargin, height+TopMargin, NormalWidth-width-2*LeftMargin, kItemHeight-TopMargin)];
            field.textAlignment = NSTextAlignmentLeft;
            field.placeholder = tipsArr[i];
            field.font = FontForLabel;
            field.tag = TextFieldTag+i;
            [field setAutocorrectionType:UITextAutocorrectionTypeNo];
            [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];

            [activitiesScro addSubview:field];
            
            [_fieldArr addObject:field];
        }
        else if ((i>=2&&i<=6)||i==8) {
            if (i==6) {
                UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
                searchButton.size=CGSizeMake(100, kItemHeight-TopMargin);
                searchButton.center = CGPointMake(NormalWidth-LeftMargin-50, height+TopMargin+(kItemHeight-TopMargin)/2);
                searchButton.tag = ButtonTag+i;
                [searchButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                
                [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
                [searchButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
                [searchButton setTitle:@"我要推荐" forState:UIControlStateNormal];
                [searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                searchButton.titleLabel.font = FontForLabel;
                searchButton.backgroundColor = [UIColor yellowColor];
                searchButton.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
                searchButton.contentEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 0);
                
                actPlaceText = [[UITextField alloc] init];
                actPlaceText.delegate = self;
                actPlaceText.size = CGSizeMake(searchButton.origin.x-width-LeftMargin-2*LeftRightPadding, kItemHeight-TopMargin-10);
                actPlaceText.center = CGPointMake((searchButton.origin.x+width+LeftMargin)/2, height+TopMargin+(kItemHeight-TopMargin)/2);
                actPlaceText.placeholder = @"请输入活动场所";
                actPlaceText.borderStyle = UITextBorderStyleRoundedRect;
                actPlaceText.font = [UIFont systemFontOfSize:15.0f];
                [actPlaceText setAutocorrectionType:UITextAutocorrectionTypeNo];
                [actPlaceText setAutocapitalizationType:UITextAutocapitalizationTypeNone];

                
                [activitiesScro addSubview:searchButton];
                [activitiesScro addSubview:actPlaceText];
                
//                [_btnArr addObject:searchButton];
            } else {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(NormalWidth/2-LeftMargin, TopMargin+height, NormalWidth/2, kItemHeight-TopMargin);
                [button setTitle:[NSString stringWithFormat:@"%@〉", tipsArr[i]] forState:UIControlStateNormal];
                [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                button.titleLabel.font = FontForLabel;
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = ButtonTag+i;
                [activitiesScro addSubview:button];
                
//                [_btnArr addObject:button];
            }
        }
        else if (i==7) {
            minText = [[UITextField alloc] init];
            minText.delegate= self;
            minText.size = CGSizeMake(40, kItemHeight-TopMargin-10);
            minText.center = CGPointMake(width+LeftMargin+20+20, height+TopMargin+(kItemHeight-TopMargin)/2);
            minText.keyboardType = UIKeyboardTypeNumberPad;
            minText.borderStyle = UITextBorderStyleRoundedRect;
            minText.font = [UIFont systemFontOfSize:15.0f];
            [minText setAutocorrectionType:UITextAutocorrectionTypeNo];
            [minText setAutocapitalizationType:UITextAutocapitalizationTypeNone];

            
            UILabel *infoLl = [[UILabel alloc] initWithFrame:CGRectMake(minText.frame.origin.x+40+LeftRightPadding, height+TopMargin, 20, kItemHeight-TopMargin)];
            infoLl.text = @"至";
            
            maxText = [[UITextField alloc] init];
            maxText.delegate = self;
            maxText.size = CGSizeMake(40, kItemHeight-TopMargin-10);
            maxText.center = CGPointMake(infoLl.frame.origin.x+20+LeftRightPadding+20, height+TopMargin+(kItemHeight-TopMargin)/2);
            maxText.keyboardType = UIKeyboardTypeNumberPad;
            maxText.borderStyle = UITextBorderStyleRoundedRect;
            maxText.font = [UIFont systemFontOfSize:15.0f];
            [maxText setAutocorrectionType:UITextAutocorrectionTypeNo];
            [maxText setAutocapitalizationType:UITextAutocapitalizationTypeNone];

            
            UILabel *infoL2 = [[UILabel alloc] initWithFrame:CGRectMake(maxText.frame.origin.x+40+LeftRightPadding, height+TopMargin, 20, kItemHeight-TopMargin)];
            infoL2.text = @"人";
            
            [activitiesScro addSubview:minText];
            [activitiesScro addSubview:infoLl];
            [activitiesScro addSubview:maxText];
            [activitiesScro addSubview:infoL2];
            
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBtn.size=CGSizeMake(80, kItemHeight-TopMargin);
            checkBtn.center = CGPointMake(NormalWidth-LeftMargin-40, height+TopMargin+(kItemHeight-TopMargin)/2);
            checkBtn.tag = ButtonTag+i;
            [checkBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

            [checkBtn setImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateNormal];
            [checkBtn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
            [checkBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [checkBtn setTitle:@"无限制" forState:UIControlStateNormal];
            [checkBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            checkBtn.titleLabel.font = FontForLabel;
            checkBtn.backgroundColor = [UIColor clearColor];
            checkBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 4, 0, 0);
            checkBtn.contentEdgeInsets=UIEdgeInsetsMake(0, 8, 0, 0);
        
            [activitiesScro addSubview:checkBtn];
        }
        else if (i==9) {
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBtn.size=CGSizeMake(20, 20);
            checkBtn.center = CGPointMake(NormalWidth-LeftMargin-10, height+TopMargin+(kItemHeight-TopMargin)/2);
            [checkBtn setBackgroundImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateNormal];
            [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
            checkBtn.tag = ButtonTag+i;
            [checkBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            
            UITextField *field = [[UITextField alloc] init];
            field.delegate = self;
            field.size = CGSizeMake(100, kItemHeight-TopMargin-10);
            field.center = CGPointMake(checkBtn.origin.x-50-LeftRightPadding, height+TopMargin+(kItemHeight-TopMargin)/2);
            field.textAlignment = NSTextAlignmentLeft;
            field.borderStyle = UITextBorderStyleRoundedRect;
            field.placeholder = @"金额：元";
            field.font = FontForLabel;
            field.tag = TextFieldTag+i;
            field.hidden = NO;
            field.keyboardType = UIKeyboardTypeNamePhonePad;
            [field setAutocorrectionType:UITextAutocorrectionTypeNo];
            [field setAutocapitalizationType:UITextAutocapitalizationTypeNone];

            
            [activitiesScro addSubview:checkBtn];
            [activitiesScro addSubview:field];
            
            [_fieldArr addObject:field];
            
        }
        else if (i==10) {
            UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            checkBtn.size=CGSizeMake(20, 20);
            checkBtn.center = CGPointMake(NormalWidth-LeftMargin-10, height+TopMargin+(kItemHeight-TopMargin)/2);
            [checkBtn setBackgroundImage:[UIImage imageNamed:@"uncheckbox"] forState:UIControlStateNormal];
            [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateSelected];
            checkBtn.tag = ButtonTag+i;
            [checkBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [activitiesScro addSubview:checkBtn];
        }
        
        height += kItemHeight;
        scroContentHeight += kItemHeight;
    }
    
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0, height+TopMargin-1, NormalWidth, 1)];
    line.backgroundColor=[UIColor grayColor];
    
    UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, height+TopMargin, NormalWidth, kItemHeight-TopMargin)];

    [submitButton setTitle:@"提交活动" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    submitButton.backgroundColor = [UIColor clearColor];
    submitButton.tag = ButtonTag+11;
    [submitButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    scroContentHeight += kItemHeight;

    
    [activitiesScro addSubview:_cameraView];
    [activitiesScro addSubview:line];
    [activitiesScro addSubview:submitButton];
    
    [activitiesScro setContentSize:CGSizeMake(NormalWidth, scroContentHeight)];

    [self.view addSubview:self.leftButton];
    [self.view addSubview:tipsLabel];
    
    [self.view addSubview:activitiesScro];
    
    [self createPanelView];

}

- (void)initInfo
{
    //城市信息
    _cityDict= [UPDataManager shared].provinceDict;
    
    NSArray *tempProvinceArr = [NSArray arrayWithArray:[_cityDict allKeys]];
    
    NSComparator comparator = ^(NSString *obj1, NSString *obj2){
        if ([obj1 isEqualToString:@"重庆市"]) {
            obj1 = @"虫庆市";
        }
        if ([obj2 isEqualToString:@"重庆市"]) {
            obj2 = @"虫庆市";
        }

        
        NSString *str1 = [obj1 stringByAddingPercentEscapesUsingEncoding:GB18030_ENCODING];
        NSString *str2 = [obj2 stringByAddingPercentEscapesUsingEncoding:GB18030_ENCODING];
        
        return [str1 compare:str2];
    };
    _provinceArr = [tempProvinceArr sortedArrayUsingComparator:comparator];
    
    NSArray *tempCityArr = [NSArray arrayWithArray:[_cityDict objectForKey:tempProvinceArr[0]]];
    _cityArr = [tempCityArr sortedArrayUsingComparator:^(id obj1, id obj2){
        CityItem *item1 = (CityItem *)obj1;
        CityItem *item2 = (CityItem *)obj2;
        return [item1.first_letter compare: item2.first_letter];
    }];
    //活动类型
    _actTypeArr = @[@"不限", @"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动",@"交友、徒步"];
    _clothTypeArr = @[@"随性", @"西装领带", @"便装"];
}

- (void)recommend:(UIButton *)sender
{
    
}

- (void)onClick:(UIButton *)sender
{
    currentBtn = sender;
    switch(sender.tag)
    {
        case ButtonTag+2://报名截止时间、活动开始时间
        case ButtonTag+3:
        {
//            currentBtn = sender;
            _datePickerView.hidden = NO;
            _datePickerView.tag = sender.tag+100;
            [self showDatePanel];
        }
            break;
        case ButtonTag+4://活动地点区域
        {
//            currentBtn = sender;
            _cityPickerView.hidden = NO;
            _cityPickerView.tag = sender.tag+100;
            [self showCityPanel];
        }
            break;
        case ButtonTag+5://活动类型
        case ButtonTag+8://着装要求
        {
            _typePickerView.hidden = NO;
            _typePickerView.tag = sender.tag+100;
            [self showTypePanel];
            break;
        }
        case ButtonTag+7://活动人数
        {
            sender.selected = [sender isSelected]?NO:YES;
            noLimit = sender.selected?1:0;
        }
            break;
        case ButtonTag+9:
        {
            sender.selected = [sender isSelected]?NO:YES;
            _isPrepaid = sender.selected?1:0;
            _fieldArr[1].hidden=!sender.isSelected;
        }
            break;
        case ButtonTag+10:
        {
            sender.selected = [sender isSelected]?NO:YES;
            _onlySee = sender.selected?1:0;
        }
            break;
        case ButtonTag+11: //提交活动
        {
            [self startCreateActivity];
        }
            break;
        default:
            break;
    }
}

#pragma mark -panel view methods
- (void)createPanelView
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    CGFloat kBorder = 5;

    _hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height-64)];
    _hideBtn.alpha=0.1f;
    _hideBtn.backgroundColor=[UIColor lightGrayColor];
    [_hideBtn addTarget:self action:@selector(dismissDatePanel) forControlEvents:UIControlEventTouchUpInside];
    _hideBtn.hidden = YES;
    
    //---------------------------
    _datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(kBorder, 0, width-4*kBorder, 150)];
    [_datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    _datePickerView.minimumDate = [NSDate date];
    _datePickerView.minuteInterval = 30*60*60*24;
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datePickerView.locale = locale;
    _datePickerView.hidden = YES;
    
    _cityPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kBorder, 0, width-4*kBorder, 150)];
    _cityPickerView.dataSource = self;
    _cityPickerView.delegate = self;
    _cityPickerView.hidden = YES;
    
    
    _typePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kBorder, 0, width-4*kBorder, 150)];
    _typePickerView.dataSource = self;
    _typePickerView.delegate = self;
    _typePickerView.hidden = YES;
    
    //---------------------------
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _confirmBtn.frame = CGRectMake(kBorder, 148, width-4*kBorder, 44);
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor blueColor];
    _confirmBtn.layer.cornerRadius = 5.0f;
    [_confirmBtn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _datePanelView = [[UIView alloc] initWithFrame:CGRectMake(kBorder, height, width-2*kBorder, 200)];
    _datePanelView.backgroundColor = [UIColor whiteColor];
    _datePanelView.layer.cornerRadius=5.0f;
    _datePanelView.layer.masksToBounds=YES;
    
    [_datePanelView addSubview:_datePickerView];
    [_datePanelView addSubview:_cityPickerView];
    [_datePanelView addSubview:_typePickerView];
    
    [_datePanelView addSubview:_confirmBtn];
    
    [self.view addSubview:_hideBtn];
    [self.view addSubview:_datePanelView];
}

-(void)showTypePanel
{
    _hideBtn.hidden = NO;
    [_typePickerView reloadComponent:0];
    [currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden = NO;
        CGRect dateFrame = _datePanelView.frame;
        dateFrame.origin.y-=dateFrame.size.height;
        _datePanelView.frame = dateFrame;
    }];
    
}

-(void)showCityPanel
{
    _hideBtn.hidden = NO;
    [currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden = NO;
        CGRect dateFrame = _datePanelView.frame;
        dateFrame.origin.y-=dateFrame.size.height;
        _datePanelView.frame = dateFrame;
    }];

}

-(void)showDatePanel
{
    _hideBtn.hidden = NO;
    [currentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    if (currentBtn.tag==ButtonTag+3) {
        _datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    } else {
        _datePickerView.datePickerMode = UIDatePickerModeDate;
    }
    if (currentBtn.titleLabel.text.length!=0 && [currentBtn.titleLabel.text rangeOfString:@"请选择"].location==NSNotFound) {
        
        NSDate *date = [formatter dateFromString:currentBtn.titleLabel.text];
        _datePickerView.date = date;
    }

    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden = NO;
        CGRect dateFrame = _datePanelView.frame;
        dateFrame.origin.y-=dateFrame.size.height;
        _datePanelView.frame = dateFrame;
    }];
}

-(void)confirmClicked:(UIButton *)btn{
    [self dismissDatePanel];
    if (currentBtn.tag==ButtonTag+2
        ||currentBtn.tag==ButtonTag+3) {
        [self datePickerChanged:_datePickerView];
    }
}

- (void)datePickerChanged:(UIDatePicker *)picker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    NSString* dateValue=[formatter stringFromDate:picker.date];
    [currentBtn setTitle:dateValue forState:UIControlStateNormal];
    [currentBtn setTitle:dateValue forState:UIControlStateHighlighted];
    
    if (currentBtn.tag==ButtonTag+2) {
        endDate = picker.date;
    }
    else if(currentBtn.tag==ButtonTag+3) {
        startDate = picker.date;
    }
    
}

-(void)dismissDatePanel{
    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden=YES;
        CGRect dateFrame=_datePanelView.frame;
        dateFrame.origin.y+=dateFrame.size.height;
        _datePanelView.frame=dateFrame;
        
        [_datePanelView viewWithTag:currentBtn.tag+100].hidden = YES;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UIPickerDelegate, UIPickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView==_cityPickerView) {
        return 2;
    }
    if (pickerView==_typePickerView) {
        return 1;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger count = 0;
    if (pickerView==_cityPickerView) {
        switch (component) {
            case 0:
                count = _provinceArr.count;
                break;
            case 1:
                count = _cityArr.count;
                break;
            default:
                break;
        }
    }
    if (pickerView == _typePickerView) {
        if (currentBtn.tag==ButtonTag+5) {
            count = _actTypeArr.count;
        } else if (currentBtn.tag==ButtonTag+8) {
            count =  _clothTypeArr.count;
        }
    }
    
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = @"";
    if (pickerView==_cityPickerView) {
        switch (component) {
            case 0:
                str = _provinceArr[row];
                break;
            case 1:
                str = ((CityItem*)_cityArr[row]).city;
                break;
            default:
                break;
        }
    }
    if (pickerView == _typePickerView) {
        if (currentBtn.tag==ButtonTag+5) {
            str = _actTypeArr[row];
        } else if (currentBtn.tag==ButtonTag+8) {
            str = _clothTypeArr[row];
        }
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView==_cityPickerView) {
        switch (component) {
            case 0:
                _cityArr = [_cityDict objectForKey:_provinceArr[row]];
                [pickerView reloadComponent:1];
                //[pickerView selectRow:0 inComponent:1 animated:YES];
                NSInteger selectedIdx = [pickerView selectedRowInComponent:1];
                _selectedCityItem = (CityItem *)_cityArr[selectedIdx];
                [currentBtn setTitle:[NSString stringWithFormat:@"%@ %@",_selectedCityItem.province,_selectedCityItem.city] forState:UIControlStateNormal];
                break;
            case 1:
                _selectedCityItem = (CityItem *)_cityArr[row];
                [currentBtn setTitle:[NSString stringWithFormat:@"%@ %@",_selectedCityItem.province,_selectedCityItem.city] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    if (pickerView == _typePickerView) {
        if (currentBtn!=nil) {
            if (currentBtn.tag == ButtonTag+5) {
                _selectedActType = (int)row;
                [currentBtn setTitle:[NSString stringWithFormat:@"%@",_actTypeArr[row]] forState:UIControlStateNormal];
            }
            if (currentBtn.tag == ButtonTag+8) {
                _selectedClothType = (int)row;
                [currentBtn setTitle:[NSString stringWithFormat:@"%@",_clothTypeArr[row]] forState:UIControlStateNormal];
            }
        }
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        CGSize size = [pickerView rowSizeForComponent:component];
        pickerLabel.size = size;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:18];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
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

//        UIImage *iconImage;
//        if (kWidth>100) {
//            iconImage = [UPTools image:cutImage scaledToSize:CGSizeMake(100, 100/FixRatio)];
//        } else {
//            iconImage = cutImage;
//        }
//        
//        NSData *data = UIImageJPEGRepresentation(iconImage, 0.5);
        
        _imgData = [[NSData alloc] initWithData:data];
        
//        //图片保存的路径
//        //这里讲图片放在沙盒的documents文件夹中
//        NSString *documentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
//        //文件管理器
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        //把刚刚图片转换的data对象拷贝至沙盒中，并保存为image.png
//        [fileManager createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
//        [fileManager createFileAtPath:[documentsPath stringByAppendingString:@"image.png"] contents:data attributes:nil];
//        
//        //得到选择后沙盒中图片的完整路径
//        filePath = [[NSString alloc]initWithFormat:@"%@%@",documentsPath, @"/image.png"];
        
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        _cameraView.contentMode = UIViewContentModeScaleAspectFill;
        _cameraView.clipsToBounds = YES;
        _cameraView.image = image;
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

- (float)heightForString:(NSString *)value  fontSize:(float)fontSize andWidth:(float)width
{
    float height = [value boundingRectWithSize:(CGSizeMake(width, CGFLOAT_MAX)) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName, nil] context:nil].size.height;
    return height;
}

-(void)leftClick
{
//    [((MainController *)self.parentController).parentController leftClick];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 给当前view添加识别手势
-(void)addGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}

-(void)tap
{
    [self.view endEditing:YES];
}

#pragma mark - 提交活动
- (void)startCreateActivity
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    activity_name = _fieldArr[0].text;
    activity_desc = _actDiscTV.text;
    
    NSString *begin_time = [formatter stringFromDate:[NSDate date]];
    NSString *end_time = [formatter stringFromDate:endDate];
    NSString *start_time = [formatter stringFromDate:startDate];
    activity_place = actPlaceText.text;
    
    NSString *industry_id;
    if (_onlySee==1) {
        industry_id = [UPDataManager shared].userInfo.industry_id;
    } else {
        industry_id = @"-1";
    }

    if (_isPrepaid==1) {
        activity_fee= _fieldArr[1].text;
    }
    else {
        activity_fee = @"0";
    }
    
    if (noLimit==1) {
        limit_high=@"9999";
        limit_low = @"0";
    }
    else {
        limit_high = maxText.text;
        limit_low = minText.text;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明请求的数据是json类型
    //manager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"POST", @"GET", @"HEAD"]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:activity_name forKey:@"activity_name"];
    [params setObject:activity_desc forKey:@"activity_desc"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedActType] forKey:@"activity_class"];
    [params setObject:begin_time forKey:@"begin_time"];
    [params setObject:end_time forKey:@"end_time"];
    [params setObject:start_time forKey:@"start_time"];
    [params setObject:_selectedCityItem.province_code forKey:@"province_code"];
    [params setObject:_selectedCityItem.city_code forKey:@"city_code"];
    [params setObject:_selectedCityItem.town_code forKey:@"town_code"];
    [params setObject:@"" forKey:@"activity_place_code"];
    [params setObject:activity_place forKey:@"activity_place"];
    [params setObject:@"" forKey:@"is_prepaid"];
    [params setObject:industry_id forKey:@"industry_id"];
    [params setObject:activity_fee forKey:@"activity_fee"];
    [params setObject:limit_high forKey:@"limit_count"];
    [params setObject:limit_low forKey:@"limit_low"];
    [params setObject:[NSString stringWithFormat:@"%d", _selectedClothType]  forKey:@"clothes_need"];
    
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
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //跳转到首页
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)keyboardWillShow:(NSNotification *)note
{
    NSDictionary *info = [note userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [self adjustFrameView:keyboardSize.height];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    UIEdgeInsets e = UIEdgeInsetsMake(0,0,0,0);
    [activitiesScro setContentInset:e];
    [UIView commitAnimations];
}

- (void)adjustFrameView:(CGFloat)keyboardHeight
{
    //子类实现
    int offset = LeftRightPadding + textFieldFrame.origin.y + 30 - (self.view.frame.size.height - keyboardHeight);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    if (offset>0) {
        UIEdgeInsets e = UIEdgeInsetsMake(0,0,offset,0);
        [activitiesScro setContentInset:e];
    }
    [UIView commitAnimations];
}

#pragma mark -UITextFieldDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textFieldFrame = textView.frame;
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textFieldFrame = textField.frame;
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
