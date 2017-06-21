//
//  QRCodeController.m
//  eCarry
//  依赖于AVFoundation
//  Created by whde on 15/8/14.
//  Copyright (c) 2015年 Joybon. All rights reserved.
//

#import "QRCodeController.h"
#import <AVFoundation/AVFoundation.h>

#import "YMNetwork.h"
#import "Appdelegate.h"
#import "Info.h"
#import "UPTheme.h"
#import "MBProgressHUD+MJ.h"

#define kMargin 30
#define AUTH_ALERT_TAG (int)281821
//#define  ScreenHeight  [UIScreen mainScreen].bounds.size.width
//#define  ScreenWidth   [UIScreen mainScreen].bounds.size.height
@interface QRCodeController ()<AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
    int line_tag;
    UIView *highlightView;
    UIView *_scanWindow;
    
    NSString *userID;
}
@end

@implementation QRCodeController

/**
 *  @author Whde
 *
 *  viewDidLoad
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    [self instanceDevice];
}

/**
 *  @author Whde
 *
 *  配置相机属性
 */
- (void)instanceDevice{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    line_tag = 1872637;
    //获取摄像设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    NSError *error;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    CGFloat  scanWindowW = self.view.width - kMargin*2;
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin,  (self.view.center.y-scanWindowW/2), scanWindowW, scanWindowW)];
    CGRect scanCrop=[self getScanCrop:_scanWindow.bounds readerViewBounds:self.view.frame];
    output.rectOfInterest = scanCrop;

    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    } else {
        //摄像头不可用
        showDefaultAlert(@"提示", error.localizedDescription);
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView];
    
    [session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:nil];
    
    //开始捕获
    [session startRunning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [session startRunning];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [session stopRunning];
    [self removeAnimation];
    [self dismissOverlayView:self];
}

#pragma mark-> 获取扫描区域的比例关系
-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
    
}

/**
 *  @author Whde
 *
 *  监听扫码状态-修改扫描动画
 *
 *  @param keyPath
 *  @param object
 *  @param change
 *  @param context
 */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([object isKindOfClass:[AVCaptureSession class]]) {
        BOOL isRunning = ((AVCaptureSession *)object).isRunning;
        if (isRunning) {
            [self addAnimation];
        }else{
            [self removeAnimation];
        }
    }
}

/**
 *  @author Whde
 *
 *  获取扫码结果
 *
 *  @param captureOutput
 *  @param metadataObjects
 *  @param connection
 */
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex :0];

        //输出扫描字符串
        NSString *qrStr = metadataObject.stringValue;
        NSData *_decodedData = [[NSData alloc] initWithBase64EncodedString:qrStr options:NSDataBase64DecodingIgnoreUnknownCharacters];

        // 二维码格式 user_id=xxx
        qrStr = [[NSString alloc] initWithData:_decodedData encoding:NSUTF8StringEncoding];
        
        if ([qrStr rangeOfString:@"user_id="].location == NSNotFound) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无效的签到二维码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        } else {
            userID = [qrStr componentsSeparatedByString:@"="][1];
            [self startCheckRequest];
        }
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [session startRunning];
}

/**
 *  @author Whde
 *
 *  didReceiveMemoryWarning
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  @author Whde
 *
 *  创建扫码页面
 */
- (void)setOverlayPickerView
{
    //左侧的view
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMargin, ScreenHeight)];
    leftView.alpha = 0.5;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    //右侧的view
    UIImageView *rightView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-kMargin, 0, kMargin, ScreenHeight)];
    rightView.alpha = 0.5;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //最上部view
    UIImageView* upView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, 0, ScreenWidth-kMargin*2, (self.view.center.y-(ScreenWidth-kMargin*2)/2))];
    upView.alpha = 0.5;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //底部view
    UIImageView * downView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, (self.view.center.y+(ScreenWidth-kMargin*2)/2), (ScreenWidth-kMargin*2), (ScreenHeight-(self.view.center.y-(ScreenWidth-kMargin*2)/2)))];
    downView.alpha = 0.5;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UIImageView *centerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, ScreenWidth-60)];
    centerView.center = self.view.center;
    centerView.image = [UIImage imageNamed:@"scanrect"];
    centerView.contentMode = UIViewContentModeScaleAspectFit;
    centerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:centerView];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(upView.frame), ScreenWidth-kMargin*2, 2)];
    line.tag = line_tag;
    line.image = [UIImage imageNamed:@"scanline"];
    line.contentMode = UIViewContentModeScaleAspectFit;
    line.backgroundColor = [UIColor clearColor];
    [self.view addSubview:line];
    
    UILabel *msg = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMinY(downView.frame), ScreenWidth-60, 60)];
    msg.backgroundColor = [UIColor clearColor];
    msg.textColor = [UIColor whiteColor];
    msg.textAlignment = NSTextAlignmentCenter;
    msg.font = [UIFont systemFontOfSize:16];
    msg.text = @"将二维码放入框内,即可自动扫描";
    [self.view addSubview:msg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenWidth-100, ScreenWidth, 100)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    label.text = @"扫一扫,签到";
    [self.view addSubview:label];
    
}

/**
 *  @author Whde
 *
 *  添加扫码动画
 */
- (void)addAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    line.hidden = NO;
    CABasicAnimation *animation = [QRCodeController moveYTime:2 fromY:[NSNumber numberWithFloat:0] toY:[NSNumber numberWithFloat:ScreenWidth-60-2] rep:OPEN_MAX];
    [line.layer addAnimation:animation forKey:@"LineAnimation"];
}

+ (CABasicAnimation *)moveYTime:(float)time fromY:(NSNumber *)fromY toY:(NSNumber *)toY rep:(int)rep
{
    CABasicAnimation *animationMove = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    [animationMove setFromValue:fromY];
    [animationMove setToValue:toY];
    animationMove.duration = time;
    animationMove.delegate = self;
    animationMove.repeatCount  = rep;
    animationMove.fillMode = kCAFillModeForwards;
    animationMove.removedOnCompletion = NO;
    animationMove.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animationMove;
}


/**
 *  @author Whde
 *
 *  去除扫码动画
 */
- (void)removeAnimation{
    UIView *line = [self.view viewWithTag:line_tag];
    [line.layer removeAnimationForKey:@"LineAnimation"];
    line.hidden = YES;
}

/**
 *  @author Whde
 *
 *  扫码取消button方法
 *
 *  @return
 */
- (void)dismissOverlayView:(id)sender{
    [self selfRemoveFromSuperview];
}

/**
 *  @author Whde
 *
 *  从父视图中移出
 */
- (void)selfRemoveFromSuperview{
    [session removeObserver:self forKeyPath:@"running" context:nil];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)startCheckRequest
{
    [MBProgressHUD showMessage:@"正在签到，请稍后...." toView:self.view];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObject:@"ActivityJoinModify"forKey:@"a"];
    if (self.actId) {
        [params setObject:self.actId forKey:@"activity_id"];
    }
    [params setObject:@"1" forKey:@"user_status"];
    [params setObject:userID forKey:@"user_id"];
    [params setObject:[UPDataManager shared].userInfo.ID forKey:@"creator_id"];
    
    [[YMHttpNetwork sharedNetwork] GET:@"" parameters:params success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        NSDictionary *dict = (NSDictionary *)responseObject;
        NSString *resp_id = dict[@"resp_id"];
        if ([resp_id intValue]==0) {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            NSString *resp_desc = dict[@"resp_desc"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:resp_desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            
            NSLog(@"%@", @"获取失败");
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        NSLog(@"%@",[error localizedDescription]);
    }];
}
@end
