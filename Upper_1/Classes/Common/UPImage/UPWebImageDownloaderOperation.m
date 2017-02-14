//
//  UPWebImageDownloaderOperation.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPWebImageDownloaderOperation.h"
#import "UIImage+MultiFormat.h"
#import "UPWebImageManager.h"

@interface UPWebImageDownloaderOperation() <NSURLConnectionDataDelegate>

@property (copy, nonatomic) SDWebImageDownloaderProgressBlock progressBlock;
@property (copy, nonatomic) SDWebImageDownloaderCompletedBlock completedBlock;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;

@property (assign, nonatomic, getter=isExecuting) BOOL executing;
@property (assign, nonatomic, getter=isFinished) BOOL finished;

@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (atomic, retain) NSThread *thread;

@property (nonatomic, assign) UIBackgroundTaskIdentifier backgroundTaskId;

@end

@implementation UPWebImageDownloaderOperation
{
    size_t width, height;
    UIImageOrientation orientation;
    BOOL responseFromCached;
}
@synthesize executing = _executing;
@synthesize finished = _finished;

- (void)cancle
{
    @synchronized (self) {
        if (self.thread) {
            [self performSelector:@selector(cancelInternalAndStop) onThread:self.thread withObject:nil waitUntilDone:NO];
        } else {
            [self cancelInternal];
        }
    }
}

- (void)cancelInternalAndStop
{
    if (self.isFinished) return;
    
    [self cancelInternal];
    CFRunLoopStop(CFRunLoopGetCurrent());
}

- (void)cancelInternal
{
    if (self.isFinished) return;
    [super cancel];
    
    if (self.cancelBlock) self.cancelBlock();
    
    if (self.connection) {
        [self.connection cancel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:SDWebImageDownloadStopNotification object:self];
        });
        
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.cancelBlock = nil;
    self.completedBlock = nil;
    self.progressBlock = nil;
    self.connection = nil;
    self.imageData = nil;
    self.thread = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

@end
