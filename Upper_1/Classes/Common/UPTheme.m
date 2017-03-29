//
//  UPTheme.m
//  Upper
//
//  Created by 张永明 on 16/4/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPTheme.h"


UIButton* createSubmitButton(CGFloat fontSize)
{
    
    UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectZero;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    button.titleLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    button.backgroundColor = [UIColor clearColor];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    return button;
}

@implementation UPTheme

+ (instancetype)shared
{
    static UPTheme *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UPTheme alloc] init];
        
    });
    
    return instance;
}

- (UIColor *)colorForTitle
{
    return [UIColor greenColor];
}

- (UIFont *)fontForCommon
{
    return [UIFont systemFontOfSize:15.0f];
}


+ (NSString *)getSpecialDate:(NSString *)date
{
    return [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

//用空格截取日期
+ (NSString *)getDate:(NSString*)curDateStr
{
    NSArray * timeArray = [curDateStr componentsSeparatedByString:@" "];
    
    if ([timeArray count] > 0)
    {
        return [timeArray objectAtIndex:0];
    }else
    {
        return curDateStr;
    }
    
}

//用空格截取时间
+ (NSString *)getTime:(NSString*)curDateStr
{
    NSArray * timeArray = [curDateStr componentsSeparatedByString:@" "];
    
    if ([timeArray count] > 0)
    {
        return [timeArray objectAtIndex:1];
    }else
    {
        return curDateStr;
    }
    
}

+ (NSString *)getDateStrByCurDate:(NSString *)recvDateStr curDateStr:(NSString *)curDateStr
{
    NSRange range;
    range = [recvDateStr rangeOfString:curDateStr];
    if(range.location != NSNotFound)
    {
        NSArray * timeArray = [recvDateStr componentsSeparatedByString:@" "];
        
        if ([timeArray count] > 0)
        {
            return [timeArray objectAtIndex:1];
        }else
        {
            return recvDateStr;
        }
        
    }
    else
    {
        return recvDateStr;
    }
}

+ (NSString *)getCurDate
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *formatter    =  [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *sdate = [formatter stringFromDate:curDate];
    return sdate;
    
}
@end
