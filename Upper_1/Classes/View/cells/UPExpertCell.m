//
//  UPExpertCell.m
//  Upper
//
//  Created by 张永明 on 16/4/24.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPExpertCell.h"
#import "UPTheme.h"

#define kUPImageHBoarder 10
#define kUPImageVBoarder 13
#define kUPImageWidth (60*ScreenWidth/320)
#define kUPImageHeight (50*ScreenWidth/320)

#define kUPNameWidth 100


@interface UPExpertCell()
{
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UILabel *_descLabel;
    UIImageView *_headImg;
    UILabel *_peopleLabel;
    UIImageView *_loveIcon;
}

@end

@implementation UPExpertCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        float offset = 0;
        if (ScreenWidth < 375) {
            
        } else if(ScreenWidth < 414) {
            offset = 6;
        } else {
            offset = 10;
        }
        _loveIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kUPImageHBoarder, kUPImageVBoarder+offset/4, 15, 15)];
        [_loveIcon setImage:[UIImage imageNamed:@""]];
        [self.contentView addSubview:_loveIcon];
        
        _peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUPImageHBoarder+15+kUPImageHBoarder/2, kUPImageVBoarder+offset/4, 100, 15)];
        _peopleLabel.text = @"";
        _peopleLabel.textColor = [UIColor redColor];
        _peopleLabel.textAlignment = NSTextAlignmentLeft;
        _peopleLabel.backgroundColor = [UIColor clearColor];
        _peopleLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_peopleLabel];
        
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUPImageHBoarder, kUPImageVBoarder+kUPImageHeight-20, ScreenWidth-kUPImageWidth-kUPImageHBoarder-kUPNameWidth, 20)];
        _descLabel.text = @"";
        _descLabel.textColor = [UIColor blackColor];
        _descLabel.textAlignment = NSTextAlignmentLeft;
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_descLabel];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-kUPImageWidth-kUPImageHBoarder-150, kUPImageHBoarder+offset/4, 150, 20)];
        _titleLabel.text = @"协和医院专家";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [self.contentView addSubview:_titleLabel];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth-kUPImageHBoarder-kUPImageWidth-80-offset, kUPImageVBoarder-kUPImageHeight-15, 80, 15)];
        _nameLabel.text = @"周明";
        _nameLabel.textColor = [UIColor redColor];
        _nameLabel.textAlignment = NSTextAlignmentRight;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_nameLabel];
        
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-kUPImageWidth-kUPImageVBoarder, kUPImageVBoarder, kUPImageWidth, kUPImageHeight)];
        _headImg.backgroundColor = [UIColor clearColor];
        [_headImg setImage:[UIImage imageNamed:@"upper_default"]];
        [self.contentView addSubview:_headImg];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItems:(UPExpertItem *)expertItem
{
    _expertItem = expertItem;
    if (_expertItem) {
        _titleLabel.text = _expertItem.expertTitle;
        _nameLabel.text = _expertItem.expertName;
        _descLabel.text = _expertItem.expertDesc;
        _peopleLabel.text = [NSString stringWithFormat:@"%d人参与", _expertItem.peopleCount];
        
        NSString *encodedImageUrl = [_expertItem.expertImg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *imageUrl = [NSURL URLWithString:encodedImageUrl];
        [_headImg sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"upper_default"]];
    }
}
@end
