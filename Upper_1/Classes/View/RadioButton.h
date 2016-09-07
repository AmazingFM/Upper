//
//  RadioButton.h
//  UIRadioButton
//
//  Created by chen shaohong on 12-9-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//Protocol协议 ,声明了可以被任何类实现的方法
@protocol RadioButtonDelegate <NSObject>
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString*)groupId;
@end

//创建RadioButton继承UIView，里边有radio的组id，radio的索引，radio用到的自定义类型的Button
@interface RadioButton :UIView {
	NSString *_groupId;
    NSUInteger _index;
    UIButton *_button;
}



//RadioButton的属性 
@property(nonatomic,retain) NSString *groupId;
@property(nonatomic,assign) NSUInteger index;
@property(nonatomic,assign) float width;
@property(nonatomic,assign) float height;
@property(nonatomic,assign) NSString* text;
@property(nonatomic,assign) NSString* selectedIcon;
@property(nonatomic,assign) NSString* unselectedIcon;


//initWithGroupId始化（将每一个button添加到静态数组rb_instances中）方法
//addObserverForGroupId添加radio分组对象到静态字典rb_observers中的方法
-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index;
-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height;
-(void)handleButtonTap:(id)sender;
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer;
- (void)setIcon:(NSString *)selectedIcon andUnselected:(NSString *)unselectedIcon;
@end
