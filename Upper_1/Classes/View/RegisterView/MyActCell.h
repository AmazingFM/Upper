//
//  MyActCell.h
//  Upper_1
//
//  Created by aries365.com on 16/1/30.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyActCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *next;

@end
