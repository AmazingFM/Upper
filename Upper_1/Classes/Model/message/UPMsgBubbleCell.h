//
//  UPMsgBubbleCell.h
//  Upper
//
//  Created by 张永明 on 16/11/13.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UUMessage;

static NSString * const kMessageBubbleOthers = @"MessageBubbleOthers";
static NSString * const kMessageBubbleMe     = @"MessageBubbleMe";

@interface UPMsgBubbleCell : UITableViewCell

@property (nonatomic, retain) UIImageView *portrait;

- (void)setContent:(NSString *)content andPortrait:(NSURL *)portraitURL;

- (void)deleteObject:(id)sender;

@end
