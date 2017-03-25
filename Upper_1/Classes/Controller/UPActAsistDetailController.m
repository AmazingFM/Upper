//
//  UPActAsistDetailController.m
//  Upper
//
//  Created by 张永明 on 16/11/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActAsistDetailController.h"

//#define kLinePadding 10
//
//@implementation UPActHelpItem
//
//- (CGFloat)size{
//    
//    CGSize titleSize = [UPTools sizeOfString:self.name withWidth:120 font:[UIFont systemFontOfSize:20.f]];
//    
//    float titleH = self.name.length==0?0:titleSize.height;
//
//    
//    float width = ScreenWidth-2*kUPHBorder;
//    
//    CGSize descSize = [UPTools sizeOfString:self.desc withWidth:width font:[UIFont systemFontOfSize:16.f]];
//    CGSize prefixSize = [UPTools sizeOfString:@"推荐场所：" withWidth:width font:[UIFont systemFontOfSize:16.f]];
//    
//    CGSize placeSize = [UPTools sizeOfString:self.place withWidth:width-prefixSize.width-15 font:[UIFont systemFontOfSize:16.f]];
//    CGSize tipsSize = [UPTools sizeOfString:self.tips withWidth:width-prefixSize.width-15 font:[UIFont systemFontOfSize:16.f]];
//    
//    return titleH+kLinePadding+descSize.height+kLinePadding+placeSize.height+kLinePadding+tipsSize.height+20;
//}
//
//@end

//@interface UPActHelpCell()
//{
//    UILabel *titleLabel;
//    UILabel *descLabel;
//    
//    UILabel *placeLabel;
//    UILabel *tipsLabel;
//    
//    UPActHelpItem *_item;
//}
//
//
//@end
//
//@implementation UPActHelpCell
//
//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        UILabel *line =[UILabel new];
//        line.tag = 99;
//        line.backgroundColor = [UIColor lightGrayColor];
//        
//        titleLabel = [UILabel new];
//        titleLabel.backgroundColor = [UIColor whiteColor];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.font = [UIFont systemFontOfSize:20.f];
//        
//        
//        [self addSubview:line];
//        [self addSubview:titleLabel];
//        
//        descLabel = [UILabel new];
//        descLabel.backgroundColor = [UIColor whiteColor];
//        descLabel.textAlignment = NSTextAlignmentLeft;
//        descLabel.font = [UIFont systemFontOfSize:16.f];
//        descLabel.numberOfLines = 0;
//        [self addSubview:descLabel];
//        
//        placeLabel = [UILabel new];
//        placeLabel.backgroundColor = [UIColor whiteColor];
//        placeLabel.textAlignment = NSTextAlignmentLeft;
//        placeLabel.font = [UIFont systemFontOfSize:16.f];
//        placeLabel.numberOfLines = 0;
//        [self addSubview:placeLabel];
//
//        tipsLabel = [UILabel new];
//        tipsLabel.backgroundColor = [UIColor whiteColor];
//        tipsLabel.textAlignment = NSTextAlignmentLeft;
//        tipsLabel.font = [UIFont systemFontOfSize:16.f];
//        tipsLabel.numberOfLines = 0;
//        [self addSubview:tipsLabel];
//        
//        UILabel *preTipsLabel = [UILabel new];
//        preTipsLabel.backgroundColor = [UIColor whiteColor];
//        preTipsLabel.textAlignment = NSTextAlignmentLeft;
//        preTipsLabel.font = [UIFont systemFontOfSize:16.f];
//        preTipsLabel.tag = 101;
//        preTipsLabel.text = @"小贴士：";
//        preTipsLabel.textColor = [UIColor blueColor];
//        [self addSubview:preTipsLabel];
//        
//        UILabel *prePlaceLabel = [UILabel new];
//        prePlaceLabel.backgroundColor = [UIColor whiteColor];
//        prePlaceLabel.textAlignment = NSTextAlignmentLeft;
//        prePlaceLabel.font = [UIFont systemFontOfSize:16.f];
//        prePlaceLabel.text = @"推荐场所：";
//        prePlaceLabel.tag = 100;
//        prePlaceLabel.textColor = [UIColor blueColor];
//        [self addSubview:prePlaceLabel];
//    }
//    
//    return self;
//}
//
//- (void)setItem:(UPActHelpItem *)item
//{
//    _item = item;
//    
//    CGSize titleSize = [UPTools sizeOfString:item.name withWidth:100 font:[UIFont systemFontOfSize:20.f]];
//    
//    float titleH = item.name.length==0?0:titleSize.height;
//    
//    float width = ScreenWidth-2*kUPHBorder;
//    
//    CGSize descSize = [UPTools sizeOfString:item.desc withWidth:width font:[UIFont systemFontOfSize:16.f]];
//    CGSize prefixSize = [UPTools sizeOfString:@"推荐场所：" withWidth:width font:[UIFont systemFontOfSize:16.f]];
//    
//    CGSize placeSize = [UPTools sizeOfString:item.place withWidth:width-prefixSize.width-15 font:[UIFont systemFontOfSize:16.f]];
//    CGSize tipsSize = [UPTools sizeOfString:item.tips withWidth:width-prefixSize.width-15 font:[UIFont systemFontOfSize:16.f]];
//    
//    float offsety = 0.f;
//    if (titleH==0){
//        UIView *line = [self viewWithTag:99];//line
//        line.hidden = YES;
//        
//        titleLabel.hidden = YES;
//    } else {
//        UIView *line = [self viewWithTag:99];//line
//        line.frame = CGRectMake(kUPHBorder, titleH/2, width, 0.6);
//        titleLabel.frame =CGRectMake(0, 0, 100, titleH);
//        titleLabel.text = item.name;
//        titleLabel.centerX = ScreenWidth/2;
//        offsety += titleH;
//    }
//    
//    offsety += kLinePadding;
//    descLabel.frame = CGRectMake(kUPHBorder, offsety, width, descSize.height);
//    descLabel.text = item.desc;
//    offsety += descLabel.height+kLinePadding;
//    
//    UILabel *prePlaceLb = [self viewWithTag:100];
//    prePlaceLb.frame = CGRectMake(kUPHBorder, offsety, prefixSize.width, prefixSize.height);
//    
//    placeLabel.frame = CGRectMake(kUPHBorder+prefixSize.width+5.f, offsety, placeSize.width, placeSize.height);
//    placeLabel.text = item.place;
//    offsety += placeSize.height+kLinePadding;
//    
//    UILabel *pretipsLab = [self viewWithTag:101];
//    pretipsLab.frame = CGRectMake(kUPHBorder, offsety, prefixSize.width, prefixSize.height);
//    
//    tipsLabel.frame = CGRectMake(kUPHBorder+prefixSize.width+5.f, offsety, tipsSize.width, tipsSize.height);
//    tipsLabel.text = item.tips;
//}
//
//@end

@interface UPActAsistDetailController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation UPActAsistDetailController

- (NSMutableArray<UPInfoCellItem *> *)itemArray
{
    if (_itemArray==nil) {
        _itemArray = [NSMutableArray new];
    }
    return _itemArray;
}

- (instancetype)initWithType:(UPActType)type
{
    self = [super init];
    if (self) {
        NSMutableArray *itemsArr = [[NSMutableArray alloc] initWithCapacity:3];
        
        NSDictionary *actDict = [UPTools loadBundleFile:@"introduce.json"];
        
        for (NSString *key in @[@"jhsj", @"xqsj", @"zysj"]) {
            NSArray *tmpArr = actDict[key];
            NSMutableArray *infoItemArr = [NSMutableArray new];
            for (NSDictionary *dict in tmpArr) {
                UPInfoCellItem *item = [UPInfoCellItem new];
                item.title = dict[@"name"];
                item.detail = dict[@"desc"];
                
                NSString *place = [NSString stringWithFormat:@"推荐场所：%@", dict[@"place"]];
                NSString *tips = [NSString stringWithFormat:@"小贴士：%@",dict[@"tips"]];
                item.tips = [NSString stringWithFormat:@"%@\n%@", tips, place];
                
                item.cellWidth = ScreenWidth;
                CGFloat offsety = 30;
                CGFloat hMargin = 10;
                CGFloat vMargin = 5;
                
                CGSize size = [UPTools sizeOfString:item.detail withWidth:ScreenWidth-2*hMargin font:[UIFont systemFontOfSize:13]];
                offsety += vMargin+size.height; //detail
                
                size = [UPTools sizeOfString:item.tips withWidth:item.cellWidth-2*hMargin-2*5 font:kUPThemeMinFont];
                offsety += 3*vMargin+size.height;
                
                item.cellHeight = (int)offsety+5;//取整解决分割线问题
                
                [infoItemArr addObject:item];
            }
            [itemsArr addObject:infoItemArr];
        }
        
        NSArray *titles = @[@"聚会社交", @"兴趣社交", @"专业社交"];
        self.navigationItem.title = titles[type];
        [self.itemArray addObjectsFromArray:itemsArr[type]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, FirstLabelHeight, ScreenWidth, ScreenHeight-FirstLabelHeight) style:UITableViewStyleGrouped];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.bounces = YES;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = RGBCOLOR(245, 245, 245);
    [_mainTable registerClass:[UPInfoCell class] forCellReuseIdentifier:@"cellId"];
    [self.view addSubview:_mainTable];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15.f)];
    view.backgroundColor = RGBCOLOR(245, 245, 245);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPInfoCellItem *item = self.itemArray[indexPath.section];
    return item.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
//    return self.itemArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPInfoCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    UPInfoCellItem *infoItem = self.itemArray[indexPath.section];
    cell.item = infoItem;
    return cell;
}

@end
