//
//  UPWebImageManager.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPWebImageManager.h"
#import <objc/runtime.h>

@interface UPWebImageCombineOperation : NSObject<UPWebImageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) SDWebImageNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *cacheOperation;

@end

@implementation UPWebImageCombineOperation

- (void)setCancelBlock:(SDWebImageNoParamsBlock)cancelBlock {
    // check if the operation is already cancelled, then we just call the cancelBlock
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // don't forget to nil the cancelBlock, otherwise we will get crashes
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
        
        // TODO: this is a temporary fix to #809.
        // Until we can figure the exact cause of the crash, going with the ivar instead of the setter
        //        self.cancelBlock = nil;
        _cancelBlock = nil;
    }
}

@end


@interface UPWebImageManager()

@property (strong, nonatomic, readonly) SDImageCache *imageCache;
@property (nonatomic, retain, readwrite) UPWebImageDownloader *imageDownloader;
@property (nonatomic, retain) NSMutableSet *failderUserIds;
@property (nonatomic, retain) NSMutableArray *runningOperations;

@end

@implementation UPWebImageManager

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init
{
    if ((self=[super init])) {
        _imageCache = [self createCache];
        _imageDownloader = [UPWebImageDownloader sharedDownloader];
        _failderUserIds = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (SDImageCache *)createCache
{
    return [SDImageCache sharedImageCache];
}

- (id<UPWebImageOperation>)downloadImageWithUserID:(NSString *)userId progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(UPWebImageCompletionWithFinishedBlock)completedBlock
{
    __block UPWebImageCombineOperation *operation = [UPWebImageCombineOperation new];
    __weak UPWebImageCombineOperation *weakOperation = operation;
    
    BOOL isFailedUserId = NO;
    @synchronized (self.failderUserIds) {
        isFailedUserId = [self.failderUserIds containsObject:userId];
    }
    
    if (isFailedUserId) {
        dispatch_main_sync_safe(^{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            completedBlock(nil, error, SDImageCacheTypeNone, YES, userId);
        });
        return operation;
    }
    
    @synchronized (self.runningOperations) {
        [self.runningOperations addObject:operation];
    }
    
    operation.cacheOperation = [self.imageCache queryDiskCacheForKey:userId done:^(UIImage *image, SDImageCacheType cacheType) {
        if (operation.isCancelled) {
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
            return;
        }
        
        id<UPWebImageOperation> subOperation = [self.imageDownloader downloadImageWithUserId:userId progress:progressBlock completed:^(UIImage *downloadedImage, NSData *data, NSError *error, BOOL finished) {
            if (weakOperation.isCancelled) {
                //
            } else if (error) {
                dispatch_main_sync_safe(^{
                    if (!weakOperation.isCancelled) {
                        completedBlock(nil, error, SDImageCacheTypeNone, finished, userId);
                    }
                });
            } else {
                dispatch_main_sync_safe(^{
                    if (!weakOperation.isCancelled) {
                        completedBlock(downloadedImage, nil, SDImageCacheTypeNone, finished, userId);
                    }
                });
            }
            
            if (finished) {
                @synchronized (self.runningOperations) {
                    [self.runningOperations removeObject:operation];
                }
            }
        }];
        
        operation.cancelBlock = ^{
            [subOperation cancel];
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:weakOperation];
            }
        };
    }];
    return operation;
}

- (void)cancelAll
{
    @synchronized (self.runningOperations) {
        NSArray *copiedOperations = [self.runningOperations copy];
        [copiedOperations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeObjectsInArray:copiedOperations];
    }
}

- (BOOL)isRunning
{
    BOOL isRunning = NO;
    @synchronized (self.runningOperations) {
        isRunning = (self.runningOperations.count>0);
    }
    return isRunning;
}
@end
