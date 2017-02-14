//
//  UPWebImageDownloader.h
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPWebImageOperation.h"

typedef NS_ENUM(NSInteger, UPWebImageDownloaderExecutionOrder){
    UPWebImageDownloaderFIFOExecutionOrder,
    
    UPWebImageDownloaderLIFOExecutionOrder
};

@interface UPWebImageDownloader : NSObject

@property (nonatomic, assign) NSInteger maxConcurrentDownloads;

@property (nonatomic, readonly) NSInteger currentDownloadsCount;

@property (nonatomic, assign) NSTimeInterval downloadTimeout;

@property (nonatomic, assign) UPWebImageDownloaderExecutionOrder executionOrder;

+ (UPWebImageDownloader *)sharedDownloader;

- (void)setOperationClass:(Class)operationClass;

- (id <UPWebImageOperation>)downloadImageWithUserId:(NSString *)userId
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageDownloaderCompletedBlock)completedBlock;

@end
