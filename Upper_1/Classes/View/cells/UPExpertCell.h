//
//  UPExpertCell.h
//  Upper
//
//  Created by 张永明 on 16/4/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPExpertItem.h"
@interface UPExpertCell : UITableViewCell

@property (nonatomic, retain) UPExpertItem *expertItem;

- (void)setItems:(UPExpertItem *)expertItem;
@end
