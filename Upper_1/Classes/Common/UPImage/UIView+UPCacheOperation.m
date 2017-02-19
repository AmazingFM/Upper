//
//  UIView+UPCacheOperation.m
//  Upper
//
//  Created by 张永明 on 2017/2/15.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UIView+UPCacheOperation.h"
#import "objc/runtime.h"

static char loadOperationKey;

@implementation UIView (UPCacheOperation)

- (NSMutableDictionary *)operationDictionary
{
    NSMutableDictionary *operations = objc_getAssociatedObject(self, &loadOperationKey);
    if (operations) {
        return operations;
    }
    
    operations = [NSMutableDictionary new];
    objc_setAssociatedObject(self, &loadOperationKey, operations, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return operations;
}

- (void)up_setImageLoadOperation:(id)operation forKey:(NSString *)key
{
    [self up_cancelImageLoadOperationWithKey:key];
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary setObject:operation forKey:key];
}

- (void)up_cancelImageLoadOperationWithKey:(NSString *)key
{
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    id operations = [operationDictionary objectForKey:key];
    if (operations) {
        if ([operations isKindOfClass:[NSArray class]]) {
            for (id<UPWebImageOperation> operation in operations) {
                if (operation) {
                    [operation cancel];
                }
            }
        } else if ([operations conformsToProtocol:@protocol(UPWebImageOperation)]) {
            [(id<UPWebImageOperation>)operations cancel];
        }
        [operationDictionary removeObjectForKey:key];
    }
}

- (void)up_removeImageLoadOperationWithKey:(NSString *)key
{
    NSMutableDictionary *operationDictionary = [self operationDictionary];
    [operationDictionary removeObjectForKey:key];
}

@end
