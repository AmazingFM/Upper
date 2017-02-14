//
//  UPWebImageDownloaderOperation.h
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPWebImageOperation.h"
#import "UPWebImageDownloader.h"


@interface UPWebImageDownloaderOperation : NSOperation <UPWebImageOperation>

@property (nonatomic, retain, readonly) NSURLRequest *request;
@property (nonatomic, assign) NSInteger expectedSize;
@property (nonatomic, retain) NSURLResponse *response;

- (id)initWithRequest:(NSURLRequest *)request
              options:(SDWebImageDownloaderOptions)options
             progress:(SDWebImageDownloaderProgressBlock)progressBlock
            completed:(SDWebImageDownloaderCompletedBlock)completedBlock
            cancelled:(SDWebImageNoParamsBlock)cancelBlock;

@end
