//
//  UPActAsistDetailController.m
//  Upper
//
//  Created by 张永明 on 16/11/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActAsistDetailController.h"

#import "UPTools.h"
#import "UPGlobals.h"

@implementation UPActHelpItem

- (CGFloat)size{
    float titleH = self.name.length==0?0:40.f;
    
    float width = ScreenWidth-2*kUPHBorder;
    
    CGSize descSize = [UPTools sizeOfString:self.desc withWidth:width font:[UIFont systemFontOfSize:20.f]];
    CGSize prefixSize = [UPTools sizeOfString:@"推荐场所" withWidth:width font:[UIFont systemFontOfSize:16.f]];
    
    CGSize placeSize = [UPTools sizeOfString:self.place withWidth:width-prefixSize.width-15 font:[UIFont systemFontOfSize:16.f]];
    CGSize tipsSize = [UPTools sizeOfString:self.place withWidth:width-prefixSize.width-15 font:[UIFont systemFontOfSize:16.f]];
    
    return titleH+5+descSize.height+5+placeSize.height+5+tipsSize.height;
}

@end

@interface UPActHelpCell()
{
    UILabel *titleLabel;
    UILabel *descLabel;
}


@end

@implementation UPActHelpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(kUPHBorder, 20.f, ScreenWidth-2*kUPHBorder, 0.6)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        titleLabel = [UILabel new];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:20.f];
        
        
        [self addSubview:line];
        [self addSubview:titleLabel];
        
        descLabel = [UILabel new];
        descLabel.backgroundColor = [UIColor whiteColor];
        descLabel.textAlignment = NSTextAlignmentCenter;
        descLabel.font = [UIFont systemFontOfSize:20.f];

        
    }
    
    return self;
}

- (void)setItem:(UPActHelpItem *)item
{
    
}

@end

@interface UPActAsistDetailController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation UPActAsistDetailController

- (NSMutableArray<UPActHelpItem *> *)itemArray
{
    if (_itemArray==nil) {
        _itemArray = [NSMutableArray new];
    }
    return _itemArray;
}

- (instancetype)initWithType:(UPActType)type andContents:(NSMutableArray *)contents
{
    self = [super init];
    if (self) {
        [self.itemArray addObjectsFromArray:contents];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _mainTable = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    _mainTable.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_mainTable];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UPActHelpItem *item = self.itemArray[indexPath.row];
    return item.size;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.
    }
}



@end
