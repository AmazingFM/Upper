//
//  UPRegisterSecondController.m
//  Upper
//
//  Created by 张永明 on 2017/10/31.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRegisterSecondController.h"
#import "UPRegisterThirdController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Info.h"
#import "UPConfig.h"
#import "IndustryModel.h"
#import "DrawSomething.h"
#import "NSObject+MJKeyValue.h"
#import "YMNetwork.h"

#define BtnSpace 40
@interface UPRegisterSecondController ()
{
    NSMutableArray<IndustryModel *> *industryCategory;
    NSMutableArray<UIButton *> *industryButtonArr;
    int selectedIndex;
    UIButton * industryB;
}

@property (nonatomic, retain) NSString *industryId;

@property (nonatomic, retain) UIScrollView *contentScro;
@property (nonatomic, retain) UIImageView *gouImage;

@property (nonatomic,retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *preBtn;
@property (nonatomic,retain) UILabel *tipsLabel;

@end

@implementation UPRegisterSecondController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"注册";
    UIImageView *backImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_cover_gaussian"]];
    backImg.userInteractionEnabled = NO;
    backImg.frame = self.view.bounds;
    [self.view addSubview:backImg];
    
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"上一步" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    
    self.navigationItem.leftBarButtonItem = leftBarItem;
    self.navigationItem.rightBarButtonItem = nil;
    
    CGFloat y = FirstLabelHeight;
    
    NSString *tipsText = @"Step2:选择行业";
    CGSize tipsSize = SizeWithFont(tipsText, [UIFont systemFontOfSize:12]);
    
    self.tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, y, tipsSize.width+5, tipsSize.height)];
    
    self.tipsLabel.text = tipsText;
    self.tipsLabel.font = [UIFont systemFontOfSize:12];
    self.tipsLabel.textColor = [UIColor whiteColor];
    self.tipsLabel.backgroundColor = [UIColor blackColor];
    
    CGSize size = SizeWithFont(@"上一步",kUPThemeMiddleFont);
    size.width +=20;
    size.height += 10;
    
    self.preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.preBtn.titleLabel.font = kUPThemeMiddleFont;
    self.preBtn.tag = 11;
    self.preBtn.frame = CGRectMake(BtnSpace, ScreenHeight-size.height-20, size.width, size.height);
    [self.preBtn.layer setMasksToBounds:YES];
    [self.preBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    self.preBtn.backgroundColor = [UIColor whiteColor];
    [self.preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.preBtn addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextBtn.tag = 12;
    self.nextBtn.titleLabel.font = kUPThemeMiddleFont;
    self.nextBtn.frame = CGRectMake(ScreenWidth-BtnSpace-size.width, ScreenHeight-size.height-20, size.width, size.height);
    [self.nextBtn.layer setMasksToBounds:YES];
    [self.nextBtn.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    self.nextBtn.backgroundColor = [UIColor whiteColor];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.nextBtn addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    selectedIndex = -1;
    industryButtonArr = [[NSMutableArray alloc]init];
    
    NSString *industyStr= @"行业\nIndustry";

    size = [industyStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect frame = CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20);
    UILabel *industryL = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, frame.size.height-2-size.height-2, size.width, size.height)];
    industryL.textAlignment = NSTextAlignmentRight;
    industryL.numberOfLines = 0;
    industryL.text = industyStr;
    industryL.backgroundColor = [UIColor clearColor];
    industryL.font = [UIFont systemFontOfSize:12];
    industryL.textColor = [UIColor whiteColor];
    
    industryB = [[UIButton alloc]initWithFrame:CGRectMake(size.width+LeftRightPadding, industryL.origin.y, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    industryB.backgroundColor = [UIColor clearColor];
    [industryB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *privacyText = @"提示：您选择的行业，单位或邮箱信息均只作为验证用途，将会被严格保密，除非您本人要求，否则不会显示给其他用户。";
    CGRect privacyRect = [privacyText boundingRectWithSize:CGSizeMake( frame.size.width-2*LeftRightPadding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kUPThemeNormalFont} context:nil];
    
    UILabel *privacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, floorf(industryL.origin.y- ceilf(privacyRect.size.height)), frame.size.width-2*LeftRightPadding, ceilf(privacyRect.size.height+20))];
    privacyLabel.center = self.view.center;
    privacyLabel.numberOfLines = 0;
    privacyLabel.font = kUPThemeNormalFont;
    privacyLabel.textColor = [UIColor whiteColor];
    privacyLabel.text = privacyText;
    privacyLabel.textAlignment = NSTextAlignmentLeft;
    privacyLabel.backgroundColor = [UIColor clearColor];
    
    UIImageView * seperatorV = [[UIImageView alloc]initWithFrame:CGRectMake(LeftRightPadding, frame.size.height-2, frame.size.width-2*LeftRightPadding, 1)];
    seperatorV.backgroundColor = [UIColor blackColor];
    
    _contentScro = [[UIScrollView alloc] initWithFrame:CGRectMake(LeftRightPadding, 0, frame.size.width-2*LeftRightPadding, industryB.origin.y-10)];
    _contentScro.showsHorizontalScrollIndicator = NO;
    _contentScro.showsVerticalScrollIndicator = NO;
    _contentScro.scrollEnabled = YES;
    
    _gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Selected"]];
    [_gouImage setSize:CGSizeMake(10, 10)];
    [_gouImage setCenter:CGPointMake(-100, -100)];
    [_contentScro addSubview:_gouImage];
    
    [self.view addSubview:seperatorV];
    [self.view addSubview:industryL];
    [self.view addSubview:privacyLabel];
    [self.view addSubview:industryB];
    [self.view addSubview:_contentScro];
    
    [self requestIndustryInfo];
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

- (void)loadIndustryData:(id)respData
{
    NSDictionary *dict = (NSDictionary *)respData;
    
    
    NSArray<IndustryModel*> *tempArr = [IndustryModel objectArrayWithKeyValuesArray:dict[@"industry_list"]];
    
    industryCategory = [[NSMutableArray alloc] initWithArray:tempArr];
    
    int nCount=0;
    CGFloat btnWidth = (_contentScro.size.width-30)/4;
    CGFloat btnHeight = btnWidth/2.5;
    int row = 0;
    
    [self resetSubView];
    [industryButtonArr removeAllObjects];
    
    for (IndustryModel *obj in industryCategory) {
        UIButton *tmp = [[UIButton alloc]init];
        tmp.layer.masksToBounds = YES;
        [tmp.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [tmp setBackgroundImage:[UIImage imageNamed:@"select_bg"] forState:UIControlStateSelected];
        [tmp setBackgroundImage:[UIImage imageNamed:@"unselect_bg"] forState:UIControlStateNormal];
        row = nCount/4;
        
        tmp.titleLabel.font = kUPThemeNormalFont;
        [tmp setFrame:CGRectMake(nCount%4*(btnWidth+10), row*(btnHeight+15), btnWidth, btnHeight)];
        [tmp setTitle:obj.industry_name forState:UIControlStateNormal];
        tmp.tag = nCount;
        tmp.titleLabel.adjustsFontSizeToFitWidth = YES;
        [tmp addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [industryButtonArr addObject:tmp];
        [_contentScro addSubview:tmp];
        nCount++;
    }
    
    [_contentScro setContentSize:CGSizeMake(ScreenWidth-2*LeftRightPadding, (row+1)*(btnHeight+15))];
}

-(void)buttonClick:(UIButton *)sender
{
    [sender setSelected:YES];
    
    if (selectedIndex == sender.tag) {
        return;
    }
    
    if (selectedIndex == -1) {
        selectedIndex = (int)sender.tag;
        [industryB setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        _industryId = industryCategory[selectedIndex].ID;
    }
    else{
        [industryButtonArr[selectedIndex] setSelected:NO];
        selectedIndex = (int)sender.tag;
        [industryB setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        _industryId = industryCategory[selectedIndex].ID;
    }
    [_gouImage setCenter:CGPointMake(sender.x+sender.width-5, sender.y+5)];
    [_contentScro bringSubviewToFront:_gouImage];
    return;
}

- (void)resetSubView
{
    for (UIView *tmp in industryButtonArr) {
        [tmp removeFromSuperview];
    }
    [_gouImage setCenter:CGPointMake(-100, -100)];
    selectedIndex = -1;
}

-(void)clearValue
{
    _industryId=nil;
}

- (void)requestIndustryInfo
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"IndustryQuery" forKey:@"a"];
    [params setValue:_cityId forKey:@"cityId"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            [self loadIndustryData:resp_data];
        }
        else
        {
            NSDictionary *dict = (NSDictionary *)responseObject;
            NSString *resp_desc = dict[@"resp_desc"];
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"失败" message:resp_desc delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)navButtonClick:(UIButton *)sender
{
    if (sender.tag ==11) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (sender.tag==12) {
        if (selectedIndex==-1) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择行业" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];

        }
        
        UPRegisterThirdController *thirdController = [[UPRegisterThirdController alloc] init];
        thirdController.cityId = self.cityId;
        thirdController.provId = self.provId;
        thirdController.townId = self.townId;
        thirdController.industryId = self.industryId;
        [self.navigationController pushViewController:thirdController animated:YES];
    }
}

@end
