//
//  ConversationCell.m
//  Upper
//
//  Created by 张永明 on 2017/2/14.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "ConversationCell.h"
#import "PrivateMessage.h"
#import "Info.h"
#import "UPTools.h"
#import "UPTheme.h"

#import "UIImageView+Upper.h"

@interface ConversationCell()
@property (nonatomic, retain) UIImageView *userIconView;
@property (nonatomic, retain) UILabel *name, *msg, *time;

@end

@implementation ConversationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftRightPadding, ([ConversationCell cellHeight]-48)/2, 48, 48)];
            _userIconView.layer.masksToBounds = YES;
            _userIconView.layer.cornerRadius = 48/2;
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = [UPTools colorWithHex:0xdddddd].CGColor;
            [self.contentView addSubview:_userIconView];
        }
        if (!_name) {
            _name = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 150, 25)];
            _name.font = [UIFont systemFontOfSize:17];
            _name.textColor = [UPTools colorWithHex:0x222222];
            _name.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_name];
        }
        if (!_time) {
            _time = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-100-LeftRightPadding, 8, 100, 25)];
            _time.font = [UIFont systemFontOfSize:12];
            _time.textAlignment = NSTextAlignmentRight;
            _time.textColor = [UPTools colorWithHex:0x999999];
            _time.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_time];
        }
        if (!_msg) {
            _msg = [[UILabel alloc] initWithFrame:CGRectMake(75, 30, ScreenWidth-75-30-LeftRightPadding, 25)];
            _msg.font = [UIFont systemFontOfSize:15];
            _msg.backgroundColor = [UIColor clearColor];
            _msg.textColor = [UPTools colorWithHex:0x999999];
            [self.contentView addSubview:_msg];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!_curPriMsg) {
        return;
    }
//    [_userIconView sd_setImageWithURL:_curPriMsg.fromId placeholderImage:[UIImage imageNamed:@"head"]];
    
    switch (_curPriMsg.localMsgType) {
        case MessageTypeSystemGeneral:
        {
            _name.text = @"系统消息";
            _time.text = _curPriMsg.add_time;
            _msg.text = _curPriMsg.message_desc;
        }
            break;
        case MessageTypeActivityInvite:
        {
            _name.text = @"活动邀请";
            _time.text = _curPriMsg.add_time;
            _msg.text = @"有人向你发送了活动邀请，去看看吧@";
        }
            break;
        case MessageTypeActivityChangeLauncher:
        {
            _name.text = @"组织活动";
            _time.text = _curPriMsg.add_time;
            _msg.text = @"想组织活动吗？快去迎接挑战吧@";
        }
            break;
        default:
        {
            _name.text = _curPriMsg.remote_name;
            _time.text = _curPriMsg.add_time;
            _msg.text = _curPriMsg.message_desc;
        }
            break;
    }
}

+ (CGFloat)cellHeight
{
    return 61;
}

@end

@implementation ToMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = kUPThemeTitleFont;
        self.textLabel.textColor = [UPTools colorWithHex:0x222222];
    }
    return self;
}

- (void)setType:(ToMessageType)type
{
    _type = type;
    NSString *imageName, *titleStr;
    switch (type) {
        case ToMessageTypeInvitation:
            imageName = @"messageInvite";
            titleStr = @"活动邀请";
            break;
        case ToMessageTypeSystemNotification:
            imageName = @"messageSystem";
            titleStr = @"系统通知";
            break;
        default:
            break;
    }
    self.imageView.image = [UIImage imageNamed:imageName];
//    [self.imageView setImageWithUserId:@"3" placeholderImage:[UIImage imageNamed:imageName]];
    self.textLabel.text = titleStr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(LeftRightPadding, ([ToMessageCell cellHeight]-48)/2, 48, 48);
    self.textLabel.frame = CGRectMake(75, ([ToMessageCell cellHeight]-30)/2, ScreenWidth-120, 30);
    NSString *badgeTip = @"";
    if (_unreadCount && _unreadCount.integerValue > 0) {
        if (_unreadCount.integerValue > 99) {
            badgeTip = @"99+";
        }else{
            badgeTip = _unreadCount.stringValue;
        }
        self.accessoryType = UITableViewCellAccessoryNone;
    }else{
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self.contentView addBadgeTip:badgeTip withCenterPosition:CGPointMake(ScreenWidth-25, [ToMessageCell cellHeight]/2)];
}

+ (CGFloat)cellHeight
{
    return 61.0;
}

@end
