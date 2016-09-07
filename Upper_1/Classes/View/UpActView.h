//
//  UpActView.h
//  Upper_1
//
//  Created by aries365.com on 15/11/12.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpActView : UIView
{
}

@property (nonatomic, retain) id parentController;

@property (nonatomic, retain) NSString *actId;
@property (nonatomic, retain) NSString *actTitle;
@property (nonatomic, retain) NSString *actContent;
@property (nonatomic, retain) NSString *actBeginTime;
@property (nonatomic, retain) NSString *actEndTime;
@property (nonatomic, retain) NSString *actLocation;
@property (nonatomic, retain) UIImage *pic;

@end
