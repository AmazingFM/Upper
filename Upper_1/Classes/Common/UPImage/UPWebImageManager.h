//
//  UPWebImageManager.h
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPWebImageOperation.h"
#import "UPWebImageDownloader.h"

typedef void (^UPWebImageCompletionBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, NSString *usrID);
typedef void (^UPWebImageCompletionWithFinishedBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSString *usrID);

@class UPWebImageManager;

@protocol UPWebImageManagerDelegate <NSObject>

@optional

- (BOOL)imageManager:(UPWebImageManager *)imageManager shouldDownloadImageForUserId:(NSString *)userId;

- (UIImage *)imageManager:(UPWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withUserId:(NSString *)userId;


@end

@interface UPWebImageManager : NSObject

@property (nonatomic, weak) id <UPWebImageManagerDelegate> delegate;

+(id)sharedManager;

- (id<UPWebImageOperation>)downloadImageWithUserID:(NSString *)userId progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(UPWebImageCompletionWithFinishedBlock)completedBlock;

- (void)cancelAll;
- (BOOL)isRunning;
@end
