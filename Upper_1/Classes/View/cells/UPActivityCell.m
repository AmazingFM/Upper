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
#import "DrawSomething.h"
#import "UPTheme.h"
#import "MBProgressHUD+MJ.h"

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

        _locationButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_locationButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
        
        _locationButton.backgroundColor=[UIColor clearColor];
        _locationButton.titleLabel.textColor = [UIColor whiteColor];
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
    UILabel *_clothLab;
    UILabel *_statusLab;
    
    UIView *_btnContainerView;
    
    UIButton *_reviewActBtn;
    UIButton *_cancelActBtn;
    UIButton *_changeActBtn;
    UIButton *_commentActBtn;
    UIButton *_quitActBtn;
    
    UPTimeLocationView *_timeLocationV;
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
        
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.font = kUPThemeSmallFont;
        _typeLab.backgroundColor = [UPTools colorWithHex:0x79CDCD];
        _typeLab.textAlignment = NSTextAlignmentCenter;
        _typeLab.layer.cornerRadius = 2.0f;
        _typeLab.layer.masksToBounds = YES;
        
        _clothLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _clothLab.font = kUPThemeSmallFont;
        _clothLab.backgroundColor = [UPTools colorWithHex:0x79CDCD];
        _clothLab.textAlignment = NSTextAlignmentCenter;
        _clothLab.layer.cornerRadius = 2.0f;
        _clothLab.layer.masksToBounds = YES;

        
        _statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLab.font = kUPThemeMinFont;
        _statusLab.backgroundColor = [UIColor clearColor];
        _statusLab.textColor = [UIColor redColor];
        _statusLab.textAlignment = NSTextAlignmentCenter;
        _statusLab.layer.cornerRadius = 2.0f;
        _statusLab.layer.masksToBounds = YES;
        
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
        [_changeActBtn setTitle:@"更改" forState:UIControlStateNormal];
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
        [_quitActBtn setTitle:@"取消" forState:UIControlStateNormal];
        _quitActBtn.tag = kUPActQuitTag;
        [_quitActBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _quitActBtn.titleLabel.font = kUPThemeMinFont;
        _quitActBtn.layer.cornerRadius = 2.0f;
        _quitActBtn.layer.masksToBounds = YES;
        _quitActBtn.layer.borderWidth = 1.f;
        [_quitActBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        [_btnContainerView addSubview:_reviewActBtn];
        [_btnContainerView addSubview:_cancelActBtn];
        [_btnContainerView addSubview:_changeActBtn];
        [_btnContainerView addSubview:_commentActBtn];
        [_btnContainerView addSubview:_quitActBtn];
        
        _timeLocationV = [[UPTimeLocationView alloc] initWithFrame:CGRectZero];
        
        [backView addSubview:_img];
        [backView addSubview:_titleLab];
        [backView addSubview:_freeTips];
        [backView addSubview:_typeLab];
        [backView addSubview:_clothLab];
        [backView addSubview:_statusLab];
        [backView addSubview:_btnContainerView];
        [self addSubview:_timeLocationV];
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
    NSArray*  actTypeArr = @[@"不限", @"派对、酒会", @"桌游、座谈、棋牌", @"KTV", @"户外烧烤", @"运动",@"交友、徒步"];
    
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
    NSArray *actStatusArr = @[@"创建募集期", @"募集成功", @"报名截止", @"活动发生", @"活动结束", @"募集失败", @"", @"",@"", @"活动取消"];
    NSArray *clothTypeArr = @[@"随性", @"西装领带", @"便装"];

    int selectIndex;
    selectIndex = [itemData.activity_class intValue];
    if (selectIndex<actTypeArr.count) {
        _typeLab.text = actTypeArr[selectIndex];
        size = SizeWithFont(actTypeArr[selectIndex], kUPThemeSmallFont);
        _typeLab.size = CGSizeMake(size.width+10, size.height+4);;
        _typeLab.center = CGPointMake(offsetx+size.width/2+5, offsety+perHeight/2);
    }
    
    selectIndex = [itemData.clothes_need intValue];
    if (selectIndex<clothTypeArr.count) {
        _clothLab.text = clothTypeArr[selectIndex];
        size = SizeWithFont(clothTypeArr[selectIndex], kUPThemeSmallFont);
        _clothLab.size = CGSizeMake(size.width+10, size.height+4);;
        _clothLab.center = CGPointMake(offsetx+size.width/2+5+_typeLab.size.width+kUPThemeBorder, offsety+perHeight/2);
    }
    
    offsety += perHeight;
    
    selectIndex = [itemData.activity_status intValue];
    if (selectIndex<actStatusArr.count) {
        _statusLab.text = actStatusArr[selectIndex];
        size = SizeWithFont(actStatusArr[selectIndex], kUPThemeMinFont);
        _statusLab.size = CGSizeMake(size.width+10, size.height+4);;
        _statusLab.center = CGPointMake(offsetx+size.width/2+5, offsety+perHeight/2);
        
        offsetx = CGRectGetMaxX(_statusLab.frame);
        
        _btnContainerView.size = CGSizeMake( width-offsetx, perHeight);
        _btnContainerView.center = CGPointMake((width+offsetx)/2, offsety+perHeight/2);
        _btnContainerView.backgroundColor = [UIColor clearColor];
        _btnContainerView.hidden =NO;
        
        CGSize size = SizeWithFont(@"回顾", kUPThemeMinFont);
        size.width += 10;
        if (_actCellItem.type==SourceTypeWoFaqi) {
            switch (selectIndex) {
                case 3: //针对 活动发生 回顾
                    _reviewActBtn.frame = CGRectMake(0,0,size.width,perHeight);
                    _cancelActBtn.frame = CGRectZero;
                    _changeActBtn.frame = CGRectZero;
                    _commentActBtn.frame = CGRectZero;
                    _quitActBtn.frame = CGRectZero;
                    break;
                case 0:
                case 1:
                case 2:
                    _cancelActBtn.frame = CGRectMake(0,0,size.width,perHeight);
                    _changeActBtn.frame = CGRectMake(10+size.width,0,size.width,perHeight);
                    _reviewActBtn.frame = CGRectZero;
                    
                    _commentActBtn.frame = CGRectZero;
                    _quitActBtn.frame = CGRectZero;

                    break;
                default:
//                    _reviewActBtn.frame = CGRectMake(0,0,size.width,perHeight);
                    _reviewActBtn.frame = CGRectZero;
                    _cancelActBtn.frame = CGRectZero;
                    _changeActBtn.frame = CGRectZero;
                    _commentActBtn.frame = CGRectZero;
                    _quitActBtn.frame = CGRectZero;
                    break;
            }
        } else if(_actCellItem.type==SourceTypeWoCanyu) {
            switch (selectIndex) {
                case 3:
                    _commentActBtn.frame = CGRectMake(0,0,size.width,perHeight);
                    _quitActBtn.frame = CGRectZero;

                    _reviewActBtn.frame = CGRectZero;
                    _cancelActBtn.frame = CGRectZero;
                    _changeActBtn.frame = CGRectZero;
                    break;
                case 0:
                case 1:
                case 2:
                    _quitActBtn.frame = CGRectMake(0,0,size.width,perHeight);
                    _commentActBtn.frame = CGRectMake(10+size.width,0,size.width,perHeight);
                    
                    _reviewActBtn.frame = CGRectZero;
                    _cancelActBtn.frame = CGRectZero;
                    _changeActBtn.frame = CGRectZero;
                    break;
                default:
                    _commentActBtn.frame = CGRectZero;
                    _quitActBtn.frame = CGRectZero;

                    _cancelActBtn.frame = CGRectZero;
                    _changeActBtn.frame = CGRectZero;
                    _reviewActBtn.frame = CGRectZero;
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
    
    offsetx = height*4/3+kUPThemeBorder;
    NSString *time = [UPTools dateStringTransform:itemData.begin_time fromFormat:@"yyyyMMddHHmmss" toFormat:@"yyyy.MM.dd"];
    NSString *location = itemData.activity_place;
    NSString *mergeStr = [NSString stringWithFormat:@"%@AAA%@", time, location];
    
    size = SizeWithFont(mergeStr, kUPThemeSmallFont);
    _timeLocationV.size = CGSizeMake(size.width, size.height+4);
    _timeLocationV.center = CGPointMake(offsetx+size.width/2, offsety+perHeight/2);
    [_timeLocationV setTime:time andLocation:location];
}

- (void)onClick:(UIButton *)sender
{
    if (sender.tag==kUPActQuitTag||
        sender.tag==kUPActCancelTag) {
        NSString *msg = sender.tag==kUPActCancelTag?@"Hi,你准备取消活动?":@"Hi,你准备退出活动?";
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = sender.tag;
        [alertView show];

    } else if (sender.tag==kUPActReviewTag||
               sender.tag==kUPActCommentTag||
               sender.tag==kUPActChangeTag)
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
