//
//  UPTools.h
//  Me
//
//  Created by 张永明 on 16/5/19.
//  Copyright © 2016年 Upper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MBProgressHUD;
@interface UPTools : NSObject

+ (NSString *)stringFromUnicode:(NSString *)unicodeStr;
+ (NSString *)dateString:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format;
+ (NSString *)dateTransform:(NSString *)dateStr fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
+ (NSString *)dateStringTransform:(NSString *)sourceStr fromFormat:(NSString *)fromFormat toFormat:(NSString *)toFormat;
+ (NSString *)md5HexDigest:(NSString *)input;

/**获取UUID
 *UUID是开发者+设备的唯一标识，但是由于在设备卸载开发者apps，并重新安装后，这个标示符会改变 （ios7+）
 *为了避免频繁的更新UUID对后台统一造成影响，将获取到的UUID存储在keychain中，以后直接从keychain中获取。
 *缺点：即使这样也不能完美的实现 APP 对于设备的唯一标识。在设备恢复出厂设置 或 升级大版本（有可能造成应用清空全部重新下载的情况），keychain会被清空，这个时候UUID依旧会变更。
 */
+ (NSString *)getUPUUID;

+(id)loadLocalDataWithName:(NSString*)fileName;
+(id)loadBundleFile:(NSString*)fileName;


+(NSData*)dataFromJSON:(NSObject*)jsonObj;
+(NSData*)dataFromGBKJSON:(NSObject*)jsonObj;
+ (NSString *)stringFromQuotString:(NSString *)quotString;
+(NSString*)stringFromJSON:(NSObject*)jsonObj;
+(NSObject*)JSONFromString:(NSString*)jsonStr;
+ (id)JSONFromData:(NSData *)jsonData;

+(NSString*)documentFilePathWithName:(NSString*)fileName;
+(BOOL)saveFileToDocument:(NSData*)data withName:(NSString*)fileName;

+(id)loadKey:(NSString*)key;
+(BOOL)saveKey:(NSString*)key value:(id)value;

+(BOOL)needUpgradeVersion:(NSString*)version newVersion:(NSString*)newVersion;

+(NSString*)decimalNumberMutiplyWithString:(NSString*)multiplierValue :(NSString *)multiplicandValue;
+(NSDictionary*)parseURLParams:(NSString*)str;

+(NSString *)getBaseUrlWithFixParams;

+ (MBProgressHUD *)createHUD;
+ (UIImage *)createQRCodeFromString:(NSString *)string;

//+ (void)writeToPlist:(NSString *)fileName withContents:(NSDictionary *)dict;
+ (UIImage *)image:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)cutImage:(UIImage*)image withSize:(CGSize)toSize;
+ (NSData *)compressImage:(UIImage *)image;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;

+ (UIImage *)fixOrientation:(UIImage *)aImage;

//根据颜色返回image
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithViewFrame:(CGRect)frame ViewColor:(UIColor *)color;

+ (void)getCGColorFloat:(UIColor *)uicolor red:(float *)red green:(float *)green blue:(float *)blue alpha:(float *)alpha;

+ (UIColor *)colorWithHex:(int)hexValue;

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font;

+ (NSString *)validatePassword:(NSString *)pass andConfirm:(NSString *)confirmPass;
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validatePhone:(NSString *)phone;

+ (NSString *)percentNum:(NSString *)num;

@end
