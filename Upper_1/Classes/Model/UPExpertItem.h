//
//  UPExpertItem.h
//  Upper
//
//  Created by 张永明 on 16/4/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UPExpertItem : NSObject

@property (nonatomic, copy) NSString *expertID;
@property (nonatomic, copy) NSString *expertTitle;
@property (nonatomic, copy) NSString *expertName;
@property (nonatomic, copy) NSString *expertDesc;
@property (nonatomic) int peopleCount;
@property (nonatomic, copy) NSString *expertImg;

- (void)fillInfoWithDict:(NSDictionary *)dict;
@end
