//
//  MyActCell.m
//  Upper_1
//
//  Created by aries365.com on 16/1/30.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "MyActCell.h"

@interface MyActCell()
{
    
}


@end

@implementation MyActCell

- (void)awakeFromNib {
    // Initialization code

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    self.leftView.frame = CGRectMake(0, 0, self.height, self.height);
    self.rightView.frame = CGRectMake(self.height, 0, self.width-self.height, self.height);
    self.rightView.backgroundColor = [UIColor yellowColor];
    
    self.timeLabel.frame = CGRectMake(5, 5, 80, 17);
    self.locationButton.frame = CGRectMake(0, 5, 120, 17);
    self.titleLabel.frame = CGRectMake(5, self.locationButton.y+self.locationButton.height, self.width-self.height, 20);
    self.line.frame = CGRectMake(0, self.titleLabel.y+self.titleLabel.height, self.width-self.height, 1);
//    self.contentLabel.x=5;
//    self.contentLabel.y=self.line.y+3;
//    self.contentLabel.width = self.rightView.width-10;
    self.contentLabel.frame =CGRectMake(5, self.line.y+1, self.rightView.width-5, 30);

    
    self.next.frame = CGRectMake(self.rightView.width-15, self.contentLabel.y+30, 15, 15);
    self.next.backgroundColor = [UIColor greenColor];
    
    NSLog(@"%f, %f",self.width, self.height);
}

@end
