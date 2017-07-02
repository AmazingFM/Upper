//
//  PrivateMsgCell.h
//  Upper
//
//  Created by 张永明 on 2017/2/26.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMessageBubbleMe        @"kMessageBubbleMe"
#define kMessageBubbleOthers    @"kMessageBubbleOthers"

@interface PrivateMsgCell : UITableViewCell

@property (nonatomic, retain) UIImageView *portrait;

- (void)setContent:(NSString *)content andPortrait:(NSString *)portraitURL;

@end
