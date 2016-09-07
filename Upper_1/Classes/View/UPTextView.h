//
//  UPTextView.h
//  Upper
//
//  Created by 张永明 on 16/7/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, retain) NSAttributedString *attributedPlaceholder;

- (CGRect)placeholderRectForBounds:(CGRect)bounds;

@end
