//
//  MyLabel.m
//  新闻
//
//  Created by Think_lion on 15/5/11.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "XWNetworkLabel.h"

@implementation XWNetworkLabel

-(instancetype)init
{
    self=[super init];
    if(self){
        self.backgroundColor=[UIColor whiteColor];
        self.textAlignment=NSTextAlignmentCenter;
        self.textColor=[UIColor lightGrayColor];
       
    }
    return self;
}

-(void)setTextStr:(NSString *)textStr
{
    if(textStr.length){
        CGSize textSize=[textStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}];
        self.text=textStr;
        self.width=textSize.width;
        self.height=textSize.height;
    }
  
}

@end
