//
//  UPWebImageDownloader.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UPWebImageDownloader.h"

static NSString *const kProgressCallbackKey = @"progress";
static NSString *const kCompletedCallbackKey = @"completed";

@interface UPWebImageDownloader()

@property (nonatomic, retain) NSOperationQueue *downloadQueue;
@property (nonatomic, weak) NSOperation *lastAddedOperation;
@property (nonatomic, assign) Class operationClass;

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
        _operationClass = 
    }
}

@end
