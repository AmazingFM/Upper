//
//  UPCells.h
//  Upper
//
//  Created by 张永明 on 16/5/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPCellItems.h"

#define kUPCellHeight 52
#define kUPCellHBorder   15
#define kUPCellVBorder   4

#define UPCellLeftWithWidth(cellWidth) CGRectMake(kUPCellHBorder,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+20,kUPCellHeight-2*kUPCellVBorder)
#define UPCellRightWithWidth(cellWidth) CGRectMake(cellWidth/2-30,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+30,kUPCellHeight-2*kUPCellVBorder)
#define UPCellFullWithWidth(cellWidth) CGRectMake(kUPCellHBorder,kUPCellVBorder,(cellWidth-2*kUPCellHBorder),kUPCellHeight-2*kUPCellVBorder)
#define UPCellDefineWithWidth(cellWidth,cellHeight) CGRectMake(kUPCellHBorder-5,1,(cellWidth-2*kUPCellHBorder+10),cellHeight-2*1)

#define UPCellMoreRightWithWidth(cellWidth) CGRectMake(cellWidth/2-40,kUPCellVBorder,(cellWidth-2*kUPCellHBorder)/2+20,kUPCellHeight-2*kUPCellVBorder)


@protocol UPCellDelegate <NSObject>

@optional
- (void)buttonClicked:(UIButton *)btn withIndexPath:(NSIndexPath *)indexPath;
- (void)textFieldChanged:(UITextField *)textField withIndexPath:(NSIndexPath *)indexPath;
- (void)comboxSelected:(int)selectedIndex withIndexPath:(NSIndexPath *)indexPath;
- (void)switchOn:(BOOL)isOn withIndexPath:(NSIndexPath *)indexPath;
- (void)viewValueChanged:(NSString*)value  withIndexPath:(NSIndexPath*)indexPath;
- (void)datepickerSelected:(NSString *)date;

- (void)resignKeyboard;
@end

@interface UPBaseCell :UITableViewCell
@property (nonatomic, retain) UPBaseCellItem *item;
@property (nonatomic, weak) id<UPCellDelegate> delegate;

- (void)updateTheme;
@end

@interface UPTitleCell : UPBaseCell
{
    UILabel *_titleLabel;
}
@end

@interface UPDetailCell : UPTitleCell{
}
@end

@interface UPSwitchCell :UPDetailCell
@end

@interface UPComboxCell :UPTitleCell
{
    UIButton* _comboBtn;
}
@end

@interface UPOnlyFieldCell : UPBaseCell
{
    UITextField *_textField;
}
@end

@interface UPFieldCell : UPDetailCell
{
    UITextField *_textField;
}
- (void)setFocus;
-(void)textFieldChanged:(UITextField*)textField;
-(void)beginEditing:(UITextField*)textFeild;
-(void)textFieldDone:(UITextField*)textField;
@end

@interface UPTextCell : UPBaseCell
{
    UITextView *_textView;
}


@end

@interface UPButtonCell :UPBaseCell
{
    UIButton *_button;
    UIImageView *_imgView;
}
@end

@interface UPDateCell :UPTitleCell
@end

@interface UPButtonDatePickerCell : UPTitleCell
{
    UIButton *_dateBtn;
    UILabel *_dateLab;
    NSDateFormatter *_dateFormatter;
    UIPopoverController *_datePopoverController;
}
@property (nonatomic, retain) NSString *dateValue;
@end

@interface UPImageDetailCell : UPTitleCell
{
    UIImageView *_imageDetail;
    UISwitch *_switchView;
    UILabel *_titleLab;
    UILabel *_detailLab;
    UIView *_backView;
}
@end

@interface UPInfoCell : UPBaseCell
{
    UIView *line;
    UILabel *titleLabel;
    
    UIView *hLine;
    UILabel *detailLabel;
    
    UIView *tipsBackView;
    UILabel *tipsLabel;
}

@end

@interface UPCells : NSObject
@end
