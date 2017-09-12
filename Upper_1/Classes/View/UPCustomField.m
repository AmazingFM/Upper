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

@interface UPUnderLineField()
@property (nonatomic, strong) UIView *line;
@end

@implementation UPUnderLineField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.6, frame.size.width, 0.6)];
        self.line.backgroundColor = [UIColor grayColor];
        [self addSubview:self.line];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.line.frame = CGRectMake(0, frame.size.height-0.6, frame.size.width, 0.6);
}

@end
