//
//  ZouMaDengView.h
//  Upper
//
//  Created by freshment on 16/6/29.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeBoard : UIView

@property (nonatomic, retain) NSMutableArray *noticeList;
@property (nonatomic) NSTimeInterval timeInterval;
-(void)setNoticeMessage:(NSArray *)noticeList;
- (void)startAnimate;
-(void)stopAnimate;

@end