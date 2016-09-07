//
//  CustomField.m
//  Upper_1
//
//  Created by aries365.com on 15/12/20.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "CustomField.h"

@implementation CustomField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 1)];
        [self addSubview:line];
    }
    return self;
    
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
//    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame)-0.5, CGRectGetWidth(self.frame), 0.5));
//}
//
@end
