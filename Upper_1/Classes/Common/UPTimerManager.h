//
//  UPTimerManager.h
//  Me
//
//  Created by 张永明 on 16/5/20.
//  Copyright © 2016年 Upper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kTK_LOCAL_AUTO_REFRESH          @"autorefresh"  //自动刷新时间

@interface UPTimeMachine : NSObject
@property (nonatomic, copy) NSString    *name;
@property (nonatomic, copy) NSString    *notice;
@property (nonatomic) CGFloat           heartTime;
@property (nonatomic) BOOL              skipOnce;

- (void)start;
- (void)stop;
@end

/**
 *  定时器管理和通知管理 定时发送通知
 */
@interface UPTimerManager : NSObject
@property (nonatomic, retain)NSMutableArray *timeMachines;
@property (nonatomic) NSTimeInterval autoRefreshRate;
@property (nonatomic) NSTimeInterval newRefreshRate;

+(instancetype)shared;
- (void)createDefaultTimeMachines;
- (void)updateTimeMachines;

/**
 *  创建定时器
 *
 *  @param name       特定定时器标题
 *  @param noticeName 通知名称
 *  @param perRunTime 运行间隔时长
 *
 *  @return return value description
 */
+ (UPTimeMachine *)createTimer:(NSString *)name notice:(NSString *)noticeName heartTime:(CGFloat)perRunTime;

/**
 *  启动
 *
 *  @param name <#name description#>
 */
- (void)startTimeMachine:(NSString *)name;
- (void)stopTimeMachine:(NSString *)name;

- (void)skipTimerWithName:(NSString *)timerName;

- (void)startAll;
- (void)stopAll;
- (void)removeAll;
@end
