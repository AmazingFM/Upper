//
//  UpRegister2.m
//  Upper_1
//
//  Created by aries365.com on 15/11/24.
//  Copyright (c) 2015年 aries365.com. All rights reserved.
//

#import "UpRegister2.h"
#import "Info.h"

#import "IndustryModel.h"
#import "DrawSomething.h"

@interface UpRegister2()

@property (nonatomic, retain) UIScrollView *contentScro;
@property (nonatomic, retain) UIImageView *gouImage;

@end

@implementation UpRegister2
{
    NSMutableArray<IndustryModel *> *industryCategory;
    NSMutableArray<UIButton *> *industryButtonArr;
    int selectedIndex;
    UIButton * industryB;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    selectedIndex = -1;
    industryButtonArr = [[NSMutableArray alloc]init];
    
    NSString *industyStr= @"行业\nIndustry";
    
    CGSize size = [industyStr sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(100,10000.0f) lineBreakMode:UILineBreakModeWordWrap];
    
    
    UILabel *industryL = [[UILabel alloc]initWithFrame:CGRectMake(LeftRightPadding, frame.size.height-2-size.height-2, size.width, size.height)];
    industryL.textAlignment = NSTextAlignmentRight;
    industryL.numberOfLines = 0;
    industryL.text = industyStr;
    industryL.backgroundColor = [UIColor clearColor];
    industryL.font = [UIFont systemFontOfSize:12];
    industryL.textColor = [UIColor whiteColor];

    industryB = [[UIButton alloc]initWithFrame:CGRectMake(size.width+LeftRightPadding, industryL.origin.y, frame.size.width-2*LeftRightPadding-size.width, size.height)];
    industryB.backgroundColor = [UIColor clearColor];
    [industryB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *privacyText = @"提示：您选择的行业，单位或邮箱信息均只作为验证用途，将会被严格保密，除非您本人要求，否则不会显示给其他用户。";
    CGRect privacyRect = [privacyText boundingRectWithSize:CGSizeMake( frame.size.width-2*LeftRightPadding, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kUPThemeNormalFont} context:nil];
    
    UILabel *privacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftRightPadding, floorf(industryL.origin.y- ceilf(privacyRect.size.height)), frame.size.width-2*LeftRightPadding, ceilf(privacyRect.size.height+20))];
    privacyLabel.center = self.center;
    privacyLabel.numberOfLines = 0;
    privacyLabel.font = kUPThemeNormalFont;
    privacyLabel.textColor = [UIColor whiteColor];
    privacyLabel.text = privacyText;
    privacyLabel.textAlignment = NSTextAlignmentLeft;
    privacyLabel.backgroundColor = [UIColor clearColor];

    UIImageView * seperatorV = [[UIImageView alloc]initWithFrame:CGRectMake(LeftRightPadding, frame.size.height-2, frame.size.width-2*LeftRightPadding, 1)];
    seperatorV.backgroundColor = [UIColor blackColor];
    
    _contentScro = [[UIScrollView alloc] initWithFrame:CGRectMake(LeftRightPadding, 0, frame.size.width-2*LeftRightPadding, industryB.origin.y-10)];
    _contentScro.showsHorizontalScrollIndicator = NO;
    _contentScro.showsVerticalScrollIndicator = NO;
    _contentScro.scrollEnabled = YES;
    
    _gouImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Selected"]];
    [_gouImage setSize:CGSizeMake(10, 10)];
    [_gouImage setCenter:CGPointMake(-100, -100)];
    [_contentScro addSubview:_gouImage];
    
    [self addSubview:seperatorV];
    [self addSubview:industryL];
    [self addSubview:privacyLabel];
    [self addSubview:industryB];
    [self addSubview:_contentScro];
    return self;
}

- (void)loadIndustryData:(id)respData
{
    NSDictionary *dict = (NSDictionary *)respData;
    
    
    NSArray<IndustryModel*> *tempArr = [IndustryModel objectArrayWithKeyValuesArray:dict[@"industry_list"]];

    industryCategory = [[NSMutableArray alloc] initWithArray:tempArr];
                        
    int nCount=0;
    CGFloat btnWidth = (_contentScro.size.width-30)/4;
    CGFloat btnHeight = btnWidth/2.5;
    int row = 0;
    
    [self resetSubView];
    [industryButtonArr removeAllObjects];
    
    for (IndustryModel *obj in industryCategory) {
        UIButton *tmp = [[UIButton alloc]init];
        tmp.layer.masksToBounds = YES;
        [tmp.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
        [tmp setBackgroundImage:[UIImage imageNamed:@"select_bg"] forState:UIControlStateSelected];
        [tmp setBackgroundImage:[UIImage imageNamed:@"unselect_bg"] forState:UIControlStateNormal];
        row = nCount/4;
        
        tmp.titleLabel.font = kUPThemeNormalFont;
        [tmp setFrame:CGRectMake(nCount%4*(btnWidth+10), row*(btnHeight+15), btnWidth, btnHeight)];
        [tmp setTitle:obj.industry_name forState:UIControlStateNormal];
        tmp.tag = nCount;
        tmp.titleLabel.adjustsFontSizeToFitWidth = YES;
        [tmp addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [industryButtonArr addObject:tmp];
        [_contentScro addSubview:tmp];
        nCount++;
    }

    [_contentScro setContentSize:CGSizeMake(self.frame.size.width-2*LeftRightPadding, (row+1)*(btnHeight+15))];
}

-(void)buttonClick:(UIButton *)sender
{
    [sender setSelected:YES];
    
    if (selectedIndex == sender.tag) {
        return;
    }
    
    if (selectedIndex == -1) {
        selectedIndex = (int)sender.tag;
        [industryB setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        _industryId = industryCategory[selectedIndex].ID;
    }
    else{
        [industryButtonArr[selectedIndex] setSelected:NO];
        selectedIndex = (int)sender.tag;
        [industryB setTitle:sender.titleLabel.text forState:UIControlStateNormal];
        _industryId = industryCategory[selectedIndex].ID;
    }
    [_gouImage setCenter:CGPointMake(sender.x+sender.width-5, sender.y+5)];
    [_contentScro bringSubviewToFront:_gouImage];
    return;
}

- (void)resetSubView
{
    for (UIView *tmp in industryButtonArr) {
        [tmp removeFromSuperview];
    }
    [_gouImage setCenter:CGPointMake(-100, -100)];
    selectedIndex = -1;
}

-(void)clearValue
{
    _industryId=nil;
}

-(NSString *)alertMsg
{
    if (selectedIndex==-1) {
        return @"请选择行业";
    }
    else
        return @"";
}
@end
