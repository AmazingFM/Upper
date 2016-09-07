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

@interface UpRegister3()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
}
@property (nonatomic, retain) UIImageView *gouImage;

@property (nonatomic, retain) NSMutableArray *companyCategory;

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
    CGSize size = [companyStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *companyL = [[UILabel alloc]initWithFrame:CGRectMake(0, frame.size.height-2-size.height-2, size.width, size.height)];
    companyL.textAlignment = NSTextAlignmentRight;
    companyL.numberOfLines = 0;
    companyL.text = companyStr;
    companyL.backgroundColor = [UIColor clearColor];
    companyL.font = [UIFont systemFontOfSize:12];
    companyL.textColor = [UIColor whiteColor];
    
    companyName = [[UILabel alloc]initWithFrame:CGRectMake(2+size.width, companyL.origin.y, frame.size.width-2-size.width, size.height)];
    companyName.backgroundColor = [UIColor clearColor];
    companyName.textColor = [UIColor whiteColor];
    companyName.font = [UIFont systemFontOfSize:15.0f];
    companyName.textAlignment = NSTextAlignmentCenter;
    companyName.adjustsFontSizeToFitWidth = YES;
    
    UIImageView * seperatorV = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height-2, frame.size.width, 1)];
    seperatorV.backgroundColor = [UIColor blackColor];
    
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(LeftRightPadding, 0, frame.size.width-2*LeftRightPadding, companyName.origin.y-10) style:UITableViewStylePlain];
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] init];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    
    _gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gou"]];
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

- (void)loadCompanyData:(id)respData
{
    NSDictionary *dict = (NSDictionary *)respData;
    
    NSArray<CompanyModel*> *tempArr = [CompanyModel objectArrayWithKeyValuesArray:dict[@"node_list"]];
    
    if (tempArr && tempArr.count) {
        [self.companyCategory addObjectsFromArray:tempArr];
        [_mainTableView reloadData];
    }
}

#pragma mark UITableViewDelegate, UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.companyCategory.count;
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
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-2*LeftRightPadding, 44-4)];
        nameLabel.layer.cornerRadius = 5.f;
        nameLabel.layer.masksToBounds = YES;
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor grayColor];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.font = [UIFont systemFontOfSize:15.0f];
        nameLabel.adjustsFontSizeToFitWidth = YES;
        
        nameLabel.tag = 1000;
        
        [cell addSubview:nameLabel];
    }
    
    CompanyModel *companyModel = self.companyCategory[indexPath.row];
    UILabel *lb = [cell viewWithTag:1000];
    lb.text = companyModel.node_name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex!=-1) {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:lastIndexPath];
         UILabel *lb = [cell viewWithTag:1000];
        lb.backgroundColor = [UIColor grayColor];
        lb.textColor = [UIColor blackColor];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lb = [cell viewWithTag:1000];
    lb.backgroundColor = [UIColor redColor];
    lb.textColor = [UIColor whiteColor];
    selectedIndex = (int)indexPath.row;
    
    CompanyModel *model = self.companyCategory[indexPath.row];
//    [companyB setTitle:model.node_name forState:UIControlStateNormal];
    companyName.text = model.node_name;
    _companyId = model.ID;
    _emailSuffix = model.node_email_suffix;
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


@end
