//
//  YMImageLoadView.h
//  IBTry
//
//  Created by 张永明 on 16/8/23.
//  Copyright © 2016年 Upper. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YMImageLoadDelegate <NSObject>

- (void)imageDidSelected:(UIImageView *)image withPos:(NSInteger)index;

@end
@interface YMImageLoadView : UIView

@property (nonatomic) int number;
@property (nonatomic) int maxCount;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *imageDataList;
@property (nonatomic, weak) id<YMImageLoadDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withMaxCount:(int)nCount;
@end
