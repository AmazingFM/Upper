//
//  UPActivityCellItem.h
//  Upper
//
//  Created by 海通证券 on 16/5/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCellItems.h"

#import "UpActDetailController.h"

@class ActivityData;
@interface UPActivityCellItem : UPBaseCellItem

@property (nonatomic) SourceType type;
@property (nonatomic, retain) ActivityData *itemData;

@end
