//
//  UPRegisterThirdController.m
//  Upper
//
//  Created by 张永明 on 2017/10/31.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPRegisterThirdController.h"
#import "UPRegisterFourthController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "Info.h"
#import "UPConfig.h"
#import "DrawSomething.h"
#import "NSObject+MJKeyValue.h"
#import "YMNetwork.h"
#import "CompanyModel.h"

#define BtnSpace 40
@interface UPRegisterThirdController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>
{
    int selectedIndex;
    UILabel *companyName;
    
    UITableView *_mainTableView;
}

@property (nonatomic, retain) UIImageView *gouImage;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *emailSuffix;

@property (nonatomic, retain) UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableArray *companyCategory;
@property (nonatomic, retain) NSMutableArray *showCompany;

@property (nonatomic,retain) UIButton *nextBtn;
@property (nonatomic, retain) UIButton *preBtn;
@property (nonatomic,retain) UILabel *tipsLabel;
@end

@implementation UPRegisterThirdController

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
    
    NSString *tipsText = @"Step3:选择公司";
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
    
    NSString *companyStr= @"公司\nCompany";
    
    CGRect frame = CGRectMake(0, _tipsLabel.origin.y+_tipsLabel.height+10, ScreenWidth, _nextBtn.origin.y-_tipsLabel.origin.y-_tipsLabel.height-20);
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, CGRectGetMinY(frame), frame.size.width-2*8, 30)];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.translucent = YES;
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入公司代码";
    self.searchBar.keyboardType = UIKeyboardTypeDefault;
    self.searchBar.returnKeyType = UIReturnKeyDone;
    if ([self.searchBar respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (g_nOSVersion >= iosversion7_1) {
            [[[[self.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self.searchBar setBackgroundColor:[UIColor clearColor]];
        }
        else {            //iOS7.0
            [self.searchBar setBarTintColor:[UIColor clearColor]];
            [self.searchBar setBackgroundColor:[UIColor clearColor]];
        }
    }
    [self.view addSubview:self.searchBar];
    
    size = [companyStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *companyL = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, CGRectGetMinY(frame)+frame.size.height-2-size.height-2, size.width, size.height)];
    companyL.textAlignment = NSTextAlignmentRight;
    companyL.numberOfLines = 0;
    companyL.text = companyStr;
    companyL.backgroundColor = [UIColor clearColor];
    companyL.font = [UIFont systemFontOfSize:12];
    companyL.textColor = [UIColor whiteColor];
    
    companyName = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding+size.width, companyL.origin.y, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    companyName.backgroundColor = [UIColor clearColor];
    companyName.textColor = [UIColor whiteColor];
    companyName.font = [UIFont systemFontOfSize:15.0f];
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.adjustsFontSizeToFitWidth = YES;
    
    UIImageView * seperatorV = [[UIImageView alloc]initWithFrame:CGRectMake(LeftRightPadding, frame.size.height-2*2, frame.size.width, 1)];
    seperatorV.backgroundColor = [UIColor blackColor];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftRightPadding, self.searchBar.height+5, frame.size.width-2*LeftRightPadding, companyName.origin.y-10-self.searchBar.height-5) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.layer.cornerRadius = 5.f;
    _mainTableView.layer.masksToBounds = YES;
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Selected"]];
    [_gouImage setSize:CGSizeMake(10, 10)];
    [_gouImage setCenter:CGPointMake(-100, -100)];
    
    [self.view addSubview:seperatorV];
    [self.view addSubview:companyL];
    [self.view addSubview:companyName];
    [self.view addSubview:_mainTableView];
    
    [self requestCompanyInfo];
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

- (NSMutableArray *)companyCategory
{
    if (_companyCategory==nil) {
        _companyCategory = [NSMutableArray array];
    }
    return _companyCategory;
}

- (NSMutableArray *)showCompany
{
    if (_showCompany==nil) {
        _showCompany = [NSMutableArray array];
    }
    return _showCompany;
}

- (void)loadCompanyData:(id)respData
{
    [self.companyCategory removeAllObjects];
    [self.showCompany removeAllObjects];
    NSDictionary *dict = (NSDictionary *)respData;
    
    NSArray<CompanyModel*> *tempArr = [CompanyModel objectArrayWithKeyValuesArray:dict[@"node_list"]];
    if (tempArr && tempArr.count) {
        [self.companyCategory addObjectsFromArray:tempArr];
        [self.showCompany addObjectsFromArray:self.companyCategory];
    }
    [_mainTableView reloadData];
}

#pragma mark UITableViewDelegate, UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showCompany.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *nameLabel = [cell viewWithTag:1000];
    if(nameLabel!=nil){
        [nameLabel removeFromSuperview];
    }
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-2*LeftRightPadding, 44-4)];
    nameLabel.layer.cornerRadius = 5.f;
    nameLabel.layer.masksToBounds = YES;
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.font = [UIFont systemFontOfSize:15.0f];
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.tag = 1000;
    nameLabel.backgroundColor = [UIColor grayColor];
    nameLabel.textColor = [UIColor blackColor];
    
    CompanyModel *companyModel = self.showCompany[indexPath.row];
    nameLabel.text = companyModel.node_name;
    [cell addSubview:nameLabel];
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lb = [cell viewWithTag:1000];
    lb.backgroundColor = [UIColor redColor];
    lb.textColor = [UIColor whiteColor];
    selectedIndex = (int)indexPath.row;
    
    CompanyModel *model = self.showCompany[indexPath.row];
    companyName.text = model.node_name;
    _companyId = model.ID;
    _emailSuffix = model.node_email_suffix;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lb = [cell viewWithTag:1000];
    lb.backgroundColor = [UIColor grayColor];
    lb.textColor = [UIColor blackColor];
}

-(void)clearValue
{
    _companyId=nil;
}

-(NSString *)alertMsg
{
    if (selectedIndex==-1) {
        return @"请选择公司";
    }
    else
        return @"";
}

#pragma mark UISearchBar Delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length==0){
        [self.showCompany removeAllObjects];
        [self.showCompany addObjectsFromArray:self.companyCategory];
        [_mainTableView reloadData];
        return;
    }
    
    [self searchText:searchBar.text];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchText:(NSString *)searchText
{
    [self.showCompany removeAllObjects];
    for (CompanyModel *model in self.companyCategory) {
        if([[model.node_name lowercaseString] rangeOfString:[searchText lowercaseString]].location!=NSNotFound) {
            [self.showCompany addObject:model];
        }
    }
    [_mainTableView reloadData];
}

- (void)resetSubView
{
    companyName.text = @"";
}

- (void)requestCompanyInfo
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"NodeQuery" forKey:@"a"];
    [params setValue:_cityId forKey:@"city_code"];
    [params setValue:_industryId forKey:@"industry_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        
        if ([resp_id intValue]==0) {
            NSDictionary *resp_data = dict[@"resp_data"];
            [self loadCompanyData:resp_data];
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
        
        UPRegisterFourthController *fourthController = [[UPRegisterFourthController alloc] init];
        fourthController.cityId = self.cityId;
        fourthController.provId = self.provId;
        fourthController.townId = self.townId;
        fourthController.industryId = self.industryId;
        fourthController.companyId = self.companyId;
        fourthController.emailSuffix = self.emailSuffix;
        
        [self.navigationController pushViewController:fourthController animated:YES];
    }
}

@end
