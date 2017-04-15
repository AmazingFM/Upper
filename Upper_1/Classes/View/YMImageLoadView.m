//
//  YMImageLoadView.m
//  IBTry
//
//  Created by 张永明 on 16/8/23.
//  Copyright © 2016年 Upper. All rights reserved.
//

#import "YMImageLoadView.h"
#import "UPGlobals.h"

#define imageH 75 // 图片高度
#define imageW 75 // 图片宽度
#define kMaxColumn 3 // 每行显示数量
#define deleImageWH 22 // 删除按钮的宽高
#define kAdeleImage @"close.png" // 删除按钮图片
#define kAddImage @"icon-addpic" // 添加按钮图片

#define HorizontalPadding 10
#define ImageLoadTag 1000

@interface YMImageLoadView() <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    NSInteger editTag;
}

@end
@implementation YMImageLoadView

- (instancetype)initWithFrame:(CGRect)frame withMaxCount:(int)nCount
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxCount = nCount;
        
        UIButton *btn = [self createButtonWithImage:kAddImage andSeletor:@selector(addNew:)];
        [self addSubview:btn];
    }
    return self;
}

// 添加新的控件
- (void)addNew:(UIButton *)btn
{
    // 标识为添加一个新的图片
    if (![self deleClose:btn]) {
        editTag = -1;
//        [self callImagePicker];
        [self openMenu];
    }
}

// 修改旧的控件
- (void)changeOld:(UIButton *)btn
{
    // 标识为修改(tag为修改标识)
    if (![self deleClose:btn]) {
        editTag = btn.tag;
//        [self callImagePicker];
        [self openMenu];
    }
}

// 删除"删除按钮"
- (BOOL)deleClose:(UIButton *)btn
{
    if (btn.subviews.count == 2) {
        [[btn.subviews lastObject] removeFromSuperview];
        [self stop:btn];
        return YES;
    }
    return NO;
}

// 调用图片选择器
- (void)callImagePicker
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
    } else
    {
        NSLog(@"模拟器无法打开照相机");
    }
}

// 根据图片名称或者图片创建一个新的显示控件
- (UIButton *)createButtonWithImage:(id)imageNameOrImage andSeletor : (SEL)selector
{
    UIImage *addImage = nil;
    if ([imageNameOrImage isKindOfClass:[NSString class]]) {
        addImage = [UIImage imageNamed:imageNameOrImage];
    }
    else if([imageNameOrImage isKindOfClass:[UIImage class]])
    {
        addImage = imageNameOrImage;
    }
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.layer.borderColor = RGBCOLOR(220, 220, 220).CGColor;
    addBtn.layer.borderWidth = 0.2;
    [addBtn setImage:addImage forState:UIControlStateNormal];
    [addBtn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = self.subviews.count;
    
    // 添加长按手势,用作删除.加号按钮不添加
    if(addBtn.tag != 0)
    {
        UILongPressGestureRecognizer *gester = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [addBtn addGestureRecognizer:gester];
    }
    return addBtn;
}

// 长按添加删除按钮
- (void)longPress : (UIGestureRecognizer *)gester
{
    if (gester.state == UIGestureRecognizerStateBegan)
    {
        UIButton *btn = (UIButton *)gester.view;
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.bounds = CGRectMake(0, 0, deleImageWH, deleImageWH);
        [dele setTitle: @"✕" forState:UIControlStateNormal];
        [dele setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        dele.backgroundColor = [UIColor redColor];
        [dele setContentMode:UIViewContentModeCenter];
        dele.layer.cornerRadius = deleImageWH/2;
        dele.layer.masksToBounds = YES;
        
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        dele.frame = CGRectMake(btn.frame.size.width - deleImageWH/2, -deleImageWH/2, dele.frame.size.width, dele.frame.size.height);
        [btn addSubview:dele];
        [self start : btn];
    }
}

// 长按开始抖动
- (void)start : (UIButton *)btn
{
    double angle1 = -5.0 / 180.0 * M_PI;
    double angle2 = 5.0 / 180.0 * M_PI;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(angle1),  @(angle2), @(angle1)];
    anim.duration = 0.25;
    // 动画的重复执行次数
    anim.repeatCount = MAXFLOAT;
    // 保持动画执行完毕后的状态
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    [btn.layer addAnimation:anim forKey:@"shake"];
}

// 停止抖动
- (void)stop : (UIButton *)btn{
    [btn.layer removeAnimationForKey:@"shake"];
}

// 删除图片
- (void)deletePic : (UIButton *)btn
{
    [self.images removeObject:[(UIButton *)btn.superview imageForState:UIControlStateNormal]];
    [btn.superview removeFromSuperview];
    if ([[self.subviews lastObject] isHidden]) {
        [[self.subviews lastObject] setHidden:NO];
    }
}

- (NSMutableArray *)images
{
    if (_images==nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

// 对所有子控件进行布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    int count = self.subviews.count;
    CGFloat btnW = imageW;
    CGFloat btnH = imageH;
    int maxColumn = kMaxColumn > self.frame.size.width / imageW ? self.frame.size.width / imageW : kMaxColumn;
    CGFloat marginX = (self.frame.size.width - maxColumn * btnW) / (maxColumn + 1);
    CGFloat marginY = marginX;
    for (int i = 0; i < count; i++) {
        UIButton *btn = self.subviews[i];
        CGFloat btnX = (i % maxColumn) * (marginX + btnW) + marginX;
        CGFloat btnY = (i / maxColumn) * (marginY + btnH) + marginY;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

#pragma mark take photo methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self localPhoto];
    } else if (buttonIndex==1) {
        [self takePhoto];
    }
}

#pragma mark take photo methods
- (void)openMenu
{
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVersion<8.0) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"上传活动图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册中获取",@"打开照相机", nil];
        [actionSheet showInView:self.window.rootViewController.view];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传活动图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"取消");
        }];
        [alertController addAction:action];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"从手机相册中获取" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction *action) {
                NSLog(@"从手机相册中获取");
                [self localPhoto];
            }];
            action;
        })];
        
        [alertController addAction:({
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction *action) {
                NSLog(@"打开照相机");
                [self takePhoto];
            }];
            action;
        })];
        
        [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
}

//开始拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
    } else
    {
        NSLog(@"模拟器无法打开照相机");
    }

}
//打开本地相册
- (void)localPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];
    picker.allowsEditing = YES;
    
    [self.window.rootViewController presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerController 代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (editTag == -1) {
        // 创建一个新的控件
        UIButton *btn = [self createButtonWithImage:image andSeletor:@selector(changeOld:)];
        [self insertSubview:btn atIndex:self.subviews.count - 1];
        [self.images addObject:image];
        if (self.subviews.count - 1 == self.maxCount) {
            [[self.subviews lastObject] setHidden:YES];
        }
    }
    else {
        // 根据tag修改需要编辑的控件
        UIButton *btn = (UIButton *)[self viewWithTag:editTag];
        int index = [self.images indexOfObject:[btn imageForState:UIControlStateNormal]];
        [self.images removeObjectAtIndex:index];
        [btn setImage:image forState:UIControlStateNormal];
        [self.images insertObject:image atIndex:index];
    }
    // 退出图片选择控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
}
@end
