//
//  MyTableView.h
//  Upper
//
//  Created by 张永明 on 16/11/27.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableContents : NSObject

@property (nonatomic) int type;//0普通菜单， 1-二级菜单

@property (nonatomic, retain) NSMutableArray *firstArr;
@property (nonatomic, retain) NSMutableArray *secondArr;

@end

@interface MultiTables : UIView



@end
