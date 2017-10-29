//
//  UPRegisterView.h
//  Upper
//
//  Created by freshment on 16/5/26.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPRegisterView : UIView

@property (nonatomic, weak) id parentController;

-(NSString *)alertMsg;
-(void)clearValue;

@end
