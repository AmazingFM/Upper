//
//  UPWebImageDownloader.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPWebImageDownloader.h"
#import "AFURLRequestSerialization.h"
#import "UPWebImageDownloaderOperation.h"

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface UPWebImageDownloader()

@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, weak) NSOperation *lastAddedOperation;
@property (nonatomic, assign) Class operationClass;
@property (nonatomic, retain) NSMutableDictionary *URLCallbacks;

@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

@property (strong, nonatomic) dispatch_queue_t barrierQueue;

@end

@implementation UPWebImageDownloader

+ (UPWebImageDownloader *)sharedDownloader
{
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init
{
    if ((self= [super init])) {
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        _operationClass = [UPWebImageDownloaderOperation class];
        _executionOrder = UPWebImageDownloaderFIFOExecutionOrder;
        _downloadQueue = [NSOperationQueue new];
        _downloadQueue.maxConcurrentOperationCount = 6;
        _URLCallbacks = [NSMutableDictionary new];
        _barrierQueue = dispatch_queue_create("com.upper.UPUserIconImageDownloaderBarrierQueue", DISPATCH_QUEUE_CONCURRENT);
        _downloadTimeout = 15.0f;
    }
    return self;
}

- (void)dealloc
{
    [self.downloadQueue cancelAllOperations];
    SDDispatchQueueRelease(_barrierQueue);
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrentDownloads {
    _downloadQueue.maxConcurrentOperationCount = maxConcurrentDownloads;
}

- (NSUInteger)currentDownloadCount {
    return _downloadQueue.operationCount;
}

- (NSInteger)maxConcurrentDownloads {
    return _downloadQueue.maxConcurrentOperationCount;
}

- (void)setOperationClass:(Class)operationClass {
    _operationClass = operationClass ?: [UPWebImageDownloaderOperation class];
}


- (void)setRequestSerializer:(AFHTTPRequestSerializer <AFURLRequestSerialization> *)requestSerializer {
    NSParameterAssert(requestSerializer);
    
    _requestSerializer = requestSerializer;
}

- (id<UPWebImageOperation>)downloadImageWithUserId:(NSString *)userId progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageDownloaderCompletedBlock)completedBlock
{
    __block UPWebImageDownloaderOperation *operation;
    __weak __typeof(self) wself = self;
    
    [self addProgressCallback:progressBlock completedBlock:completedBlock forUserId:userId createCallback:^{
        NSTimeInterval timeoutInterval = wself.downloadTimeout;
        if (timeoutInterval==0.0) {
            timeoutInterval = 15.f;
        }
        
        NSMutableDictionary *parameters = [NSMutableDictionary new];
        
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [wself.requestSerializer requestWithMethod:@"GET" URLString:@"http://api.qidianzhan.com.cn/AppServ/index.php" parameters:parameters error:&serializationError];
        
        operation = [[wself.operationClass alloc] initWithRequest:request options:SDWebImageDownloaderLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            UPWebImageDownloader *sself = wself;
            if (!sself) {
                return;
            }
            
            __block NSArray *callbacksForURL;
            dispatch_sync(sself.barrierQueue, ^{
                callbacksForURL = [sself.URLCallbacks[userId] copy];
            });
            for (NSDictionary *callbacks in callbacksForURL) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    SDWebImageDownloaderProgressBlock callback = callbacks[kProgressCallbackKey];
                    if (callback) callback(receivedSize, expectedSize);
                });
            }
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            UPWebImageDownloader *sself = wself;
            if (!sself) {
                return;
            }
            
            __block NSArray *callbacksForURL;
            dispatch_barrier_sync(sself.barrierQueue, ^{
                callbacksForURL = [sself.URLCallbacks[userId] copy];
                if (finished) {
                    [sself.URLCallbacks removeObjectForKey:userId];
                }
            });
            
            for (NSDictionary *callbacks in callbacksForURL) {
                SDWebImageDownloaderCompletedBlock callback = callbacks[kCompletedCallbackKey];
                if (callback) {
                    callback(image, data, error, finished);
                }
            }
        } cancelled:^{
            UPWebImageDownloader *sself = wself;
            if (!sself) {
                return;
            }
            dispatch_barrier_async(sself.barrierQueue, ^{
                [sself.URLCallbacks removeObjectForKey:userId];
            });
        }];
        
        operation.queuePriority = NSOperationQueuePriorityNormal;
        
        [wself.downloadQueue addOperation:operation];
        if (wself.executionOrder == UPWebImageDownloaderFIFOExecutionOrder) {
            [wself.lastAddedOperation addDependency:operation];
            wself.lastAddedOperation = operation;
        }
    }];
    
    return operation;
}

- (void)addProgressCallback:(SDWebImageDownloaderProgressBlock)progressBlock completedBlock:(SDWebImageDownloaderCompletedBlock)completedBlock forUserId:(NSString *)userID createCallback:(SDWebImageNoParamsBlock)createCallback {
    if (userID==nil) {
        if (completedBlock!=nil) {
            completedBlock(nil, nil, nil, NO);
        }
        return;
    }
    
    dispatch_barrier_sync(self.barrierQueue, ^{
        BOOL first = NO;
        if (!self.URLCallbacks[userID]) {
            self.URLCallbacks[userID] = [NSMutableArray new];
            first = YES;
        }
        
        NSMutableArray *callbacksForURL = self.URLCallbacks[userID];
        NSMutableDictionary *callbacks = [NSMutableDictionary new];
        if (progressBlock) {
            callbacks[kProgressCallbackKey] = [progressBlock copy];
        }
        if (completedBlock) {
            callbacks[kCompletedCallbackKey] = [completedBlock copy];
        }
        
        [callbacksForURL addObject:callbacks];
        self.URLCallbacks[userID] = callbacksForURL;
        
        if (first) {
            createCallback();
        }
    });
}

- (void)setSuspended:(BOOL)suspended
{
    [self.downloadQueue setSuspended:suspended];
}

@end
