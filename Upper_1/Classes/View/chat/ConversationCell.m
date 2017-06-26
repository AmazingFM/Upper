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
@property (nonatomic, retain) UILabel   *badgeLabel;
@property (nonatomic, retain) UILabel *name, *msg, *time;

@end

@implementation ConversationCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_userIconView) {
            _userIconView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftRightPadding, ([ConversationCell cellHeight]-48)/2, 48, 48)];
            _userIconView.layer.masksToBounds = YES;
            _userIconView.layer.cornerRadius = 48/2;
            self.layer.borderWidth = 0.5;
            self.layer.borderColor = [UPTools colorWithHex:0xdddddd].CGColor;
            [self.contentView addSubview:_userIconView];
        }
        
        if (!_badgeLabel) {
            _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding+48-8, ([ConversationCell cellHeight]-48)/2, 8, 8)];
            _badgeLabel.layer.cornerRadius = 4;
            _badgeLabel.layer.masksToBounds = YES;
            _badgeLabel.backgroundColor = [UIColor redColor];
            _badgeLabel.hidden = YES;
            [self.contentView addSubview:_badgeLabel];
        }
        if (!_name) {
            _name = [[UILabel alloc] initWithFrame:CGRectMake(75, 8, 150, 25)];
            _name.font = [UIFont systemFontOfSize:17];
            _name.textColor = [UPTools colorWithHex:0x222222];
            _name.backgroundColor = [UIColor clearColor];
            [self.contentView addSubview:_name];
        }
        if (!_time) {
            _time = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-200-LeftRightPadding, 8, 200, 25)];
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
    
    switch (_curPriMsg.localMsgType) {
        case MessageTypeSystemGeneral:
        {
            _userIconView.image = [UIImage imageNamed:@""];
            _name.text = @"系统消息";
            NSString *addTime = [UPTools dateTransform:_curPriMsg.add_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy年MM月dd日 HH时mm分"];
            _time.text = addTime;
            _msg.text = _curPriMsg.msg_desc;
        }
            break;
        case MessageTypeActivityInvite:
        {
            _userIconView.image = [UIImage imageNamed:@"icon_msg_invite"];
            _name.text = @"活动邀请";
            NSString *addTime = [UPTools dateTransform:_curPriMsg.add_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy年MM月dd日 HH时mm分"];
            _time.text = addTime;
            _msg.text = @"有人向你发送了活动邀请！";
        }
            break;
        case MessageTypeActivityChangeLauncher:
        {
            _userIconView.image = [UIImage imageNamed:@"icon_msg_change_launcher"];
            _name.text = @"发起人移交";
            NSString *addTime = [UPTools dateTransform:_curPriMsg.add_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy年MM月dd日 HH时mm分"];
            _time.text = addTime;
            _msg.text = @"有人申请将发起人移交给你！";
        }
            break;
        default:
        {
            _userIconView.image = [UIImage imageNamed:@"head"];
//            [_userIconView sd_setImageWithURL:_curPriMsg.remote_id placeholderImage:[UIImage imageNamed:@"head"]];
            _name.text = _curPriMsg.remote_name;
            NSString *addTime = [UPTools dateTransform:_curPriMsg.add_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy年MM月dd日 HH时mm分"];
            _time.text = addTime;
            _msg.text = _curPriMsg.msg_desc;
        }
            break;
    }
    
    BOOL read_status = [_curPriMsg.read_status intValue];
    _badgeLabel.hidden = read_status;
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
        
        _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding+48-8, ([ToMessageCell cellHeight]-48)/2, 8, 8)];
        _badgeLabel.layer.cornerRadius = 4;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.hidden = YES;
        [self.contentView addSubview:_badgeLabel];

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
    self.textLabel.text = titleStr;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(LeftRightPadding, ([ToMessageCell cellHeight]-48)/2, 48, 48);
    self.textLabel.frame = CGRectMake(75, ([ToMessageCell cellHeight]-30)/2, ScreenWidth-120, 30);
    NSString *badgeTip = @"";
    if (_unreadCount && _unreadCount.integerValue > 0) {
        _badgeLabel.hidden = NO;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        _badgeLabel.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self.contentView addBadgeTip:badgeTip withCenterPosition:CGPointMake(ScreenWidth-25, [ToMessageCell cellHeight]/2)];
}

+ (CGFloat)cellHeight
{
    return 61.0;
}

@end
