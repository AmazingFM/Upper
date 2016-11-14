//
//  UPMessageCell.m
//  Upper
//
//  Created by 张永明 on 16/11/13.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPMessageCell.h"

@implementation UPMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor whiteColor];
        
        [self initSubviews];
        [self setLayout];
    }
    return self;
}

- (void)initSubviews
{
    _icon = [UIImageView new];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    _icon.layer.cornerRadius = 5.f;
    _icon.layer.masksToBounds = YES;
    _icon.userInteractionEnabled = YES;
    [self.contentView addSubview:_icon];
    
    _nameLabel = [UILabel new];
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _contentLabel = [UILabel new];
    _contentLabel.numberOfLines = 0;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.font = [UIFont systemFontOfSize:13];
    _contentLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:_contentLabel];

    _badgeLabel = [UILabel new];
    _badgeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _badgeLabel.backgroundColor = [UIColor redColor];
    _badgeLabel.layer.cornerRadius = 5.f;
    _badgeLabel.layer.masksToBounds = YES;
    [self.contentView addSubview:_badgeLabel];
}

- (void)setLayout
{
    for (UIView *view in self.contentView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_icon, _nameLabel, _contentLabel, _badgeLabel);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[_icon(34)]-8-[_nameLabel]->=0-[_badgeLabel(10)]-5-|" options:NSLayoutFormatAlignAllTop metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_icon(34)]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_badgeLabel(10)]" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[_nameLabel]-3-[_contentLabel]-5-|" options:NSLayoutFormatAlignAllLeft|NSLayoutFormatAlignAllRight metrics:0 views:views]];
}

- (void)deleteObject:(id)sender
{
    if (_deleteObj) {
        _deleteObj(self);
    }
}
@end
