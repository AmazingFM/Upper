//
//  UPActivityCell.h
//  Upper
//
//  Created by 海通证券 on 16/5/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPActivityCellItem.h"
#import "ActivityData.h"

@interface UPTimeLocationView : UIView
- (void)setTime:(NSString *)time andLocation:(NSString *)location;
@end


@interface UILabel (VerticalUpAlignment)
- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight;
@end

@protocol UPItemButtonDelegate <NSObject>

-(void)onButtonSelected:(UPActivityCellItem *)cellItem withType:(int)type;

@end

@interface HTActivityCell : UITableViewCell

@property (nonatomic, retain) UPActivityCellItem *actCellItem;
@property (nonatomic, retain) id<UPItemButtonDelegate> delegate;

- (void)setActivityItems:(UPBaseCellItem *)item;

@end

