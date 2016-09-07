//
//  ZouMaDengView.m
//  Upper
//
//  Created by freshment on 16/6/29.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "ZouMaDengView.h"

@interface NoticeBoard()
{
    NSTimer *_timer;
    int currentIdx;
    UIImageView *_imgV;
    UILabel *_labelOne;
    UILabel *_labelTwo;
}
@end
@implementation NoticeBoard

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor redColor];
        _timeInterval = 4.0f;
        
        _imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        _imgV.image = [UIImage imageNamed:@"notice"];
        _imgV.contentMode=UIViewContentModeScaleToFill;
        _imgV.backgroundColor = [UIColor clearColor];
        
        _labelOne = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelOne.textColor = [UIColor whiteColor];
        
        _labelTwo = [[UILabel alloc]initWithFrame:CGRectZero];
        _labelTwo.textColor = [UIColor whiteColor];
        [self addSubview:_labelOne];
        [self addSubview:_labelTwo];
        [self addSubview:_imgV];
    }
    return self;
}

- (void)reset
{
    _labelOne.frame = CGRectMake(self.frame.size.height+5,0,self.frame.size.width-self.frame.size.height-5,self.frame.size.height);
    _labelTwo.frame = CGRectMake(self.frame.size.height+5,self.frame.size.height,self.frame.size.width-self.frame.size.height-5,self.frame.size.height);
    currentIdx = 0;
}

-(NSMutableArray *)noticeList
{
    if (_noticeList==nil) {
        _noticeList = [[NSMutableArray alloc] init];
    }
    return _noticeList;
}

-(void)setNoticeMessage:(NSArray *)noticeList
{
    if (noticeList==nil ||[noticeList count]==0) {
        return;
    }
    currentIdx = 0;

    [self.noticeList addObjectsFromArray:noticeList];
    
    _labelOne.text = self.noticeList[0];

}

- (void)startAnimate
{
    if (_timer!=nil) {
        return;
    }
    [self reset];
     _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(showNotice) userInfo:nil repeats:YES];
    NSLog(@"NoticeBoard startAnimate");
}

- (void)stopAnimate
{
    [_timer invalidate];
    _timer=nil;
    NSLog(@"NoticeBoard stopAnimate");
}

- (void)showNotice
{
    int nextIdx = (currentIdx+1)%[self.noticeList count];
    
    CGRect f1 = _labelOne.frame;
    CGRect f2 = _labelTwo.frame;
    
    CGFloat tmp = f2.origin.y;
    f2.origin.y = f1.origin.y;
    f1.origin.y = tmp;
    
    if (tmp==0) {
        _labelTwo.frame = f2;

        [UIView animateWithDuration:0.5f animations:^{
            _labelOne.text = self.noticeList[nextIdx];
            _labelOne.frame = f1;
        }];
    } else {
        _labelOne.frame = f1;

        [UIView animateWithDuration:0.5f animations:^{
            _labelTwo.text = self.noticeList[nextIdx];
            _labelTwo.frame = f2;
        }];
    }
    currentIdx++;
}

- (void)dealloc
{
    [self stopAnimate];
}

@end