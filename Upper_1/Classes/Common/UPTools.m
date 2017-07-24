//
//  UPTools.m
//  Me
//
//  Created by 张永明 on 16/5/19.
//  Copyright © 2016年 Upper. All rights reserved.
//

#import "UPTools.h"
#import <CommonCrypto/CommonDigest.h>
#import "SFHFKeychainUtils.h"
#import "Info.h"
#import "MBProgressHUD.h"

//#define MD5_DIGEST_LENGTH 32

NSString *kKeychainUUIDItemIdentifier  = @"UUID";
NSString *kKeyChainUUIDAccessGroup = @"com.upper";

@implementation UPTools

+ (NSString *)stringFromUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:nil error:nil];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

+ (NSString *)dateString:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =format;
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat =format;
    return [formatter dateFromString:dateStr];
}

+ (NSString *)dateTransform:(NSString *)dateStr fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = fromFormat;
    NSDate *date = [formatter dateFromString:dateStr];
    formatter.dateFormat = toFormat;
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    return [formatter stringFromDate:date];
}

+ (NSString *)dateStringTransform:(NSString *)sourceStr fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat
{
    NSDate *date = [UPTools dateFromString:sourceStr withFormat:fromFormat];
    return [UPTools dateString:date withFormat:toFormat];
}

+ (NSString *)md5HexDigest:(NSString *)input
{
    const char *str = [input UTF8String];
    unsigned char result[CC_MD2_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD2_DIGEST_LENGTH];
    
    for (int i=0; i<CC_MD2_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

+ (NSString *)getUPUUID
{
    NSString *uuid = [UPTools getEMUUIDFromKeyChain];
    if (!uuid) {
        UIDevice* device=[UIDevice currentDevice];
        if([device.systemVersion intValue]<6){
            uuid=[UPTools uuid];
        }else{
            uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
        }
        uuid = [NSString stringWithString:[uuid substringFromIndex:[uuid length]-20]];
        
        [UPTools setEMUUIDToKeyChain:uuid];
    }
    return uuid;
}

#pragma mark -
#pragma mark Helper Method for make identityForVendor consistency

+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

+ (NSString*)getEMUUIDFromKeyChain
{
    return [SFHFKeychainUtils getPasswordForUsername:kKeychainUUIDItemIdentifier andServiceName:kKeyChainUUIDAccessGroup error:nil];
}

+ (BOOL)setEMUUIDToKeyChain:(NSString*)udid
{
    return  [SFHFKeychainUtils storeUsername:kKeychainUUIDItemIdentifier
                                 andPassword:udid
                              forServiceName:kKeyChainUUIDAccessGroup
                              updateExisting:NO
                                       error:nil];
}

+ (BOOL)removeUDIDFromKeyChain
{
    return  [SFHFKeychainUtils deleteItemForUsername:kKeychainUUIDItemIdentifier andServiceName:kKeyChainUUIDAccessGroup error:nil];
}
+(id)loadLocalDataWithName:(NSString*)fileName{
    NSString* saveFilePath=[UPTools documentFilePathWithName:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:saveFilePath]){
        NSData* data=[NSData dataWithContentsOfFile:saveFilePath];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return json;
    }
    return nil;
}

+(id)loadBundleFile:(NSString*)fileName{
    NSString* sourcePath = [[NSBundle mainBundle] bundlePath];
    NSString* filePath = [sourcePath stringByAppendingPathComponent:fileName];
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        NSData* data=[NSData dataWithContentsOfFile:filePath];
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        return json;
    }
    return nil;
}


+(NSData*)dataFromJSON:(NSObject*)jsonObj{
    NSError* error=nil;
    NSData* data=[NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:&error];
    return data;
    //    NSString* content=[dict JSONFragment];
    //    return [content dataUsingEncoding:NSUTF8StringEncoding];
}

+(NSData*)dataFromGBKJSON:(NSObject*)jsonObj
{
    NSError* error=nil;
    NSData* data=[NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *newStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    return [newStr dataUsingEncoding:enc];;
}

+ (NSString *)stringFromQuotString:(NSString *)quotString
{
    NSString *newStr = [quotString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    return newStr;
}

+(NSString*)stringFromJSON:(NSObject*)jsonObj{
    //    [JSON JSONString]
    NSData* data=[UPTools dataFromJSON:jsonObj];
    NSString* value=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return value;
}

+(NSObject*)JSONFromString:(NSString*)jsonStr{
    NSError *error;
    NSDictionary *json = nil;
    if(jsonStr && jsonStr.length>0){
        @try {
            json = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
        //        @finally {
        //            NSLog(@"error");
        //        }
    }
    return json;
}

+ (id)JSONFromData:(NSData *)jsonData
{
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&error];
    
    if (error) {
        NSLog(@"Error occured when init object with json data, error: %@", error.localizedDescription);
        return nil;
    }
    return dict;
}

+(NSString*)documentFilePathWithName:(NSString*)fileName{
    NSArray *paths         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath =[paths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:fileName];
}

+(BOOL)saveFileToDocument:(NSData*)data withName:(NSString*)fileName{
    NSArray *paths         = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *realPath     = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    return [data writeToFile:realPath atomically:YES];
}

+(id)loadKey:(NSString*)key{
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    return [userDefault valueForKey:key];
}

+(BOOL)saveKey:(NSString*)key value:(id)value{
    NSUserDefaults* userDefault=[NSUserDefaults standardUserDefaults];
    if(userDefault){
        [userDefault setObject:value forKey:key];
    }
    return [userDefault synchronize];
}

+(BOOL)needUpgradeVersion:(NSString*)version newVersion:(NSString*)newVersion{
    NSArray* vers=[version componentsSeparatedByString:@"."];
    NSArray* newVers=[newVersion componentsSeparatedByString:@"."];
    if([newVers[0] intValue] >[vers[0] intValue]||[newVers[1] intValue] >[vers[1] intValue]){
        if(vers.count==newVers.count&&newVers.count==3){
            if([newVers[2] intValue] >[vers[2] intValue]){
                return YES;
            }
        }else {
            return YES;
        }
    }
    return NO;
}

+(NSString*)decimalNumberMutiplyWithString:(NSString*)multiplierValue :(NSString *)multiplicandValue{
    if(multiplierValue.length==0||multiplicandValue.length==0){
        return @"";
    }
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumber *product = [multiplicandNumber decimalNumberByMultiplyingBy:multiplierNumber];
    return [product stringValue];
}

+(NSDictionary*)parseURLParams:(NSString*)str{
    if([str hasPrefix:@"http://"]){
        if([str rangeOfString:@"?"].location!=NSNotFound){
            str=[[str componentsSeparatedByString:@"?"] objectAtIndex:1];
        }else {
            return nil;
        }
    }
    NSArray* kvParams=[str componentsSeparatedByString:@"&"];
    NSMutableDictionary* result=[[NSMutableDictionary alloc] init];
    for (NSString* param in kvParams) {
        NSUInteger location=[param rangeOfString:@"="].location;
        if(location!=NSNotFound&&param.length>2){
            
            [result setValue:[param substringFromIndex:location+1] forKey:[param substringToIndex:location]];
        }
    }
    return result;
}

+ (MBProgressHUD *)createHUD
{
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithWindow:window];
    HUD.detailsLabelFont = [UIFont boldSystemFontOfSize:16];
    [window addSubview:HUD];
    [HUD show:YES];
    HUD.removeFromSuperViewOnHide = YES;
    
    return HUD;
}

+ (UIImage *)createQRCodeFromString:(NSString *)string
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [QRFilter setValue:stringData forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CGFloat scale = 5;
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:QRFilter.outputImage fromRect:QRFilter.outputImage.extent];
    
    //Scale the image usign CoreGraphics
    CGFloat width = QRFilter.outputImage.extent.size.width * scale;
    UIGraphicsBeginImageContext(CGSizeMake(width, width));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //Cleaning up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return image;
}
//
//
//
//+ (void)writeToPlist:(NSString *)fileName withContents:(NSDictionary *)dict
//{
//    NSArray *sandboxPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [sandboxPath objectAtIndex:0];
//    NSString *plistPath = [documentDirectory stringByAppendingPathComponent:fileName];
//    
//    [dict writeToFile:plistPath atomically:YES];
//    
//    NSLog(@"%@", NSHomeDirectory());
//    NSLog(@"写入成功");
//}
//
//+ (NSMutableDictionary *)readFromPlist:(NSString *)fileName
//{
//    NSArray *sandboxPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentDirectory = [sandboxPath objectAtIndex:0];
//    NSString *plistPath = [documentDirectory stringByAppendingPathComponent:fileName];
//    
//    NSMutableDictionary *searchData = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
//    return searchData;
//}

+ (NSData *)compressImage:(UIImage *)image
{
    CGSize size = [self scaleSize:image.size];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSUInteger maxFileSize = 500 * 1024;
    CGFloat compressionRatio = 0.8f;
    CGFloat maxCompressionRatio = 0.1f;
    
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, compressionRatio);
    
    while (imageData.length > maxFileSize && compressionRatio > maxCompressionRatio) {
        compressionRatio -= 0.1f;
        imageData = UIImageJPEGRepresentation(image, compressionRatio);
    }
    
    return imageData;
}

+ (CGSize)scaleSize:(CGSize)sourceSize
{
    float width = sourceSize.width;
    float height = sourceSize.height;
    if (width >= height) {
        return CGSizeMake(800, 800 * height / width);
    } else {
        return CGSizeMake(800 * width / height, 800);
    }
}

//压缩图片
+ (UIImage *)image:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

//裁剪图片
+ (UIImage *)cutImage:(UIImage*)image withSize:(CGSize)toSize
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (toSize.width /toSize.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * toSize.height / toSize.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * toSize.width / toSize.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    UIImage *newImg = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImg;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                 
                                                                 NULL, /* allocator */
                                                                 
                                                                 (__bridge CFStringRef)input,
                                                                 
                                                                 NULL, /* charactersToLeaveUnescaped */
                                                                 
                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                 
                                                                 kCFStringEncodingUTF8);
    return outputStr;
}

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                                withString:@""
                                options:NSLiteralSearch
                                range:NSMakeRange(0,[outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//根据颜色返回image
+ (UIImage *)imageWithColor:(UIColor *)color
{
    return  [self imageWithColor:color size:CGSizeMake(6, 6)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *rst = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rst;
}

+ (UIImage *)imageWithViewFrame:(CGRect)frame ViewColor:(UIColor *)color
{
    UIView *imgview = [[UIView alloc] initWithFrame:frame];
    imgview.backgroundColor = color;
    UIGraphicsBeginImageContext(imgview.bounds.size);
    [imgview.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)getCGColorFloat:(UIColor *)uicolor red:(float *)red green:(float *)green blue:(float *)blue alpha:(float *)alpha
{
    CGColorRef c            = uicolor.CGColor;
    const CGFloat * colors  = CGColorGetComponents(c);
    
    float _red      = colors[0];
    float _green    = colors[1];
    float _blue     = colors[2];
    float _alpha    = colors[3];
    
    *red	= _red;
    *green  = _green;
    *blue	= _blue;
    *alpha  = _alpha;
}


+ (UIColor *)colorWithHex:(int)hexValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0
                           alpha:1];
}


+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font;
{
    NSInteger ch;
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    ch = size.height;
    
    return size;
}

+ (NSString *)validatePassword:(NSString *)pass andConfirm:(NSString *)confirmPass
{
    if (pass.length==0 || confirmPass.length==0 || ![pass isEqualToString:confirmPass])
    {
        return @"密码不能为空且需要保持一致";
    }
    
    if (pass.length<8) {
        return @"密码长度必须大于8位";
    }
    
    NSArray *regexArr = @[@"[A-Z]+", @"[a-z]+", @"[0-9]+"];
    
    for (NSString* regex in regexArr) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        if ([filter evaluateWithObject:pass]) {
            return @"密码不符合要求，至少包括数字和字母";
        }
    }
    
    return @"";
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (NSString *)percentNum:(NSString *)num
{
    int newNum = [num intValue]*100;
    return [NSString stringWithFormat:@"%d%%", newNum];
}

@end
