//
//  HTScrollCell.m
//  Upper
//
//  Created by 张永明 on 2017/3/21.
//  Copyright © 2017年 aries365.com. All rights reserved.
//

#import "HTScrollCell.h"
#import "UPTools.h"
#import "UPTheme.h"

#import "UIImageView+AFNetworking.h"
//#import "UIImageView+WebCache.h"

@interface HTImageButton(){
    NSString*    _imageURL;
}
@end

@implementation HTImageButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        _imageView=[[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_imageView];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [_imageView setFrame:self.bounds];
}

-(void)setImage:(UIImage*)image{
    [_imageView setImage:image];
}

-(void)setImageURL:(NSString*)url{
    [self setImageURL:url withHoldplacer:nil];
}

-(void)setImageURL:(NSString*)url withHoldplacer:(UIImage*)holdImage{
    [_imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:holdImage];
    //    [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:holdImage];
}

-(void)setSDImage:(UIImage *)image{
    
}

-(void)setSDImageURL:(NSString*)url{
    
}

-(void)setSDImageURL:(NSString*)url withHoldplacer:(UIImage*)holdImage{
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

@interface HTImageTitleButton(){
    UILabel* _titleLabel;
}
@end
@implementation HTImageTitleButton
-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        _titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.font=kUPThemeMinFont;
        _titleLabel.backgroundColor=[UIColor clearColor];
        _titleLabel.adjustsFontSizeToFitWidth=YES;
        [self addSubview:_titleLabel];
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _titleLabel.text=title;
}
-(void)setTitleColor:(UIColor*)color{
    _titleLabel.textColor=color;
}
-(void)setTitleFrame:(CGRect)titleFrame imgFrame:(CGRect)imgFrame{
    _imageView.frame=imgFrame;
    _titleLabel.frame=titleFrame;
    _titleLabel.textColor= [UPTools colorWithHex:0x666666];
}
@end


@implementation HTConfigItem
-(instancetype)initWithDict:(NSDictionary*)jsonDict{
    self=[super init];
    if(self){
        self.itemID=[NSString stringWithFormat:@"%i",[[jsonDict valueForKey:@"id"] intValue]];
    }
    return self;
}
@end


@implementation HTConfigCollectItem

- (NSMutableArray *)subItems
{
    if (_subItems==nil) {
        _subItems = [NSMutableArray new];
    }
    return _subItems;
}
@end

@implementation HTConfigInfoItem
@end

#define kHTImageButtonBaseTag 1000

@interface HTScrollCell () {
    UIScrollView *_scrollView;
}
@end

@implementation HTScrollCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setConfigItem:(HTConfigItem *)configItem{
    _configItem = configItem;
    
    if(_scrollView==nil){
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,kImageButtonHeight)];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    _scrollView.backgroundColor=[UIColor clearColor];

    HTConfigCollectItem *collectItem = (HTConfigCollectItem *)configItem;
    __block CGRect adFrame=CGRectZero;
    [_scrollView setContentSize:CGSizeMake(collectItem.subItems.count*kImageButtonWidth+(collectItem.subItems.count+1)*kScrollCellBorder, _scrollView.frame.size.height)];
    adFrame=CGRectMake(kScrollCellBorder, 0, kImageButtonWidth, kImageButtonHeight);
    
    [collectItem.subItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        HTConfigInfoItem* adItem=(HTConfigInfoItem*)obj;
        HTImageTitleButton* btn=[self buttonWithIndex:idx inView:_scrollView];
        btn.frame=adFrame;
        
        [btn setTitle:adItem.title];
        [btn setImage:[UIImage imageNamed:adItem.localImage]];
        
        CGRect imageRect = CGRectMake(0, 0, kImageButtonWidth, kImageButtonHeight-20);
        CGRect titleRect = CGRectMake(0, kImageButtonHeight-20, kImageButtonWidth, 20);
        [btn setTitleFrame:titleRect imgFrame:imageRect];
        
        adFrame = CGRectOffset(adFrame, kImageButtonWidth+kScrollCellBorder, 0);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(HTImageTitleButton*)buttonWithIndex:(NSInteger)index inView:(UIView *)view{
    HTImageTitleButton* imageButton=(HTImageTitleButton*)[view viewWithTag:kHTImageButtonBaseTag+index];
    if(imageButton==nil){
        imageButton=[[HTImageTitleButton alloc] initWithFrame:CGRectZero];
        imageButton.tag=kHTImageButtonBaseTag+index;
        [imageButton addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:imageButton];
    }
    return imageButton;
}

-(void)itemClicked:(UIView*)sender{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(configItemSelected:)]){
        if([self.configItem isKindOfClass:[HTConfigCollectItem class]]){
            HTConfigCollectItem* collectItem=(HTConfigCollectItem*)self.configItem;
            if(collectItem.subItems&&(sender.tag-kHTImageButtonBaseTag)<[collectItem.subItems count]){
                [self.delegate configItemSelected:[collectItem.subItems objectAtIndex:sender.tag-kHTImageButtonBaseTag]];
            }else {
                [self.delegate configItemSelected:self.configItem];
            }
        }
    }
}

@end
