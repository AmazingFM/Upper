//
//  UPCells.m
//  Upper
//
//  Created by 张永明 on 16/5/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPCells.h"
#import "UPTheme.h"
#import "UPGlobals.h"
#import "UPTextView.h"
#import "DrawSomething.h"
#import "UPTools.h"

@implementation UPBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        self.backgroundView=nil;
        //        self.backgroundColor=[UIColor clearColor];
        //        self.contentView.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    _item = item;
}

-(void)updateTheme{
}

@end

@implementation UPTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = kUPThemeMinFont;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    if ([item isKindOfClass:[UPTitleCellItem class]]) {
        UPTitleCellItem *cellItem = (UPTitleCellItem *)item;
        _titleLabel.text = cellItem.title;
        CGSize size = SizeWithFont(cellItem.title, kUPThemeMinFont);
        _titleLabel.frame = CGRectMake(15, 0, size.width, cellItem.cellHeight);
        _titleLabel.textColor = [UIColor colorWithWhite:0.667 alpha:0.7];
    }
    self.backgroundColor = [UIColor clearColor];
}

@end

@implementation UPDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.detailTextLabel.font = kUPThemeMinFont;
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    if ([item isKindOfClass:[UPDetailCellItem class]]) {
        UPDetailCellItem *detailItem = (UPDetailCellItem *)item;
        self.detailTextLabel.text = detailItem.detail;
        if (detailItem.detailColor) {
            self.detailTextLabel.textColor = detailItem.detailColor;
        }
    }
    if (item.cellHeight == 0) {
        self.detailTextLabel.hidden = YES;
    } else {
        self.detailTextLabel.hidden = NO;
    }
    
    self.backgroundColor = [UIColor clearColor];
}

@end

@interface UPSwitchCell()
{
    UISwitch *_switchView;
}
@end

@implementation UPSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        self.accessoryView = _switchView;
    }
    return self;
}

- (void)switchChanged:(UISwitch *)switchView
{
    UPSwitchCellItem *switchItem = (UPSwitchCellItem *)self.item;
    switchItem.isOn = switchView.isOn;
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchOn:withIndexPath:)]) {
        [self.delegate switchOn:switchItem.isOn withIndexPath:switchItem.indexPath];
    }
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPSwitchCellItem *switchItem = (UPSwitchCellItem *)item;
    _switchView.on = switchItem.isOn;
    
    _switchView.enabled = switchItem.isLock;
    if (item.cellHeight == 0) {
        _switchView.hidden = YES;
    } else {
        _switchView.hidden = NO;
    }
    _switchView.onTintColor = kUPThemeMainColor;
}
@end



@interface UPComboxCell() <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UIButton *_hideBtn;
    UIView *_panelView;
}
@end

@implementation UPComboxCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _comboBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_comboBtn setTitleColor:RGBCOLOR(80,120,200) forState:UIControlStateNormal];
        _comboBtn.titleLabel.font = kUPThemeMinFont;
        _comboBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        _comboBtn.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        [_comboBtn addTarget:self action:@selector(showComboxList:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_comboBtn];
        
    }
    return self;
}

-(void)setItem:(UPBaseCellItem *)item{
    [super setItem:item];
    if([item isKindOfClass:[UPComboxCellItem class]]){
        UPComboxCellItem* comboxItem=(UPComboxCellItem*)item;
        [_comboBtn setTitle:[comboxItem selectedText] forState:UIControlStateNormal];
        [_comboBtn setTitle:[comboxItem selectedText] forState:UIControlStateHighlighted];
    }
    _comboBtn.frame=item.more?UPCellMoreRightWithWidth(item.cellWidth):UPCellRightWithWidth(item.cellWidth);
    _comboBtn.contentHorizontalAlignment=item.more?UIControlContentHorizontalAlignmentRight:UIControlContentHorizontalAlignmentLeft;
    if(item.cellHeight==0){
        _comboBtn.hidden=YES;
    }else {
        _comboBtn.hidden=NO;
    }
}

-(UIView*)windowView{
    return g_mainWindow;
}

-(void)dealloc{
    [_hideBtn removeFromSuperview];
    [_panelView removeFromSuperview];
}

-(void)showComboxList:(UIButton*)btn{
    //TODO 实现pop列表显示
    UPComboxCellItem* comboxItem=(UPComboxCellItem*)self.item;
    
    if (comboxItem.comboxType == UPComboxTypeActionSheet) {
        UIActionSheet* comboxSheet=[[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"选择%@",comboxItem.title]
                                                               delegate:self
                                                      cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        [comboxItem.comboxTitles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [comboxSheet addButtonWithTitle:obj];
        }];
        [comboxSheet addButtonWithTitle:@"取消"];
        [comboxSheet showFromRect:CGRectMake(0,0,btn.center.x,btn.center.y) inView:btn animated:YES];
    } else if (comboxItem.comboxType==UPComboxTypePicker) {
        if (_panelView==nil) {
            _hideBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            _hideBtn.alpha=0.1f;
            _hideBtn.backgroundColor=[UIColor lightGrayColor];
            [_hideBtn addTarget:self action:@selector(dismissPanelView) forControlEvents:UIControlEventTouchUpInside];
            _hideBtn.hidden = YES;
            
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kUPHBorder, 0, ScreenWidth-4*kUPHBorder, 150)];
            pickerView.delegate = self;
            pickerView.dataSource = self;
            
            UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
            confirm.frame = CGRectMake(kUPHBorder, 148, ScreenWidth-4*kUPHBorder, 44);
            [confirm setTitle:@"确认" forState:UIControlStateNormal];
            confirm.backgroundColor = [UIColor blueColor];
            confirm.layer.cornerRadius = 5.0f;
            [confirm addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
            _panelView = [[UIView alloc] initWithFrame:CGRectMake(kUPHBorder, ScreenHeight, ScreenWidth-2*kUPHBorder, 200)];
            _panelView.backgroundColor = [UIColor whiteColor];
            _panelView.layer.cornerRadius=5.0f;
            _panelView.layer.masksToBounds=YES;
            
            [_panelView addSubview:pickerView];
            [_panelView addSubview:confirm];
            
            if(self.windowView){
                [self.windowView addSubview:_hideBtn];
                [self.windowView addSubview:_panelView];
            }
        }
        [UIView animateWithDuration:0.3f animations:^{
            _hideBtn.hidden=NO;
            CGRect panelFrame=_panelView.frame;
            panelFrame.origin.y-=_panelView.frame.size.height;
            _panelView.frame=panelFrame;
        } completion:^(BOOL finished) {
        }];
    }
}

-(void)confirmClicked{
    [self dismissPanelView];
}

-(void)dismissPanelView{
    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden=YES;
        CGRect panelFrame=_panelView.frame;
        panelFrame.origin.y+=panelFrame.size.height;
        _panelView.frame=panelFrame;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark UIPickerDelegate, UIPickerDataSource
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    UPComboxCellItem *comboxItem = (UPComboxCellItem *)self.item;
    
    return [comboxItem.comboxTitles count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    UPComboxCellItem *comboxItem = (UPComboxCellItem *)self.item;
    return comboxItem.comboxTitles[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    UPComboxCellItem *comboxItem = (UPComboxCellItem *)self.item;
    [comboxItem setSelectedIndex:row];
    [_comboBtn setTitle:[comboxItem selectedText] forState:UIControlStateNormal];
    [_comboBtn setTitle:[comboxItem selectedText] forState:UIControlStateHighlighted];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(comboxSelected:withIndexPath:)]){
        [self.delegate comboxSelected:row withIndexPath:comboxItem.indexPath];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel) {
        pickerLabel = [[UILabel alloc] init];
        CGSize size = [pickerView rowSizeForComponent:component];
        pickerLabel.size = size;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.font = [UIFont systemFontOfSize:18];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


#pragma mark UIActionSheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UPComboxCellItem* comboxItem=(UPComboxCellItem*)self.item;
    if(buttonIndex>=0){
        if(buttonIndex<[comboxItem.comboxTitles count]){
            [comboxItem setSelectedIndex:buttonIndex];
            
            [_comboBtn setTitle:[comboxItem selectedText] forState:UIControlStateNormal];
            [_comboBtn setTitle:[comboxItem selectedText] forState:UIControlStateHighlighted];
            
            if(self.delegate&&[self.delegate respondsToSelector:@selector(comboxSelected:withIndexPath:)]){
                [self.delegate comboxSelected:buttonIndex withIndexPath:comboxItem.indexPath];
            }
        }
    }
}

@end

@implementation UPImageDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imageDetail = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageDetail setContentMode:UIViewContentModeScaleToFill];
        _imageDetail.tag = 100;
        
        _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchView addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        _switchView.tag = 101;

        _detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLab.tag = 102;
        
        _titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLab.backgroundColor = [UIColor clearColor];

        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        
         _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.borderColor = [UIColor grayColor].CGColor;
        _backView.layer.cornerRadius = 5.0f;
        [_backView addSubview:_titleLab];
        [self addSubview:_backView];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPImageDetailCellItem *cellItem = (UPImageDetailCellItem *)item;
    
    _backView.frame = UPCellDefineWithWidth(cellItem.cellWidth, cellItem.cellHeight);
    _titleLab.frame =CGRectMake(5, 0, 150, _backView.height);
    _titleLab.text = cellItem.title;
    
    switch (cellItem.style) {
        case UPItemStyleUserImg:
        case UPItemStyleUserQrcode:
            if (![_backView viewWithTag:100]) {
                [_backView addSubview:_imageDetail];
            }
            
            if (cellItem.style==UPItemStyleUserImg) {
                _imageDetail.frame = CGRectMake(_backView.width-_backView.height-13, 4, _backView.height-8, _backView.height-8);
                _imageDetail.layer.cornerRadius = (_backView.height-8)/2;
            } else {
                _imageDetail.frame = CGRectMake(_backView.width-_backView.height-11, 8, _backView.height-16, _backView.height-16);
            }
            _imageDetail.layer.masksToBounds = YES;
            if (cellItem.imageUrl.length>0) {
                [[SDImageCache sharedImageCache] removeImageForKey:cellItem.imageUrl];
                [_imageDetail sd_setImageWithURL:[NSURL URLWithString:cellItem.imageUrl] placeholderImage:[UIImage imageNamed:cellItem.defaultName] options:SDWebImageRefreshCached];
//                NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:cellItem.imageUrl] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//                    //下载完成后获取数据 此时已经自动缓存到本地，下次会直接从本地缓存获取，不再进行网络请求
//                    NSData * data = [NSData dataWithContentsOfURL:location];
//                    //回到主线程
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        
//                        //设置图片      
//                        _imageDetail.image = [UIImage imageWithData:data];
//                    });
//                    
////                    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:[NSString stringWithFormat:@"/%@", response.suggestedFilename]];
////                    _imageDetail.image = [UIImage imageWithContentsOfFile:fullPath];
//                }];
//                [downloadTask resume];
            } else if (cellItem.defaultName.length>0) {
                [_imageDetail setImage:[UIImage imageNamed:cellItem.defaultName]];
            }
            break;
        case UPItemStyleUserAnonymous:
            self.accessoryView = _switchView;
            _switchView.on = cellItem.isSwitchOn;
            break;
        default:
            break;
    }
    

    if (cellItem.detail!=nil && cellItem.detail.length>0) {
        if (![_backView viewWithTag:102]) {
            [_backView addSubview:_detailLab];
        }
        _detailLab.frame= CGRectMake(_backView.width-30-200, 0, 200, _backView.height);
        _detailLab.textAlignment = NSTextAlignmentRight;
        _detailLab.text = cellItem.detail;
        _detailLab.font = [UIFont systemFontOfSize:15.0f];
        _detailLab.textColor = [UIColor grayColor];
        _detailLab.backgroundColor = [UIColor clearColor];
    }
}

- (void)switchChanged:(UISwitch *)switchView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchOn:withIndexPath:)]) {
        [self.delegate switchOn:switchView.isOn withIndexPath:self.item.indexPath];
    }
}

-(void)updateTheme{
}

@end

@implementation UPButtonCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _button=[UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.contentMode = UIViewContentModeScaleToFill;
        
        [self addSubview:_button];
        [self addSubview:_imgView];
    }
    return self;
}

-(void)buttonClicked:(UIButton*)btn{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(buttonClicked:withIndexPath:)]){
        [self.delegate buttonClicked:btn withIndexPath:self.item.indexPath];
    }
}

-(void)setItem:(UPBaseCellItem *)item{
    [super setItem:item];
    if([item isKindOfClass:[UPButtonCellItem class]]){
        UPButtonCellItem* btnItem=(UPButtonCellItem*)item;
        if (btnItem.btnStyle==UPBtnStyleImage) {
            if (btnItem.defaultImage) {
                _imgView.frame = CGRectMake(0,0,item.cellWidth/5,item.cellWidth/5);
                _imgView.center = CGPointMake(item.cellWidth/2, item.cellHeight/2);
                _imgView.image = btnItem.btnImage;
            } else {
                _imgView.frame = CGRectMake(0,0,item.cellWidth,item.cellHeight);
                _imgView.image = btnItem.btnImage;
            }
        } else {
            [_button setTitle:btnItem.btnTitle forState:UIControlStateNormal];
        }
        _button.backgroundColor=btnItem.tintColor;
    }
    _button.frame=CGRectMake(0,0,item.cellWidth,item.cellHeight);
    if(item.cellHeight==0){
        _button.hidden=YES;
    }else {
        _button.hidden=NO;
    }
}


@end

@interface UPDateCell(){
    UIButton*       _dateBtn;
    UIDatePicker*   _datePickerView;
    UIView*         _datePanelView;
    UIButton*       _hideBtn;
    
    NSDateFormatter* _dateFormatter;

}
@end
@implementation UPDateCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _dateBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn setTitleColor:kUPThemeMainColor forState:UIControlStateNormal];
        _dateBtn.titleLabel.font = kUPThemeMinFont;
        _dateBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [_dateBtn addTarget:self action:@selector(showDatePanel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dateBtn];
    }
    return self;
}

-(void)setItem:(UPBaseCellItem *)item{
    [super setItem:item];
    if([item isKindOfClass:[UPDateCellItem class]]){
        UPDateCellItem* dateItem=(UPDateCellItem*)item;
        [_dateBtn setTitle:dateItem.date forState:UIControlStateNormal];
    }
    CGRect defaultFrame=UPCellRightWithWidth(item.cellWidth);
    _dateBtn.frame=defaultFrame;
    if(item.cellHeight==0){
        _dateBtn.hidden=YES;
    }else {
        _dateBtn.hidden=NO;
    }
}


-(UIView*)windowView{
    return g_mainWindow;
}

-(void)dealloc{
    [_hideBtn removeFromSuperview];
    [_datePanelView removeFromSuperview];
}


-(void)showDatePanel:(UIButton*)btn{
    if(_datePickerView==nil){
        _hideBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,ScreenWidth,kUPMainViewHeight)];
        _hideBtn.alpha=0.1f;
        _hideBtn.backgroundColor=[UIColor lightGrayColor];
        [_hideBtn addTarget:self action:@selector(dismissDatePanel) forControlEvents:UIControlEventTouchUpInside];
        
        _datePickerView=[[UIDatePicker alloc] initWithFrame:CGRectMake(kUPThemeBorder,0,ScreenWidth-2*kUPThemeBorder,220)];
        _datePickerView.datePickerMode=UIDatePickerModeDate;
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        _datePickerView.locale = locale;
        [_datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
        
        UIButton* confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitle:@"确认" forState:UIControlStateHighlighted];
        confirmBtn.backgroundColor= RGBCOLOR(80,120,200);;
        confirmBtn.frame=CGRectMake(kUPThemeBorder,218,ScreenWidth-4*kUPThemeBorder,44);
        [confirmBtn addTarget:self action:@selector(confirmClicked) forControlEvents:UIControlEventTouchUpInside];
        confirmBtn.layer.cornerRadius=kUPThemeCornerRadius;
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:kUPDateFormater];
        
        _datePanelView=[[UIView alloc] initWithFrame:CGRectMake(kUPThemeBorder,ScreenHeight,ScreenWidth-2*kUPThemeBorder, 270)];
        _datePanelView.backgroundColor=[UIColor whiteColor];
        _datePanelView.layer.cornerRadius=kUPThemeCornerRadius;
        _datePanelView.layer.masksToBounds=YES;
        [_datePanelView addSubview:_datePickerView];
        [_datePanelView addSubview:confirmBtn];
        
        if(self.windowView){
            [self.windowView addSubview:_hideBtn];
            [self.windowView addSubview:_datePanelView];
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kUPDateFormater];
    
    if(_dateBtn.titleLabel.text.length>=8&&![_dateBtn.titleLabel.text isEqualToString:@"选择日期"]){
        NSDate* date = [_dateFormatter dateFromString:_dateBtn.titleLabel.text];
        [_datePickerView setDate:date];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden=NO;
        CGRect dateFrame=_datePanelView.frame;
        dateFrame.origin.y-=_datePanelView.frame.size.height;
        _datePanelView.frame=dateFrame;
    } completion:^(BOOL finished) {
    }];
}

-(void)confirmClicked{
    [self datePickerChanged:_datePickerView];
    [self dismissDatePanel];
}

-(void)dismissDatePanel{
    [UIView animateWithDuration:0.3f animations:^{
        _hideBtn.hidden=YES;
        CGRect dateFrame=_datePanelView.frame;
        dateFrame.origin.y+=dateFrame.size.height;
        _datePanelView.frame=dateFrame;
    } completion:^(BOOL finished) {
        
    }];
}

-(NSDate*)dateWithValue:(NSString*)value{
    NSDateFormatter* formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:kUPDateFormater];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [formatter dateFromString:value];
}

-(void)datePickerChanged:(UIDatePicker*)datePicker{
    NSString* dateValue=[_dateFormatter stringFromDate:datePicker.date];
    [_dateBtn setTitle:dateValue forState:UIControlStateNormal];
    [_dateBtn setTitle:dateValue forState:UIControlStateHighlighted];
    if([self.item isKindOfClass:[UPDateCellItem class]]){
        UPDateCellItem* dateItem=(UPDateCellItem*)self.item;
        dateItem.date=dateValue;
        if(self.delegate&&[self.delegate respondsToSelector:@selector(viewValueChanged:withIndexPath:)]){
            [self.delegate viewValueChanged:dateValue withIndexPath:dateItem.indexPath];
        }
    }
}

@end

@implementation UPButtonDatePickerCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _dateValue = [UPTheme getSpecialDate:[UPTheme getCurDate]];
        
        _dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateBtn setBackgroundColor:[UIColor clearColor]];
        [_dateBtn addTarget:self action:@selector(showDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_dateBtn];
        
        _dateLab = [[UILabel alloc] initWithFrame:self.frame];
        _dateLab.backgroundColor = [UIColor clearColor];
        _dateLab.textColor = [UIColor whiteColor];
        _dateLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:_dateLab];
    }
    return self;
}

-(void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    float width = item.cellWidth;
    CGRect rTemp = _titleLabel.frame;
    
    _dateBtn.frame = CGRectMake(rTemp.origin.x+rTemp.size.width, rTemp.origin.y, width-rTemp.origin.x-rTemp.size.width-kUPCellHBorder, rTemp.size.height);
    _dateLab.frame = CGRectMake(rTemp.origin.x+rTemp.size.width, rTemp.origin.y, width-rTemp.origin.x-rTemp.size.width-kUPCellHBorder, rTemp.size.height);
    _dateLab.textColor=kUPThemeMainColor;
    _dateLab.text = _dateValue;
    
    [self setCellItemValue:_dateValue];
}

-(void)setCellItemValue:(NSString *)date
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(datepickerSelected:)])
    {
        [self.delegate datepickerSelected:date];
    }
}

- (NSString *)getSpecialDate:(NSString *)date
{
    return [date stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

-(void)dismissDatePopover:(UIButton *)btn
{
    [_datePopoverController dismissPopoverAnimated:YES];
}

-(void)datePickerChanged:(UIDatePicker *)datePicker
{
    NSString* dateValue=[_dateFormatter stringFromDate:datePicker.date];
    _dateValue = [UPTheme getSpecialDate:dateValue];
    _dateLab.text = _dateValue;
    [self setCellItemValue:_dateValue];
}

-(void)showDatePickerView:(UIButton *)btn
{
    UIDatePicker *_datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,0,320,220)];
    _datePickerView.datePickerMode=UIDatePickerModeDate;
    [_datePickerView addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    UIViewController* popController=[[UIViewController alloc] init];
    [popController.view addSubview:_datePickerView];
    popController.view.frame=CGRectMake(0,0,320,260);
    
    UIButton* confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateHighlighted];
    confirmBtn.backgroundColor=kUPThemeMainColor;
    confirmBtn.frame=CGRectMake(0,218,320,44);
    [popController.view addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(dismissDatePopover:) forControlEvents:UIControlEventTouchUpInside];
    
    _datePopoverController=[[UIPopoverController alloc] initWithContentViewController:popController];
    _datePopoverController.popoverContentSize=CGSizeMake(320,260);
    
    [_datePopoverController presentPopoverFromRect:btn.bounds
                                            inView:btn
                          permittedArrowDirections:UIPopoverArrowDirectionUp
                                          animated:YES];
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:kUPDateFormater];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:kUPDateFormater];
    NSString *dateString = [UPTheme getCurDate];
    NSDate* date = [formatter dateFromString:dateString];
    [_datePickerView setDate:date];
}

@end

@interface UPOnlyFieldCell() <UITextFieldDelegate>

@end

@implementation UPOnlyFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (g_nOSVersion>=7) {
            _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        }
        [_textField setKeyboardType:UIKeyboardTypeDefault];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font= kUPThemeSmallFont;
        _textField.returnKeyType=UIReturnKeyDone;
        [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
        _textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        _textField.delegate=self;
        [self addSubview:_textField];
    }
    return self;
}

-(void)setItem:(UPBaseCellItem *)item{
    [super setItem:item];
    UPOnlyFieldCellItem* fieldItem=(UPOnlyFieldCellItem*)item;
    _textField.placeholder=fieldItem.placeholder;
    if(![_textField.text isEqualToString:fieldItem.fieldText]||fieldItem.fieldText.length==0){
        _textField.text=fieldItem.fieldText;
    }
    _textField.returnKeyType=UIReturnKeyDone;
    
    _textField.frame = CGRectMake(10, 0, fieldItem.cellWidth-20, fieldItem.cellHeight);

    if(item.cellHeight==0){
        _textField.hidden=YES;
    }else {
        _textField.hidden=NO;
    }
}

//字符控制
#pragma mark -
#pragma mark UITextFieldDelegate

-(void)textFieldDone:(UITextField*)textField{
    [textField resignFirstResponder];
}

-(void)textFieldChanged:(UITextField*)textField
{
    UPFieldCellItem* fieldItem=(UPFieldCellItem*)self.item;
    fieldItem.fieldText=textField.text;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(viewValueChanged:withIndexPath:)]){
        [self.delegate viewValueChanged:_textField.text withIndexPath:fieldItem.indexPath];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered
{
//    unichar c = [textEntered characterAtIndex:[textEntered length]-1];
//    if(c==0||c=='\n'){
//        return YES;
//    }
//    UPFieldCellItem* fieldItem=(UPFieldCellItem*)self.item;
//    int actionLen=fieldItem.actionLen;
//    if(actionLen>0){
//        if([textField.text length]+[textEntered length]>actionLen){
//            return NO;
//        }
//    }
//    
//    if(fieldItem.fieldType!=UPFieldTypeUnlimited){
//        NSCharacterSet *cs  = nil;
//        BOOL isMatch=NO;
//        if(fieldItem.fieldType==UPFieldTypeAmount){
//            isMatch=YES;
//            cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
//        }else if(fieldItem.fieldType==UPFieldTypeNumber){
//            cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
//        }else if(fieldItem.fieldType==UPFieldTypeCharater){
//            cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
//        }
//        NSString *filtered = [[textEntered componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
//        BOOL basicTest = [textEntered isEqualToString:filtered];
//        //数字校验
//        
//        if(isMatch){
//            NSString *temp;
//            //        NSString *regex=@"^\\d*(\\d+)?$";
//            NSString *regex=@"^\\d*(\\d+\\.\\d*)?$";
//            temp = [textField.text stringByReplacingCharactersInRange:range withString:textEntered];
//            NSPredicate *filter=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//            isMatch=[filter evaluateWithObject:temp];
//            //数字校验
//            return (basicTest && isMatch);
//        }else {
//            return basicTest;
//        }
//    }
//    
    return YES;
    
}

@end

@interface UPFieldCell() <UITextFieldDelegate>

@end

@implementation UPFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (g_nOSVersion>=7) {
            _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        }
        [_textField setKeyboardType:UIKeyboardTypeDefault];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font= kUPThemeMinFont;
        _textField.returnKeyType=UIReturnKeyDone;
        [_textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];

        _textField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        //        _textField.textColor=[UIColor redColor];
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        //        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventAllEditingEvents];
        [_textField addTarget:self action:@selector(textFieldDone:) forControlEvents:UIControlEventEditingDidEndOnExit];
        _textField.delegate=self;
        [self addSubview:_textField];
    }
    return self;
}

-(void)setFocus{
    if(!_textField.isEditing){
        [_textField becomeFirstResponder];
    }
}

-(void)setItem:(UPBaseCellItem *)item{
    [super setItem:item];
    UPFieldCellItem* fieldItem=(UPFieldCellItem*)item;
    _textField.placeholder=fieldItem.placeholder;
    if(![_textField.text isEqualToString:fieldItem.fieldText]||fieldItem.fieldText.length==0){
        _textField.text=fieldItem.fieldText;
    }
    _textField.returnKeyType=UIReturnKeyDone;
    
    _textField.secureTextEntry=fieldItem.secureTextEntry;
    
    if (fieldItem.detail!=nil && fieldItem.detail.length>0) {
        CGSize size = SizeWithFont(fieldItem.detail, kUPThemeMinFont);
        CGRect frame = UPCellRightWithWidth(item.cellWidth);
        frame.size.width = frame.size.width-size.width-kUPCellHBorder*2;
        _textField.frame = frame;
        
    } else {
        _textField.frame=UPCellRightWithWidth(item.cellWidth);
    }
    _textField.userInteractionEnabled=!fieldItem.userInteractionDisabled;
    if(item.cellHeight==0){
        _textField.hidden=YES;
    }else {
        _textField.hidden=NO;
    }
}

-(void)beginEditing:(UITextField*)textFeild{
//    if(self.delegate&&[self.delegate respondsToSelector:@selector(queryMaxVolumeExcept:)]){
//        [self.delegate queryMaxVolumeExcept:self.item.key];
//    }
}

//字符控制
#pragma mark -
#pragma mark UITextFieldDelegate

-(void)textFieldDone:(UITextField*)textField{
    [textField resignFirstResponder];
}

-(void)textFieldChanged:(UITextField*)textField
{
    UPFieldCellItem* fieldItem=(UPFieldCellItem*)self.item;
    fieldItem.fieldText=textField.text;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(viewValueChanged:withIndexPath:)]){
        [self.delegate viewValueChanged:_textField.text withIndexPath:fieldItem.indexPath];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)textEntered
{
    unichar c = [textEntered characterAtIndex:[textEntered length]-1];
    if(c==0||c=='\n'){
        return YES;
    }
    UPFieldCellItem* fieldItem=(UPFieldCellItem*)self.item;
    int actionLen=fieldItem.actionLen;
    if(actionLen>0){
        if([textField.text length]+[textEntered length]>actionLen){
            return NO;
        }
    }
    
    if(fieldItem.fieldType!=UPFieldTypeUnlimited){
        NSCharacterSet *cs  = nil;
        BOOL isMatch=NO;
        if(fieldItem.fieldType==UPFieldTypeAmount){
            isMatch=YES;
            cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
        }else if(fieldItem.fieldType==UPFieldTypeNumber){
            cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        }else if(fieldItem.fieldType==UPFieldTypeCharater){
            cs=[[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        }
        NSString *filtered = [[textEntered componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [textEntered isEqualToString:filtered];
        //数字校验
        
        if(isMatch){
            NSString *temp;
            //        NSString *regex=@"^\\d*(\\d+)?$";
            NSString *regex=@"^\\d*(\\d+\\.\\d*)?$";
            temp = [textField.text stringByReplacingCharactersInRange:range withString:textEntered];
            NSPredicate *filter=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
            isMatch=[filter evaluateWithObject:temp];
            //数字校验
            return (basicTest && isMatch);
        }else {
            return basicTest;
        }
    }
    
    return YES;

}
@end

@interface UPTextCell() <UITextViewDelegate>
@property (nonatomic, retain) UPTextView *textV;
@end

@implementation UPTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textV = [[UPTextView alloc] initWithFrame:CGRectZero];
        self.textV.font = kUPThemeMinFont;
        self.textV.returnKeyType=UIReturnKeyDone;
        self.textV.delegate = self;
        [self.textV setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textV setAutocapitalizationType:UITextAutocapitalizationTypeNone];

        [self addSubview:self.textV];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    UPTextCellItem *cellItem = (UPTextCellItem*)item;
    
    self.textV.frame = CGRectMake(5, kUPCellVBorder, cellItem.cellWidth-10, cellItem.cellHeight-2*kUPCellVBorder);
    self.textV.placeholder = cellItem.placeholder;
    self.textV.text = cellItem.fieldText;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UPTextCellItem *cellItem = (UPTextCellItem *)self.item;
    cellItem.fieldText = textView.text;
    if(self.delegate&&[self.delegate respondsToSelector:@selector(viewValueChanged:withIndexPath:)]){
        [self.delegate viewValueChanged:textView.text withIndexPath:cellItem.indexPath];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        if ([self.delegate respondsToSelector:@selector(resignKeyboard)]) {
            [self.delegate resignKeyboard];
        }
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    
    return YES;
}

@end

@implementation UPInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = RGBCOLOR(200, 0, 0);
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = kUPThemeSmallFont;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.textColor = RGBCOLOR(0, 0, 0);
        
        hLine = [[UIView alloc] initWithFrame:CGRectZero];
        hLine.backgroundColor = RGBCOLOR(240, 240, 240);

        detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentLeft;
        detailLabel.numberOfLines = 0;
        detailLabel.textColor = RGBCOLOR(110, 110, 110);
        
        tipsBackView = [[UIView alloc] initWithFrame:CGRectZero];
        tipsBackView.backgroundColor = RGBCOLOR(240, 240, 240);
        
        tipsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tipsLabel.font = kUPThemeMinFont;
        tipsLabel.backgroundColor = [UIColor clearColor];
        tipsLabel.textAlignment = NSTextAlignmentLeft;
        tipsLabel.numberOfLines = 0;
        tipsLabel.textColor = RGBCOLOR(160, 160, 160);
        
        [self addSubview:line];
        [self addSubview:titleLabel];
        [self addSubview:hLine];
        [self addSubview:detailLabel];
        [self addSubview:tipsBackView];
        [tipsBackView addSubview:tipsLabel];
    }
    return self;
}

- (void)setItem:(UPBaseCellItem *)item
{
    [super setItem:item];
    
    UPInfoCellItem *cellItem = (UPInfoCellItem *)item;
    
    CGFloat hMargin = 10;
    CGFloat vMargin = 5;
    
    CGFloat offsetx = hMargin;
    CGFloat offsety = 0;
    
    CGSize size = SizeWithFont(@"标题", kUPThemeSmallFont);
    size.height-=2;
    line.frame = CGRectMake(offsetx, (30-size.height)/2, 1, size.height);
    
    titleLabel.frame = CGRectMake(offsetx+8, offsety, cellItem.cellWidth-30, 30);
    titleLabel.text = cellItem.title;
    
    hLine.frame = CGRectMake(0, 29, cellItem.cellWidth, 1);
    
    offsety +=30;
    
    size = [UPTools sizeOfString:cellItem.detail withWidth:cellItem.cellWidth-2*hMargin font:[UIFont systemFontOfSize:13]];
    detailLabel.frame = CGRectMake(hMargin, offsety+vMargin, cellItem.cellWidth-2*hMargin, size.height);
    detailLabel.text = cellItem.detail;
    
    if (cellItem.tips) {
        offsety += size.height+vMargin;
        
        size = [UPTools sizeOfString:cellItem.tips withWidth:cellItem.cellWidth-2*hMargin-2*5 font:kUPThemeMinFont];
        tipsLabel.frame = CGRectMake(5, vMargin, cellItem.cellWidth-2*hMargin-2*5 , size.height);
        tipsLabel.text = cellItem.tips;
        
        tipsBackView.frame = CGRectMake(hMargin, offsety+vMargin, cellItem.cellWidth-2*hMargin, size.height+2*vMargin);
    }
}

@end

@implementation UPCells

@end
