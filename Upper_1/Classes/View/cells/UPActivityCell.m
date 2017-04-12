//
//  UPActivityCell.m
//  Upper
//
//  Created by 海通证券 on 16/5/18.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPActivityCell.h"
#import "Info.h"
#import "UPTools.h"
#import "UPGlobals.h"
#import "DrawSomething.h"
#import "UPTheme.h"
#import "MBProgressHUD+MJ.h"
#import "UPConfig.h"
#import "YMLabel.h"
#import "YMNetwork.h"

@interface UPTimeLocationView()
{
    UILabel *_timeLabel;
    UIButton *_locationButton;
}
@end

@implementation UPTimeLocationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = kUPThemeSmallFont;
        _timeLabel.adjustsFontSizeToFitWidth = YES;

        _locationButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        
        _locationButton.backgroundColor=[UIColor clearColor];
        _locationButton.titleLabel.textColor = [UIColor whiteColor];
        _locationButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        _locationButton.titleLabel.font = kUPThemeSmallFont;
        _locationButton.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
        [_locationButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_timeLabel];
        [self addSubview:_locationButton];
    }
    
    return self;
}

- (void)setTime:(NSString *)time andLocation:(NSString *)location
{
    float offsetX=0;
    CGSize size;
    _timeLabel.text = time;
    
    size = SizeWithFont(time, kUPThemeSmallFont);
    _timeLabel.frame = CGRectMake(offsetX, 0, size.width, self.frame.size.height);
    
    offsetX += size.width+5;
    
    [_locationButton setTitle:location forState:UIControlStateNormal];
    _locationButton.frame = CGRectMake(offsetX, 0, self.frame.size.width-offsetX, self.frame.size.height);
}

- (void)onClick:(UIButton *)sender
{
    
}

@end

@implementation UILabel (VerticalUpAlignment)

- (void)verticalUpAlignmentWithText:(NSString *)text maxHeight:(CGFloat)maxHeight
{
    CGRect frame = self.frame;
    NSDictionary *attribute = @{NSFontAttributeName:self.font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(frame.size.width, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    frame.size = CGSizeMake(frame.size.width, rect.size.height);
    self.frame = frame;
    self.text = text;
}

@end


@interface UPActivityCell() <UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    UIView *backView;
    UIImageView *_img;
    UILabel *_titleLab;
    UILabel *_freeTips;
    UILabel *_typeLab;
    UILabel *_payLab;
    UILabel *_statusLab;
    UILabel *_sponserLab;
    
    UIView *_btnContainerView;
    
    UIButton *_reviewActBtn;
    UIButton *_cancelActBtn;
    UIButton *_changeActBtn;
    UIButton *_commentActBtn;
    UIButton *_quitActBtn;
    UIButton *_signActBtn;
    UIButton *_editActBtn;
    
    UILabel *_timeLabel;
}

@end

@implementation UPActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];

        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = kUPThemeTitleFont;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.adjustsFontSizeToFitWidth = YES;

        _freeTips = [[UILabel alloc] initWithFrame:CGRectZero];
        _freeTips.font = kUPThemeTitleFont;
        _freeTips.backgroundColor = [UIColor clearColor];
        _freeTips.textAlignment = NSTextAlignmentRight;

        _img = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = kUPThemeSmallFont;
        _timeLabel.backgroundColor = [UIColor redColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.layer.cornerRadius = 2.0f;
        _timeLabel.adjustsFontSizeToFitWidth = YES;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.textColor = [UIColor whiteColor];
        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLab.font = kUPThemeMinFont;
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.textColor = [UIColor redColor];
        _statusLab.layer.cornerRadius = 2.0f;
        _statusLab.layer.masksToBounds = YES;
        
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.font = kUPThemeSmallFont;
        _typeLab.backgroundColor = [UPTools colorWithHex:0x79CDCD];
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.layer.cornerRadius = 2.0f;
        _typeLab.adjustsFontSizeToFitWidth = YES;
        _typeLab.layer.masksToBounds = YES;
        
        _payLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _payLab.font = kUPThemeSmallFont;
        _payLab.backgroundColor = [UPTools colorWithHex:0x79CDCD];
        _payLab.textAlignment = NSTextAlignmentCenter;
        _payLab.layer.cornerRadius = 2.0f;
        _payLab.layer.masksToBounds = YES;
        _payLab.adjustsFontSizeToFitWidth = YES;
        
        _sponserLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _sponserLab.font = kUPThemeSmallFont;
        _sponserLab.textAlignment = NSTextAlignmentCenter;
        _sponserLab.layer.cornerRadius = 2.0f;
        _sponserLab.layer.masksToBounds = YES;
        _sponserLab.adjustsFontSizeToFitWidth = YES;
        
        _btnContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _btnContainerView.backgroundColor = [UIColor clearColor];
        
        _reviewActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reviewActBtn setTitle:@"回顾" forState:UIControlStateNormal];
        _reviewActBtn.tag = kUPActReviewTag;
        [_reviewActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _reviewActBtn.titleLabel.font = kUPThemeMinFont;
        _reviewActBtn.layer.cornerRadius = 2.0f;
        _reviewActBtn.layer.masksToBounds = YES;
        _reviewActBtn.layer.borderWidth = 1.f;
        [_reviewActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelActBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelActBtn.tag = kUPActCancelTag;
        [_cancelActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _cancelActBtn.titleLabel.font = kUPThemeMinFont;
        _cancelActBtn.layer.cornerRadius = 2.0f;
        _cancelActBtn.layer.masksToBounds = YES;
        _cancelActBtn.layer.borderWidth = 1.f;
        [_cancelActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeActBtn setTitle:@"更改发起人" forState:UIControlStateNormal];
        _changeActBtn.tag = kUPActChangeTag;
        [_changeActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _changeActBtn.titleLabel.font = kUPThemeMinFont;
        _changeActBtn.layer.cornerRadius = 2.0f;
        _changeActBtn.layer.masksToBounds = YES;
        _changeActBtn.layer.borderWidth = 1.f;
        [_changeActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        _commentActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentActBtn setTitle:@"评论" forState:UIControlStateNormal];
        _commentActBtn.tag = kUPActCommentTag;
        [_commentActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _commentActBtn.titleLabel.font = kUPThemeMinFont;
        _commentActBtn.layer.cornerRadius = 2.0f;
        _commentActBtn.layer.masksToBounds = YES;
        _commentActBtn.layer.borderWidth = 1.f;
        [_commentActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        _quitActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitActBtn setTitle:@"退出" forState:UIControlStateNormal];
        _quitActBtn.tag = kUPActQuitTag;
        [_quitActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _quitActBtn.titleLabel.font = kUPThemeMinFont;
        _quitActBtn.layer.cornerRadius = 2.0f;
        _quitActBtn.layer.masksToBounds = YES;
        _quitActBtn.layer.borderWidth = 1.f;
        [_quitActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _signActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signActBtn setTitle:@"签到" forState:UIControlStateNormal];
        _signActBtn.tag = kUPActSignTag;
        [_signActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _signActBtn.titleLabel.font = kUPThemeMinFont;
        _signActBtn.layer.cornerRadius = 2.0f;
        _signActBtn.layer.masksToBounds = YES;
        _signActBtn.layer.borderWidth = 1.f;
        [_signActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        _editActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editActBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _editActBtn.tag = kUPActEditTag;
        [_editActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _editActBtn.titleLabel.font = kUPThemeMinFont;
        _editActBtn.layer.cornerRadius = 2.0f;
        _editActBtn.layer.masksToBounds = YES;
        _editActBtn.layer.borderWidth = 1.f;
        [_editActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        [_btnContainerView addSubview:_reviewActBtn];
        [_btnContainerView addSubview:_cancelActBtn];
        [_btnContainerView addSubview:_changeActBtn];
        [_btnContainerView addSubview:_commentActBtn];
        [_btnContainerView addSubview:_quitActBtn];
        [_btnContainerView addSubview:_signActBtn];
        [_btnContainerView addSubview:_editActBtn];

        [backView addSubview:_img];
        [backView addSubview:_titleLab];
        [backView addSubview:_freeTips];
        [backView addSubview:_typeLab];
        [backView addSubview:_payLab];
        [backView addSubview:_statusLab];
        [backView addSubview:_btnContainerView];
        [backView addSubview:_timeLabel];
        [backView addSubview:_sponserLab];
    }
    return self;
}

- (void)setActivityItems:(UPBaseCellItem *)item
{
    _actCellItem = (UPActivityCellItem*)item;
    ActivityData *itemData = _actCellItem.itemData;
    
    
    backView.frame = CGRectMake(0, TopDownPadding, _actCellItem.cellWidth, _actCellItem.cellHeight-2*TopDownPadding);
    
    CGFloat width = backView.frame.size.width;
    CGFloat height = backView.frame.size.height;
    
    CGFloat offsetx=0;
    CGFloat offsety=0;
    
    _img.frame = CGRectMake(0, 0, height*4/3, height);
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.clipsToBounds = YES;
    [_img sd_setImageWithURL:[NSURL URLWithString:itemData.activity_image] placeholderImage:[UIImage imageNamed:@"me"]];
    _titleLab.text = itemData.activity_name;
    
    NSString *freeStr = [NSString stringWithFormat:@"♂免费"];
    //富文本对象
    NSMutableAttributedString * aAttributedString = [[NSMutableAttributedString alloc] initWithString:freeStr];
    
    NSRange range0 = [freeStr rangeOfString:@"免费"];
    NSRange range1 = [freeStr rangeOfString:@"♀"];
    NSRange range2 = [freeStr rangeOfString:@"♂"];
    
    //富文本样式
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(242, 156, 177) range:range1];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(0, 124, 195) range:range2];
    [aAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range0];
    [aAttributedString addAttribute:NSFontAttributeName value:kUPThemeNormalFont range:range1];
    [aAttributedString addAttribute:NSFontAttributeName value:kUPThemeNormalFont range:range2];
    [aAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:8] range:range0];
    _freeTips.attributedText = aAttributedString;

    
    offsetx += height*4/3+kUPThemeBorder;
    
    _titleLab.frame = CGRectMake(offsetx,offsety,width-offsetx-80,30);
    
    _freeTips.frame = CGRectMake(width-95, offsety, 80, 30);
    
    offsety += _titleLab.height;
    
    CGFloat perHeight = (height-offsety)/3;
    
    CGSize size;
    
    NSString *begin_time = [UPTools dateStringTransform:itemData.begin_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy.MM.dd"];
    _timeLabel.text = begin_time;
    size = SizeWithFont(begin_time, kUPThemeSmallFont);
    
    _timeLabel.size = CGSizeMake(size.width+kUPThemeBorder*2, size.height+4);
    _timeLabel.center = CGPointMake(offsetx+size.width/2+kUPThemeBorder, offsety+perHeight/2);
    
    /**
     二、活动状态时序
     活动背景：1日创建，10日报名截止，12日开始
     总人数限制：5-10人，女性限制: >=2人
     
     0-募集期：活动募集中 (1-10日)：总人数<5人 或 女性参与者<2人
     1-募集期：募集成功 （1-10日）总人数5-9人 且  女性参与者>=2人
     2-募集期：男性满员 （1-10日）女性参与者<2人 且 男性8人报名
     3-募集期：活动满员 （1-10日） 总人数10人
     4-募集结束：募集成功  11日 总人数5-10人 且  女性参与者>=2人
     5-募集结束：募集失败  11日 总人数<5人 或 女性参与者<2人
     6-活动进行中： 12日
     7-活动待回顾： 13日
     8-活动已回顾： 13日以后，发起人回顾
     9-活动取消：1-10日期间，发起人主动取消
     **/
    

    NSString *actStatusID = itemData.activity_status;
    ActivityStatus *actStatus = [[UPConfig sharedInstance] getActivityStatusByID:actStatusID];

    if (actStatus) {
        NSString *statusName = actStatus.name;
        if ([statusName isEqualToString:@"none"]) {
            NSString *sexual = [UPDataManager shared].userInfo.sexual;
            if ([sexual intValue]==0) {
                statusName = @"满员";
            } else {
                statusName = @"募集中";
            }
        }
        _statusLab.text = statusName;
        size = SizeWithFont(statusName, kUPThemeMinFont);
        _statusLab.size = CGSizeMake(size.width+kUPThemeBorder*2, size.height+4);;
        _statusLab.center = CGPointMake(offsetx+size.width/2+kUPThemeBorder+_timeLabel.size.width+kUPThemeBorder, offsety+perHeight/2);
    }
    
    offsety += perHeight;
    NSString *actTypeID = itemData.activity_class;
    ActivityType *activityType = [[UPConfig sharedInstance] getActivityTypeByID:actTypeID];
    
    NSString *actTypeTitle = activityType.name;
    BOOL showFemale = activityType.femaleFlag;
    if (showFemale) {
        _freeTips.hidden = NO;
    } else {
        _freeTips.hidden = YES;
    }
    if (actTypeTitle.length!=0) {
        _typeLab.text = actTypeTitle;
        size = SizeWithFont(actTypeTitle, kUPThemeSmallFont);
        _typeLab.size = CGSizeMake(size.width+kUPThemeBorder*2, size.height+4);
        _typeLab.center = CGPointMake(offsetx+size.width/2+kUPThemeBorder, offsety+perHeight/2);
    } else {
        _typeLab.frame = CGRectZero;
    }
    
    NSString *payTypeID = itemData.is_prepaid;
    BaseType *baseType = [[UPConfig sharedInstance] getPayTypeByID:payTypeID];
    
    NSString *payName = baseType.name;
    if (payName.length!=0) {
        _payLab.text = payName;
        size = SizeWithFont(payName, kUPThemeSmallFont);

        _payLab.size = CGSizeMake(size.width+kUPThemeBorder*2, size.height+4);;
        _payLab.center = CGPointMake(offsetx+size.width/2+kUPThemeBorder+_typeLab.size.width+kUPThemeBorder, offsety+perHeight/2);
    } else {
        _payLab.frame = CGRectZero;
    }
    
    offsety += perHeight;
    if (_actCellItem.type==SourceTypeDaTing) {
        NSString *sponser = itemData.nick_name;
        if (sponser.length!=0) {
            NSString *showStr = [NSString stringWithFormat:@"策划人：%@", sponser];
            _sponserLab.text = showStr;
            size = SizeWithFont(showStr, kUPThemeSmallFont);
            
            _sponserLab.size = CGSizeMake(size.width, size.height+4);;
            _sponserLab.center = CGPointMake(offsetx+size.width/2, offsety+perHeight/2);
        } else {
            _sponserLab.frame = CGRectZero;
        }
    } else {
        _sponserLab.frame = CGRectZero;
    }
    
    if (actStatus) {
        offsetx = height*4/3+kUPThemeBorder;
        
        _btnContainerView.size = CGSizeMake( width-offsetx, perHeight);
        _btnContainerView.center = CGPointMake((width+offsetx)/2, offsety+perHeight/2);
        _btnContainerView.backgroundColor = [UIColor clearColor];
        _btnContainerView.hidden =NO;
        
        CGSize size = SizeWithFont(@"回顾", kUPThemeMinFont);
        size.width += 10;
        
        if (_actCellItem.type==SourceTypeWoFaqi) {
            switch ([actStatusID intValue]) {
                case 0:
                case 1:
                case 2:
                case 3:
                case 4:
                    _changeActBtn.frame =   CGRectMake(0,0,size.width,perHeight);
                    _cancelActBtn.frame =   CGRectMake(10+size.width,0,size.width,perHeight);
                    _reviewActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 6:
                    _signActBtn.frame =     CGRectMake(0,0,size.width,perHeight);
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 7:
                    _reviewActBtn.frame =   CGRectMake(0,0,size.width,perHeight);
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 5:
                case 8:
                case 9:
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
            }
        } else if(_actCellItem.type==SourceTypeWoCanyu) {
            int anticipateStatus = [itemData.activity_class intValue];
            /**
             ● 参与者状态
             0：报名
             1：签到
             2：主动退出
             4：因接受发起人转让而被动退出
             5：已评价
             ● 操作
             活动状态		参与状态		操作
             0-3			-1,2,4		报名 （满员是否可报，前台动态控制，后台有校验）
             0-3			0			退出
             4			0			退出
             5						无操作
             6			0			我要签到->弹个人中心二维码						
             7-9			0,1			评价
             其它						无操作             */
            
            switch ([actStatusID intValue]) {
                    
                case 0:
                case 1:
                case 2:
                case 3:
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 4:
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 5:
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 6:
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
                case 7:
                case 8:
                case 9:
                    _reviewActBtn.frame =   CGRectZero;
                    _changeActBtn.frame =   CGRectZero;
                    _cancelActBtn.frame =   CGRectZero;
                    _commentActBtn.frame =  CGRectZero;
                    _quitActBtn.frame =     CGRectZero;
                    _signActBtn.frame =     CGRectZero;
                    _editActBtn.frame =     CGRectZero;
                    break;
            }

        } else if(_actCellItem.type==SourceTypeTaCanyu ||
                  _actCellItem.type==SourceTypeTaFaqi) {
            _btnContainerView.hidden =YES;
        } else {
            _btnContainerView.hidden =YES;
            _reviewActBtn.frame = CGRectZero;
            _cancelActBtn.frame = CGRectZero;
            _changeActBtn.frame = CGRectZero;
            _commentActBtn.frame = CGRectZero;
            _quitActBtn.frame = CGRectZero;
        }
        offsety += perHeight;
    }
}

- (void)onClick:(UIButton *)sender
{
    if (sender.tag==kUPActQuitTag||
        sender.tag==kUPActCancelTag) {
        NSString *cancleRules = @"取消规则：\n\
        1、募集中的活动，随时可取消，一年内满十次，封停账号一个月（不可发起 可参与）\n\
        2、募集成功的活动，如果发起者不能参加，建议先尝试寻找接替的发起人，将活动发起者身份转交给新的发起人。无法找到接替者也可以取消，一年满3次，封停账号半年。\n\
        3、可以点击“更改发起人”按钮，向目前报名人员发送站内信，发送接受链接。可以在发送之前通过站内短信和参与人员沟通接收意向。\n";
        
        NSString *quitRules = @"退出规则：\n\
        1、	募集中的活动，参与者随时可退出，一年内满十次，封停账号一个月（不可发起 不可参与）\n\
        2、	成功的活动，参与者随时可退出，一年满三次，封停账号3个月。\n";
        
        NSString *msg = sender.tag==kUPActCancelTag?cancleRules:quitRules;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = sender.tag;
        [alertView show];

    } else if (sender.tag==kUPActReviewTag  ||
               sender.tag==kUPActCommentTag ||
               sender.tag==kUPActChangeTag  ||
               sender.tag==kUPActSignTag)
    {
        if ([self.delegate respondsToSelector:@selector(onButtonSelected:withType:)]) {
            [self.delegate onButtonSelected:_actCellItem withType:sender.tag];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView.tag==kUPActCancelTag) {
            [self cancelActivity];
        }
        
        if (alertView.tag==kUPActQuitTag) {
            [self quitActivity];
        }
    }
}
- (void)quitActivity
{
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:g_mainWindow];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityJoinModify"forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:_actCellItem.itemData.ID forKey:@"activity_id"];
    [params setObject:@"2" forKey:@"user_status"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierActQuitRefresh object:nil];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failture:^(id error) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        NSLog(@"%@",error);
        
    }];
}

- (void)cancelActivity
{
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:g_mainWindow];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityModify"forKey:@"a"];
    
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:_actCellItem.itemData.ID forKey:@"activity_id"];
    [params setObject:@"9" forKey:@"user_status"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierActCancelRefresh object:nil];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failture:^(id error) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        NSLog(@"%@",error);
        
    }];
}

@end

@interface HTActivityCell() <UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    UIView *backView;
    UIImageView *_img;
    UILabel *_titleLab;
    UILabel *_freeTips;
    UILabel *_typeLab;
    UILabel *_statusLab;
    
    
    YMLabel *_actDesc;
    UIButton *_timeBtn;
    UIButton *_locationBtn;
    
    UIButton *_payBtn;
    
    UIImageView *_userImgView;
    UILabel *_sponserLab;

    UIView *_btnContainerView;
    
    UIButton *_reviewActBtn;
    UIButton *_cancelActBtn;
    UIButton *_changeActBtn;
    UIButton *_commentActBtn;
    UIButton *_quitActBtn;
    UIButton *_signActBtn;
    UIButton *_editActBtn;
}

@end

@implementation HTActivityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        backView = [[UIView alloc] initWithFrame:CGRectZero];
        backView.layer.cornerRadius = 5.f;
        backView.layer.masksToBounds = YES;

        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.font = kUPThemeSmallFont;
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = [UPTools colorWithHex:0x333333];
        
        _freeTips = [[UILabel alloc] initWithFrame:CGRectZero];
        _freeTips.font = kUPThemeTitleFont;
        _freeTips.backgroundColor = [UIColor clearColor];
        _freeTips.textAlignment = NSTextAlignmentRight;
        
        _img = [[UIImageView alloc] initWithFrame:CGRectZero];
        _img.layer.cornerRadius = 3.f;
        _img.layer.masksToBounds = YES;

        
        _actDesc = [[YMLabel alloc] initWithFrame:CGRectZero];
        _actDesc.font = kUPThemeMinFont;
        _actDesc.numberOfLines = 2;
        _actDesc.lineBreakMode = NSLineBreakByWordWrapping;
        _actDesc.textAlignment = NSTextAlignmentLeft;
        [_actDesc setVerticalAlignment:VerticalAlignmentTop];
        _actDesc.backgroundColor = [UIColor clearColor];
        _actDesc.textColor = [UPTools colorWithHex:0x666666];
        
        _timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _timeBtn.titleLabel.font = kUPThemeMiniFont;
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeBtn.backgroundColor = [UIColor clearColor];
        [_timeBtn setTitleColor:[UPTools colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"icon-time"] forState:UIControlStateNormal];
        
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtn.titleLabel.font = kUPThemeMiniFont;
        _locationBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _locationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _locationBtn.backgroundColor = [UIColor clearColor];
        [_locationBtn setTitleColor:[UPTools colorWithHex:0xaaaaaa] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"icon-address"] forState:UIControlStateNormal];

        _statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLab.font = kUPThemeMinFont;
        _statusLab.textAlignment = NSTextAlignmentRight;
        _statusLab.textColor = [UPTools colorWithHex:0xff5454];
        _statusLab.layer.cornerRadius = 2.0f;
        _statusLab.layer.masksToBounds = YES;
        
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.font = kUPThemeMinFont;
        _typeLab.backgroundColor = [UIColor clearColor];
        _typeLab.textAlignment = NSTextAlignmentLeft;
        _typeLab.layer.cornerRadius = 2.0f;
        _typeLab.adjustsFontSizeToFitWidth = YES;
        _typeLab.layer.masksToBounds = YES;
        
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _payBtn.titleLabel.font = kUPThemeMiniFont;
        _payBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _payBtn.backgroundColor = [UIColor clearColor];
        [_payBtn setTitleColor:[UPTools colorWithHex:0x666666] forState:UIControlStateNormal];
        [_payBtn setImage:[UIImage imageNamed:@"icon-money"] forState:UIControlStateNormal];
        
        _userImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImgView.backgroundColor = [UIColor clearColor];
        _userImgView.contentMode = UIViewContentModeScaleToFill;
        _userImgView.layer.masksToBounds = YES;
        
        _sponserLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _sponserLab.font = kUPThemeMinFont;
        _sponserLab.textAlignment = NSTextAlignmentLeft;
        _sponserLab.layer.cornerRadius = 2.0f;
        _sponserLab.layer.masksToBounds = YES;
        _sponserLab.adjustsFontSizeToFitWidth = YES;
        _sponserLab.textColor = RGBCOLOR(204, 204, 204);
        _sponserLab.backgroundColor = [UIColor clearColor];
        
        _btnContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _btnContainerView.backgroundColor = [UIColor clearColor];
        
        _reviewActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reviewActBtn setTitle:@"回顾" forState:UIControlStateNormal];
        [_reviewActBtn setImage:[UIImage imageNamed:@"icon-review"] forState:UIControlStateNormal];
        _reviewActBtn.tag = kUPActReviewTag;
        [_reviewActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _reviewActBtn.titleLabel.font = kUPThemeMiniFont;
        [_reviewActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelActBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelActBtn setImage:[UIImage imageNamed:@"icon-quit"] forState:UIControlStateNormal];
        _cancelActBtn.tag = kUPActCancelTag;
        [_cancelActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _cancelActBtn.titleLabel.font = kUPThemeMiniFont;
        [_cancelActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _changeActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeActBtn setTitle:@"更改发起人" forState:UIControlStateNormal];
        [_changeActBtn setImage:[UIImage imageNamed:@"icon-changeLauncher"] forState:UIControlStateNormal];
        _changeActBtn.tag = kUPActChangeTag;
        [_changeActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _changeActBtn.titleLabel.font = kUPThemeMiniFont;
        [_changeActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _commentActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentActBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_commentActBtn setImage:[UIImage imageNamed:@"icon-comment"] forState:UIControlStateNormal];
        _commentActBtn.tag = kUPActCommentTag;
        [_commentActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _commentActBtn.titleLabel.font = kUPThemeMiniFont;
        [_commentActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _quitActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitActBtn setTitle:@"退出" forState:UIControlStateNormal];
        [_quitActBtn setImage:[UIImage imageNamed:@"icon-quit"] forState:UIControlStateNormal];
        _quitActBtn.tag = kUPActQuitTag;
        [_quitActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _quitActBtn.titleLabel.font = kUPThemeMiniFont;
        [_quitActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _signActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_signActBtn setTitle:@"签到" forState:UIControlStateNormal];
        [_signActBtn setImage:[UIImage imageNamed:@"icon-sign"] forState:UIControlStateNormal];
        _signActBtn.tag = kUPActSignTag;
        [_signActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _signActBtn.titleLabel.font = kUPThemeMiniFont;
        [_signActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _editActBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editActBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_editActBtn setImage:[UIImage imageNamed:@"icon-edit"] forState:UIControlStateNormal];
        _editActBtn.tag = kUPActEditTag;
        [_editActBtn setTitleColor:[UPTools colorWithHex:0x333333] forState:UIControlStateNormal];
        _editActBtn.titleLabel.font = kUPThemeMiniFont;
        [_editActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btnContainerView addSubview:_reviewActBtn];
        [_btnContainerView addSubview:_cancelActBtn];
        [_btnContainerView addSubview:_changeActBtn];
        [_btnContainerView addSubview:_commentActBtn];
        [_btnContainerView addSubview:_quitActBtn];
        [_btnContainerView addSubview:_signActBtn];
        [_btnContainerView addSubview:_editActBtn];
        
        [backView addSubview:_img];
        [backView addSubview:_titleLab];
        [backView addSubview:_freeTips];
        [backView addSubview:_typeLab];
        [backView addSubview:_payBtn];
        [backView addSubview:_statusLab];
        [backView addSubview:_btnContainerView];
        [backView addSubview:_actDesc];
        [backView addSubview:_timeBtn];
        [backView addSubview:_locationBtn];
        [backView addSubview:_userImgView];
        [backView addSubview:_sponserLab];
    }
    return self;
}

- (void)setActivityItems:(UPBaseCellItem *)item
{
    _actCellItem = (UPActivityCellItem*)item;
    ActivityData *itemData = _actCellItem.itemData;
    
    
    backView.frame = CGRectMake(10, 0, _actCellItem.cellWidth-20, _actCellItem.cellHeight-10);
    
    CGFloat width = backView.frame.size.width;
    
    CGFloat offsetx=5;
    CGFloat offsety=0;
    
    _titleLab.frame = CGRectMake(offsetx,offsety,width-offsetx-80,30);
    _titleLab.text = itemData.activity_name;
    
    CGSize size;
    /**
     二、活动状态时序
     活动背景：1日创建，10日报名截止，12日开始
     总人数限制：5-10人，女性限制: >=2人
     
     0-募集期：活动募集中 (1-10日)：总人数<5人 或 女性参与者<2人
     1-募集期：募集成功 （1-10日）总人数5-9人 且  女性参与者>=2人
     2-募集期：男性满员 （1-10日）女性参与者<2人 且 男性8人报名
     3-募集期：活动满员 （1-10日） 总人数10人
     4-募集结束：募集成功  11日 总人数5-10人 且  女性参与者>=2人
     5-募集结束：募集失败  11日 总人数<5人 或 女性参与者<2人
     6-活动进行中： 12日
     7-活动待回顾： 13日
     8-活动已回顾： 13日以后，发起人回顾
     9-活动取消：1-10日期间，发起人主动取消
     **/
    
    NSString *actStatusID = itemData.activity_status;
    ActivityStatus *actStatus = [[UPConfig sharedInstance] getActivityStatusByID:actStatusID];
    _statusLab.frame = CGRectMake(width-80, 0, 70, 30);
    NSString *statusName = @"";
    int actStatusValue = [actStatusID intValue];
    
    switch (actStatusValue) {
        case 0:
        {
            statusName = @"募集中";
        }
            break;
        case 1:
        {
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"募集中";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"募集成功";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"募集成功";
            }
        }
            break;
        case 2:
            if (_actCellItem.type==SourceTypeDaTing){
                NSString *sexual = [UPDataManager shared].userInfo.sexual;
                if ([sexual intValue]==0) {
                    statusName = @"满员";
                } else {
                    statusName = @"募集中";
                }
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"男性满员";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"募集中";
            }

            break;
        case 3:
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"满员";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"满员";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"募集成功";
            }

            break;
        case 4:
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"募集截止";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"募集成功";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"募集成功";
            }
            break;
        case 5:
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"募集截止";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"募集失败";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"募集失败";
            }
            break;
        case 6:
            statusName = @"进行中";
            break;
        case 7:
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"圆满结束";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"待回顾";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"圆满结束";
            }
            break;
        case 8:
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"圆满结束";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"已回顾";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"圆满结束";
            }
            break;
        case 9:
            if (_actCellItem.type==SourceTypeDaTing){
                statusName = @"圆满结束";
            } else if (_actCellItem.type==SourceTypeWoFaqi){
                statusName = @"待回顾";
            } else if (_actCellItem.type==SourceTypeWoCanyu){
                statusName = @"圆满结束";
            }
            break;
        default:
            statusName = @"未知";
            break;
    }
    _statusLab.text = statusName;
    size = SizeWithFont(statusName, kUPThemeMinFont);

    offsety+=_titleLab.height;
    _img.frame = CGRectMake(offsetx, offsety, 60*4/3, 60);
    _img.contentMode = UIViewContentModeScaleAspectFill;
    _img.clipsToBounds = YES;
    [_img sd_setImageWithURL:[NSURL URLWithString:itemData.activity_image] placeholderImage:[UIImage imageNamed:@"me"]];

    offsetx += _img.width+5;
    _actDesc.frame = CGRectMake(offsetx, offsety, width-offsetx-5, 40);
    _actDesc.text = itemData.activity_desc;
    
    offsety += _actDesc.height;
    
    CGFloat tmpWidth = (width-offsetx)/3;
    _locationBtn.frame = CGRectMake(offsetx, offsety, tmpWidth-10, 60-_actDesc.height);
    [_locationBtn setTitle:itemData.city forState:UIControlStateNormal];
    
    offsetx += tmpWidth-8;
    _timeBtn.frame = CGRectMake(offsetx, offsety, tmpWidth, 60-_actDesc.height);
    NSString *start_time = [UPTools dateStringTransform:itemData.start_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy.MM.dd"];
    [_timeBtn setTitle:start_time forState:UIControlStateNormal];
    
    offsetx += tmpWidth+2;
    NSString *payTypeID = itemData.is_prepaid;
    BaseType *baseType = [[UPConfig sharedInstance] getPayTypeByID:payTypeID];
    
    NSString *payName = baseType.name;
    if ([payTypeID intValue]==0) {
        payName = itemData.activity_fee;
    }
    
    if (payName.length!=0) {
        [_payBtn setTitle:payName forState:UIControlStateNormal];
        _payBtn.frame = CGRectMake(offsetx, offsety, width-offsetx, 60-_actDesc.height);
    } else {
        _payBtn.frame = CGRectZero;
    }
    
    offsetx = 5;
    offsety += 20;
    
    if (_actCellItem.type==SourceTypeDaTing) {
        NSString *sponser = itemData.nick_name;
        if (sponser.length!=0) {
            _sponserLab.text = sponser;
            size = SizeWithFont(sponser, kUPThemeMinFont);
            CGFloat imgWidth = size.height+4;
            _userImgView.frame = CGRectMake(offsetx, offsety+(30-imgWidth)/2, imgWidth, imgWidth);
            _userImgView.layer.cornerRadius = imgWidth/2;
            [_userImgView sd_setImageWithURL:[NSURL URLWithString:itemData.user_icon] placeholderImage:[UIImage imageNamed:@"activity_user_icon"]];
            
            if (size.width>100) {
                size.width = 100;
            }
            offsetx += imgWidth+5;
            _sponserLab.frame = CGRectMake(offsetx, offsety, size.width, 30);
            
            NSString *actTypeID = itemData.activity_class;
            ActivityType *activityType = [[UPConfig sharedInstance] getActivityTypeByID:actTypeID];
            
            NSString *actTypeTitle = activityType.name;
            
            if (actTypeTitle.length!=0) {
                size = SizeWithFont(@" 发布了 ", kUPThemeMinFont);
                
                offsetx += _sponserLab.width;
                
                UILabel *lab = [self viewWithTag:10000];
                if (lab==nil) {
                    lab = [[UILabel alloc] initWithFrame:CGRectZero];
                    lab.font = kUPThemeMinFont;
                    lab.backgroundColor = [UIColor clearColor];
                    lab.textAlignment = NSTextAlignmentLeft;
                    lab.text = @" 发布了 ";
                    lab.textColor = RGBCOLOR(204, 204, 204);
                    lab.tag = 10000;
                }
                lab.frame = CGRectMake(offsetx, offsety, size.width, _sponserLab.height);
                
                offsetx += lab.width;
                
                _typeLab.text = actTypeTitle;
                _typeLab.frame = CGRectMake(offsetx, offsety, width-offsetx, _sponserLab.height);
                [backView addSubview:lab];

            } else {
                _typeLab.frame = CGRectZero;
            }

        } else {
            _sponserLab.frame = CGRectZero;
        }
    } else {
        if (actStatus) {
            _btnContainerView.frame = CGRectMake(offsetx, offsety, width-2*offsetx, 30);
            
            CGFloat perHeight = 30;
            float btnWidth = 60.f;
            float btnPadding = 10.f;
            
            if (_actCellItem.type==SourceTypeWoFaqi) {
                switch ([actStatusID intValue]) {
                    case 0:
                        _changeActBtn.frame =   CGRectMake(width-btnWidth*2-2*btnPadding-80,5,80,perHeight-10);
                        _cancelActBtn.frame =   CGRectMake(width-btnWidth*2-btnPadding,5,btnWidth,perHeight-10);
                        _editActBtn.frame =     CGRectMake(width-btnWidth,5,btnWidth,perHeight-10);
                        _reviewActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        break;
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                        _changeActBtn.frame =   CGRectMake(width-btnWidth-btnPadding-80,5,80,perHeight-10);
                        _cancelActBtn.frame =   CGRectMake(width-btnWidth,5,btnWidth,perHeight-10);
                        _reviewActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                    case 6:
                        _signActBtn.frame =     CGRectMake(width-btnWidth,5,btnWidth,perHeight-10);
                        _reviewActBtn.frame =   CGRectZero;
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                    case 7:
                        _reviewActBtn.frame =   CGRectMake(width-btnWidth,5,btnWidth,perHeight-10);
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                    case 5:
                    case 8:
                    case 9:
                        _reviewActBtn.frame =   CGRectZero;
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                }
            } else if(_actCellItem.type==SourceTypeWoCanyu) {
                /**
                 ● 参与者状态
                 0：报名
                 1：签到
                 2：主动退出
                 4：因接受发起人转让而被动退出
                 5：已评价
                 ● 操作
                 活动状态		参与状态		操作
                 0-3			-1,2,4		报名 （满员是否可报，前台动态控制，后台有校验）
                 0-3			0			退出
                 4			0			退出
                 5						无操作
                 6			0			我要签到->弹个人中心二维码
                 7-9			0,1			评价
                 其它						无操作             */
                
                switch ([actStatusID intValue]) {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 4:
                        _quitActBtn.frame =   CGRectMake(width-btnWidth,5,btnWidth,perHeight-10);
                        _reviewActBtn.frame =   CGRectZero;
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                    case 5:
                        _reviewActBtn.frame =   CGRectZero;
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                    case 6:
                        _reviewActBtn.frame =   CGRectZero;
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _commentActBtn.frame =  CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                    case 7:
                    case 8:
                    case 9:
                         _commentActBtn.frame =   CGRectMake(width-btnWidth,5,btnWidth,perHeight-10);
                        _reviewActBtn.frame =   CGRectZero;
                        _changeActBtn.frame =   CGRectZero;
                        _cancelActBtn.frame =   CGRectZero;
                        _quitActBtn.frame =     CGRectZero;
                        _signActBtn.frame =     CGRectZero;
                        _editActBtn.frame =     CGRectZero;
                        break;
                }
                
            } else if(_actCellItem.type==SourceTypeTaCanyu ||
                      _actCellItem.type==SourceTypeTaFaqi) {
                _btnContainerView.hidden =YES;
            } else {
                _btnContainerView.hidden =YES;
                _reviewActBtn.frame = CGRectZero;
                _cancelActBtn.frame = CGRectZero;
                _changeActBtn.frame = CGRectZero;
                _commentActBtn.frame = CGRectZero;
                _quitActBtn.frame = CGRectZero;
            }
        }
    }
}

- (void)onClick:(UIButton *)sender
{
    if (sender.tag==kUPActQuitTag||
        sender.tag==kUPActCancelTag) {
        NSString *cancleRules = @"取消规则：\n\
        1、募集中的活动，随时可取消，一年内满十次，封停账号一个月（不可发起 可参与）\n\
        2、募集成功的活动，如果发起者不能参加，建议先尝试寻找接替的发起人，将活动发起者身份转交给新的发起人。无法找到接替者也可以取消，一年满3次，封停账号半年。\n\
        3、可以点击“更改发起人”按钮，向目前报名人员发送站内信，发送接受链接。可以在发送之前通过站内短信和参与人员沟通接收意向。\n";
        
        NSString *quitRules = @"退出规则：\n\
        1、	募集中的活动，参与者随时可退出，一年内满十次，封停账号一个月（不可发起 不可参与）\n\
        2、	成功的活动，参与者随时可退出，一年满三次，封停账号3个月。\n";
        
        NSString *msg = sender.tag==kUPActCancelTag?cancleRules:quitRules;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = sender.tag;
        [alertView show];
        
    } else if (sender.tag==kUPActReviewTag  ||
               sender.tag==kUPActCommentTag ||
               sender.tag==kUPActChangeTag  ||
               sender.tag==kUPActSignTag    ||
               sender.tag==kUPActEditTag)
    {
        if ([self.delegate respondsToSelector:@selector(onButtonSelected:withType:)]) {
            [self.delegate onButtonSelected:_actCellItem withType:sender.tag];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        if (alertView.tag==kUPActCancelTag) {
            [self cancelActivity];
        }
        
        if (alertView.tag==kUPActQuitTag) {
            [self quitActivity];
        }
    }
}
- (void)quitActivity
{
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:g_mainWindow];
    
    NSDictionary *headParam = [UPDataManager shared].getHeadParams;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:headParam];
    [params setObject:@"ActivityJoinModify"forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:_actCellItem.itemData.ID forKey:@"activity_id"];
    [params setObject:@"2" forKey:@"user_status"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [XWHttpTool getDetailWithUrl:kUPBaseURL parms:params success:^(id json) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierActQuitRefresh object:nil];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failture:^(id error) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        NSLog(@"%@",error);
        
    }];
}

- (void)cancelActivity
{
    [MBProgressHUD showMessage:@"正在提交请求，请稍后...." toView:g_mainWindow];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObject:@"ActivityModify"forKey:@"a"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"user_id"];
    [params setObject:_actCellItem.itemData.ID forKey:@"activity_id"];
    [params setObject:@"9" forKey:@"activity_status"];
    [params setObject:[UPDataManager shared].userInfo.token forKey:@"token"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id json) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        
        NSDictionary *dict = (NSDictionary *)json;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"🙏🏻，恭喜您" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifierActCancelRefresh object:nil];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"💔，很遗憾" message:resp_desc delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    } failure:^(id error) {
        [MBProgressHUD hideHUDForView:g_mainWindow];
        NSLog(@"%@",error);
        
    }];
}

@end

