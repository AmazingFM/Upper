//
//  RadioButton.m
//  UIRadioButton
//
//  Created by chen shaohong on 12-9-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

//内部调用的接口方法
@interface RadioButton()
-(void)defaultInit; //初始化
-(void)otherButtonSelected:(id)sender; //设置不选中
-(void)handleButtonTap:(id)sender;     //设置选择
@end

//实现RadioButton，作用是实现.h中 的具体方法与对象
@implementation RadioButton

//属性
@synthesize groupId=_groupId;
@synthesize index=_index;

//定义静态变量
static const NSUInteger kRadioButtonWidth=48;
static const NSUInteger kRadioButtonHeight=48;
static NSMutableArray *rb_instances=nil;
static NSMutableDictionary *rb_observers=nil;

//#pragma mark 是按功能模块进行划分的意思
#pragma mark - Observer
//添加observer，该方法再RadioButton.h中申明，为外部静态调用方法
+(void)addObserverForGroupId:(NSString*)groupId observer:(id)observer{
	//创建rb_observers对象
	if (!rb_observers) {
		rb_observers = [[NSMutableDictionary alloc] init];
	}
	
	//两个参数都存在，则将其添加到可变字典rb_observers中
	if ([groupId length]>0 && observer) {
		[rb_observers setObject:observer forKey:groupId];
	}
	
}

#pragma mark - Manage Instances
//注册实例,将RadioButton放到可变数组中
+(void)registerInstance:(RadioButton *)radioButton{
	//创建rb_instances对象
	if (!rb_instances) {
		rb_instances = [[NSMutableArray alloc] init];
	}
	//将radioButton添加到可变数组rb_instances中
	[rb_instances addObject:radioButton];
}

#pragma mark - Class level handler
//选中事件，主要设置选中的项，同时将同组中其他项设置为未选中状态
+(void)buttonSelected:(RadioButton *)radioButton{
	NSLog(@"==in buttonSelected==");
	//从rb_observers字典中取得radio的对象observer，id用来定义未知类型的对象
	if (rb_observers) {
		id observer = [rb_observers objectForKey:radioButton.groupId];
		//respondsToSelector: 方法来确认某个实例是否有某个方法
		//调用协议中的radioButtonSelectedAtIndex方法设置选中radio
		if (observer && [observer respondsToSelector:@selector(radioButtonSelectedAtIndex:inGroup:)]) {
			[observer radioButtonSelectedAtIndex:radioButton.index inGroup:radioButton.groupId];
		}
	}
	
	//从静态数组中取出radioButton
	if (rb_instances) {
		for (int i=0; i<[rb_instances count]; i++) {
			RadioButton *button = [rb_instances objectAtIndex:i];
			if(![button isEqual:radioButton] && [button.groupId isEqualToString:radioButton.groupId]){
				[button otherButtonSelected:radioButton];//设置其他radio非选中状态
			}
		}
	}
	
}

#pragma mark - Tap handling

-(void)handleButtonTap:(id)sender{
	NSLog(@"==in handleButtonTap==");
    [_button setSelected:YES];
    [RadioButton buttonSelected:self];
}

-(void)otherButtonSelected:(id)sender{
    // 如果button原来为选中状态，则设置为非选中状态
    if(_button.selected){
        [_button setSelected:NO];        
    }
}


#pragma mark - Object Lifecycle
//对象的生命周期，初始化radiobutton处理
-(id)initWithGroupId:(NSString*)groupId index:(NSUInteger)index{
	self = [self init];
    if (self) {
        _groupId = groupId;
        _index = index;
    }
	return  self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (void)setIcon:(NSString *)selectedIcon andUnselected:(NSString *)unselectedIcon
{
    self.selectedIcon = selectedIcon;
    self.unselectedIcon = unselectedIcon;
}

-(void)setWidth:(CGFloat)width andHeight:(CGFloat)height
{
    _width = width;
    _height = height;
}

-(void)defaultInit{
    // 定义 UIButton
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_button setSize:CGSizeMake(_width*0.8, _height*0.8)];
    [_button setCenter:CGPointMake(_width*0.5, _height*0.5)];
    _button.adjustsImageWhenHighlighted = NO;
    [_button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if (self.selectedIcon && self.unselectedIcon) {
        [_button setImage:[UIImage imageNamed:_selectedIcon] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:_unselectedIcon] forState:UIControlStateSelected];
    } else {
        [_button setImage:[UIImage imageNamed:@"radio_nor.png"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"radio_check.png"] forState:UIControlStateSelected];
    }

    [_button setTitle:self.text forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:14];

    //自定义button的点击事件handleButtonTap
	[_button addTarget:self action:@selector(handleButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_button];
    //将按钮添加的实例数组中
    [RadioButton registerInstance:self];
}

@end
