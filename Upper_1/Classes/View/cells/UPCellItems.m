//
//  UPCellItems.m
//  Upper
//
//  Created by 张永明 on 16/5/7.
//  Copyright © 2016年 aries365.com. All rights reserved.
//

#import "UPCellItems.h"
#import "UPTheme.h"

@implementation UPBaseCellItem

- (id)init
{
    self = [super init];
    if (self) {
        self.cellHeight = kUPCellDefaultHeight;
    }
    return self;
}

- (void)reset{}
- (id)value {return @"";}
- (void)fillWithValue:(NSString *)value {}
@end

@implementation UPTitleCellItem
@end

@implementation UPDetailCellItem

- (void)reset
{
    self.detail = @"";
}

- (void)fillWithValue:(NSString *)value
{
    self.detail = value;
}

- (id)value
{
    return self.detail;
}

@end

@implementation UPComboxCellItem

-(void)setSelectedIndex:(int)selectedIndex{
    _selectedIndex=selectedIndex;
    self.detail=self.selectedText;
}
-(NSString*)selectedText{
    if(self.selectedIndex<self.comboxTitles.count){
        NSString* text=[self.comboxTitles objectAtIndex:self.selectedIndex];
        return text;
    }else {
        return @"";
    }
}

-(NSArray*)comboxTitles{
    return self.comboxItems;
}

-(id)value{
    if(self.style&UPItemStyleIndex){
        return [NSString stringWithFormat:@"%i",_selectedIndex];
    }else{
        return [self selectedText];
    }
}

-(void)fillWithValue:(NSString*)value{
    [self.comboxItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isEqualToString:value]){
            [self setSelectedIndex:(int)idx];
            *stop=YES;
        }
    }];
}
-(void)reset{
    [self setSelectedIndex:self.defaultIndex];
}

@end


@implementation UPFieldCellItem
- (id)init
{
    self = [super init];
    if (self) {
        self.style |= UPItemStyleInput;
        self.actionLen = -1;
    }
    return self;
}

- (void)fillWithValue:(NSString *)value
{
    self.fieldText = value;
}

- (id)value
{
    if (self.userInteractionDisabled) {
        return @"";
    } else {
        return self.fieldText;
    }
}

- (void)reset
{
    if (self.userInteractionDisabled) {
        self.fieldText = @"无需填写";
    } else {
        self.fieldText = @"";
    }
}
@end

@implementation UPOnlyFieldCellItem

- (void)fillWithValue:(NSString *)value
{
    self.fieldText = value;
}

- (id)value
{
    return self.fieldText;
}


@end

@implementation UPTextCellItem
- (id)init
{
    self = [super init];
    if (self) {
        self.style |= UPItemStyleInput;
        self.actionLen = -1;
    }
    return self;
}

- (void)fillWithValue:(NSString *)value
{
    self.fieldText = value;
}

- (id)value
{
    if (self.userInteractionDisabled) {
        return @"";
    } else {
        return self.fieldText;
    }
}

- (void)reset
{
    if (self.userInteractionDisabled) {
        self.fieldText = @"无需填写";
    } else {
        self.fieldText = @"";
    }
}
@end

@implementation UPSwitchCellItem

- (id)value
{
    return self.isOn?@"1":@"0";
}

@end

@implementation UPImageDetailCellItem

- (id)init
{
    self = [super init];
    if (self) {
        self.defaultName = @"";
    }
    return self;
}

- (void)fillWithValue:(NSString *)value
{
    self.defaultName = value;
}

@end

@implementation  UPButtonCellItem

@end

@implementation UPDateCellItem

- (id)init
{
    self = [super init];
    if (self) {
        self.date = @"请选择日期";
    }
    return self;
}

- (id)value
{
    if ([self.date isEqualToString:@"请选择日期"]) {
        return @"";
    } else
    {
        return self.date;
    }
}

- (void)fillWithValue:(NSString *)value
{
    self.date = value;
}
@end

@implementation UPInfoCellItem
@end

@implementation UPCellItems

@end
