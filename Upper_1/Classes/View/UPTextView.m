//
//  UPTextView.m
//  Upper
//
//  Created by 张永明 on 16/7/8.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPTextView.h"

@implementation UPTextView

@synthesize attributedPlaceholder = _attributedPlaceholder;

#pragma mark - reset property

- (void)setText:(NSString *)text {
    [super setText:text];
    [self setNeedsDisplay];
}

- (void)insertText:(NSString *)text {
    [super insertText:text];
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder {
    if ([placeholder isEqualToString:self.attributedPlaceholder.string]) {
        return;
    }
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    float osVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if(osVersion>6){
        if ([self isFirstResponder] && self.typingAttributes) {
            [attributes addEntriesFromDictionary:self.typingAttributes];
        } else {
            attributes[NSFontAttributeName] = self.font;
            attributes[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.7f alpha:1.0f];
            
            if (self.textAlignment != NSTextAlignmentLeft) {
                NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
                paragraph.alignment = self.textAlignment;
                attributes[NSParagraphStyleAttributeName] = paragraph;
            }
        }
    }
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:attributes];
}

- (NSString *)placeholder {
    return self.attributedPlaceholder.string;
}


- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    if ([_attributedPlaceholder isEqualToAttributedString:attributedPlaceholder]) {
        return;
    }
    _attributedPlaceholder = attributedPlaceholder;
    [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    [self setNeedsDisplay];
}


#pragma mark - init object

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]
        ) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textChanged:(NSNotification *)notify {
    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.attributedPlaceholder && self.text.length == 0) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.text.length == 0 && self.attributedPlaceholder) {
        CGRect placeholderRect = [self placeholderRectForBounds:self.bounds];
        [self.attributedPlaceholder drawInRect:placeholderRect];
    }
}


- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
    if ([self respondsToSelector:@selector(textContainer)]) {
        rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
        CGFloat padding = self.textContainer.lineFragmentPadding;
        rect.origin.x += padding;
        rect.size.width -= padding * 2.0f;
    } else {
        if (self.contentInset.left == 0) {
            rect.origin.x += 8.0f;
        }
        rect.origin.y += 8.0f;
        rect.size.width-=16.0f;
    }
    return rect;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}
@end
