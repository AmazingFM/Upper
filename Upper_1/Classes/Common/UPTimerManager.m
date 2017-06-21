//
//  UPTimerManager.m
//  Me
//
//  Created by 张永明 on 16/5/20.
//  Copyright © 2016年 Upper. All rights reserved.
//

#import "UPTimerManager.h"
#import "UPTools.h"
#import "Info.h"

@interface UPTimeMachine()
{
    NSTimer *_timer;
}
@end

@implementation UPTimeMachine

- (void)start
{
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:self.heartTime target:self selector:@selector(run) userInfo:nil repeats:YES];
    }
}

- (void)stop
{
    if (_timer!=nil) {
        [_timer invalidate];
        _timer=nil;
    }
}

-(void)run
{
    if (!self.skipOnce) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notice object:self.name];
    }
    self.skipOnce=NO;
}

@end

@implementation UPTimerManager

+(instancetype)shared
{
    static UPTimerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UPTimerManager alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.autoRefreshRate = kMessageRequireTimeInterval;
        NSString *autoRefreshTime = (NSString *)[UPTools loadKey:kTK_LOCAL_AUTO_REFRESH];
        if (autoRefreshTime==nil||autoRefreshTime.length==0) {
            [UPTools saveKey:kTK_LOCAL_AUTO_REFRESH value:[NSString stringWithFormat:@"%.0f", self.autoRefreshRate]];
        }
        else {
            self.autoRefreshRate = [autoRefreshTime floatValue];
        }
    }
    return self;
}

- (NSMutableArray *)timeMachines
{
    if (_timeMachines==nil) {
        _timeMachines=[[NSMutableArray alloc] init];
    }
    return _timeMachines;
}

- (void)createDefaultTimeMachines
{
    if (self.autoRefreshRate>0) {
        UPTimeMachine *timeMachine = [UPTimerManager createTimer:kUPMessageTimeMachineName notice:kNotifierMessagePull heartTime:self.autoRefreshRate];
        [timeMachine start];
    }
}
- (void)updateTimeMachines
{
    if(self.newRefreshRate!=self.autoRefreshRate){
        self.autoRefreshRate=self.newRefreshRate;
        [UPTools saveKey:kTK_LOCAL_AUTO_REFRESH value:[NSString stringWithFormat:@"%.0f",[UPTimerManager shared].autoRefreshRate]];
        [self removeAll];
        [self createDefaultTimeMachines];
    }
}

+ (UPTimeMachine *)createTimer:(NSString *)name notice:(NSString *)noticeName heartTime:(CGFloat)perRunTime
{
    UPTimeMachine *timeMachine = [[UPTimeMachine alloc] init];
    timeMachine.notice = noticeName;
    timeMachine.name = name;
    timeMachine.heartTime = perRunTime;
    [[UPTimerManager shared].timeMachines addObject:timeMachine];
    return timeMachine;
}

- (void)startTimeMachine:(NSString *)name
{
    for (UPTimeMachine* timeMachine in self.timeMachines) {
        if([timeMachine.name isEqualToString:name]){
            [timeMachine start];
        }
    }
}

- (void)stopTimeMachine:(NSString *)name
{
    for (UPTimeMachine* timeMachine in self.timeMachines) {
        if([timeMachine.name isEqualToString:name]){
            [timeMachine stop];
            [self.timeMachines removeObject:timeMachine];
            break;
        }
    }
}

- (void)skipTimerWithName:(NSString *)timerName
{
    for (UPTimeMachine* timeMachine in self.timeMachines) {
        if([timeMachine.name isEqualToString:timerName]){
            timeMachine.skipOnce=YES;
        }
    }

}

- (void)startAll
{
    for (UPTimeMachine* timeMachine in self.timeMachines) {
        [timeMachine start];
    }
}

-(void)stopAll{
    for (UPTimeMachine* timeMachine in self.timeMachines) {
        [timeMachine stop];
    }
}

-(void)removeAll{
    for (UPTimeMachine* timeMachine in self.timeMachines) {
        [timeMachine stop];
    }
    [self.timeMachines removeAllObjects];
}
@end
