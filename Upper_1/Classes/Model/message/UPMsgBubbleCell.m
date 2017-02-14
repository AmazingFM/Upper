//
//  UPMsgBubbleCell.m
//  Upper
//
//  Created by 张永明 on 16/11/13.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMsgBubbleCell.h"

@interface UPMsgBubbleCell()

@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, retain) UIImageView *bubble;
@property (nonatomic, retain) UITextView *messageView;
@property (nonatomic, strong) NSLayoutConstraint *bubbleWidthConstraint;

@end

@implementation UPMsgBubbleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (reuseIdentifier == kMessageBubbleMe) {
            _isMine = YES;
        } else {
            _isMine = NO;
        }
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:243.0/255 alpha:1.0];
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

- (void)initSubviews
{
    _portrait = [UIImageView new];
    _portrait.contentMode = UIViewContentModeScaleAspectFit;
    _portrait.layer.cornerRadius = 18;
    _portrait.layer.masksToBounds = YES;
    
    _portrait.userInteractionEnabled = YES;
    [self.contentView addSubview:_portrait];
    
    _messageView = [UITextView new];
    _messageView.editable = NO;
    _messageView.scrollEnabled = NO;
    _messageView.backgroundColor = [UIColor clearColor];
    _messageView.font = [UIFont systemFontOfSize:15.f];
    _messageView.selectable = NO;
    _messageView.dataDetectorTypes = UIDataDetectorTypePhoneNumber | UIDataDetectorTypeLink;
    
    UIImage *bubbleImage = nil;
    if (_isMine) {
        bubbleImage = [UIImage imageNamed:@"chatto_bg_normal"];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    } else {
        bubbleImage = [UIImage imageNamed:@"chatfrom_bg_normal"];
        bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    _bubble = [UIImageView new];
    _bubble.image = bubbleImage;
    _bubble.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubble];
    [_bubble addSubview:_messageView];
}

- (void)setLayout
{
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    _messageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_portrait, _bubble, _messageView);
    
    NSLayoutFormatOptions option = _isMine? NSLayoutFormatDirectionRightToLeft : 0;
    NSDictionary *metrics = @{@"leading": @(15), @"tailing": @(10)};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_portrait(36)]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[_bubble]-8-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_portrait(36)]-8-[_bubble]->=52-|"
                                                                             options:NSLayoutFormatAlignAllTop | option
                                                                             metrics:nil views:views]];
    
    [_bubble addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_messageView]|" options:0 metrics:nil views:views]];
    [_bubble addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-leading-[_messageView]-tailing-|" options:option metrics:metrics views:views]];
    
    
    _bubbleWidthConstraint = [NSLayoutConstraint constraintWithItem:_bubble attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                             toItem:nil     attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:25];
    
    [self.contentView addConstraint:_bubbleWidthConstraint];
}

- (void)setContent:(NSString *)content andPortrait:(NSURL *)portraitURL
{
    _messageView.text = content;
//    [_portrait sd_setImageWithURL:portraitURL placeholderImage:[UIImage imageNamed:@"head"]];
    CGFloat bubbleWidth = [_messageView sizeThatFits:CGSizeMake(self.contentView.frame.size.width-104-25, MAXFLOAT)].width;
    
    _bubbleWidthConstraint.constant = bubbleWidth + 25;
    [self.contentView setNeedsUpdateConstraints];
    [self.contentView layoutIfNeeded];
}

@end
