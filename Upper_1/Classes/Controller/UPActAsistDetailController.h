//
//  UPActAsistDetailController.h
//  Upper
//
//  Created by 张永明 on 16/11/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPBaseViewController.h"
#import "UPCells.h"

typedef NS_ENUM(NSInteger, UPActType)
{
    UPActTypeJuhui,
    UPActTypeXinqu,
    UPActTypeZhuanye
};

//@interface UPActHelpItem : NSObject
//
//@property (nonatomic, copy) NSString *name;
//@property (nonatomic, copy) NSString *desc;
//@property (nonatomic, copy) NSString *place;
//@property (nonatomic, copy) NSString *tips;
//
//- (CGFloat)size;
//
//@end
//
//@interface UPActHelpCell : UITableViewCell
//
//- (void)setItem:(UPActHelpItem *)item;
//@end

@interface UPActAsistDetailController : UPBaseViewController

@property (nonatomic) UPActType type;
@property (nonatomic, retain) UITableView *mainTable;
@property (nonatomic, retain) NSMutableArray<UPInfoCellItem *> *itemArray;

- (instancetype)initWithType:(UPActType)type;

@end
