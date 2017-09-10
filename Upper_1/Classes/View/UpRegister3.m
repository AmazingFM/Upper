//
//  UpRegister3.m
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpRegister3.h"
#import "Info.h"
#import "CompanyModel.h"

@interface UpRegister3()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate>
{
    UITableView *_mainTableView;
}
@property (nonatomic, retain) UIImageView *gouImage;

@end

@implementation UpRegister3
{
    int selectedIndex;
//    UIButton *companyB;
    UILabel *companyName;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    selectedIndex = -1;
    
    NSString *companyStr= @"公司\nCompany";
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(8, 0, frame.size.width-2*8, 30)];
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
    else {
        //iOS7.0以下
        [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [self.searchBar setBackgroundColor:[UIColor clearColor]];
    }
    [self addSubview:self.searchBar];
    
    CGSize size = [companyStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:NSLineBreakByWordWrapping];
    UILabel *companyL = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, frame.size.height-2-size.height-2, size.width, size.height)];
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
    
    [self addSubview:seperatorV];
    [self addSubview:companyL];
//    [self addSubview:companyB];
    [self addSubview:companyName];
    [self addSubview:_mainTableView];
    return self;
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
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-2*LeftRightPadding, 44-4)];
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
//    if (selectedIndex!=-1) {
//        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
//        UITableViewCell *cell = [tableView cellForRowAtIndexPath:lastIndexPath];
//         UILabel *lb = [cell viewWithTag:1000];
//        lb.backgroundColor = [UIColor grayColor];
//        lb.textColor = [UIColor blackColor];
//    }
    
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
@end
