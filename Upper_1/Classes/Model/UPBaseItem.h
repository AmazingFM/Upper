//
//  UPBaseItem.h
//  Upper
//
//  Created by freshment on 16/6/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPBaseItem : NSObject

@end

@interface PageItem : NSObject
@property (nonatomic) int current_page;
@property (nonatomic) int page_size;
@property (nonatomic) int total_num;
@property (nonatomic) int total_page;
@end

