//
//  UPMessageCell.h
//  Upper
//
//  Created by 张永明 on 16/11/13.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface UPMessageCell : UITableViewCell

@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *contentLabel;
@property (nonatomic, retain) UILabel *badgeLabel;

@property (nonatomic, copy) void (^deleteObj)(UITableViewCell *cell);

- (void)deleteObject:(id)sender;

@end
