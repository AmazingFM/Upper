//
//  UIAlertView+NSObject.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "UIAlertView+NSObject.h"
#import <objc/runtime.h>

@implementation UIAlertView (NSObject)
static char objAddressKey;

- (id)someObj
{
    return objc_getAssociatedObject(self, &objAddressKey);
}

- (void)setSomeObj:(id)someObj
{
    objc_setAssociatedObject(self, &objAddressKey, someObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
