//
//  CustomField.m
//  Upper_1
//
//  Created by aries365.com on 15/12/20.
//  Copyright © 2015年 aries365.com. All rights reserved.
//

#import "UPCustomField.h"

@implementation UPCustomField
@end

@implementation UPUnderLineField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.6, frame.size.width, 0.6)];
        [self addSubview:line];
    }
    return self;
}

@end
