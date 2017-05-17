//
//  QqcUtility.m
//  QqcBaseFramework
//
//  Created by qiuqinchuan on 15/10/14.
//  Copyright © 2015年 Qqc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "sys/utsname.h"
#import "QqcUtility.h"
#import "QqcReachability.h"
#import "NSString+Qqc.h"
#import "QqcLog.h"


static QqcUtility *qqcUtils = nil;
static QqcReachability *reachablity = nil;
static QqcNetworkStatus networkStatus = QqcNotReachable;
NSString *const kTerminalSignKey = @"TerminalSignKey";


@implementation QqcUtility

#pragma mark - 系统方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (void)initialize
{
    if (reachablity == nil)
    {
        reachablity = [QqcReachability reachabilityForInternetConnection];
        networkStatus = [reachablity currentReachabilityStatus];
        qqcUtils = [[QqcUtility alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:qqcUtils
                                                 selector:@selector(handleReachabilityDidChangedNotification:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
}

#pragma mark - 私有方法
/**
 *  处理网络发生变化的通知
 *
 *  @param notification 网络变化通知
 */
- (void)handleReachabilityDidChangedNotification:(NSNotification *)notification
{
    QqcNetworkStatus status = [reachablity currentReachabilityStatus];
    
    if (networkStatus != status)
    {
        BOOL isNeedPostNotification = (networkStatus == QqcNotReachable || status == QqcNotReachable);
        networkStatus = status;
        
        if (isNeedPostNotification)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
        }
    }
}


#pragma mark - 设备系统相关
+ (NSString *)terminalSign
{
    NSString *terminalSign = [[NSUserDefaults standardUserDefaults] objectForKey:kTerminalSignKey];
    
    if (!terminalSign || terminalSign.length == 0)
    {
        terminalSign = [NSString createUUID];
        [[NSUserDefaults standardUserDefaults] setObject:terminalSign forKey:kTerminalSignKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return terminalSign;
}

+ (NSString*)getDevDesc
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone_1G";
    //    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone_3G";
    //    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone_3GS";
    //    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone_4";
    //    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone_4S";
    //    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone_5";
    //    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone_4_Verizon";
    //    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod_Touch_1G";
    //    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod_Touch_2G";
    //    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod_Touch_3G";
    //    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod_Touch_4G";
    //    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad_2_(WiFi)";
    //    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad_2_(GSM)";
    //    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad_2_(CDMA)";
    //    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    //    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    QqcDebugLog(@"%s, devDesc=%@", __PRETTY_FUNCTION__, deviceString);
    
    return deviceString;
}

+(BOOL)isChinessSysLanguage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLang = [languages objectAtIndex:0];
    
    if([currentLang compare:@"zh-Hans" options:NSCaseInsensitiveSearch]==NSOrderedSame || [currentLang compare:@"zh-Hant" options:NSCaseInsensitiveSearch]==NSOrderedSame)
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isTwelveHourFormat
{
    //下面的方法应该更简单， 直接返回AM/PM
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"a"];
    NSString *AMPMtext = [timeFormatter stringFromDate:[NSDate date]];
    return !([AMPMtext isEqualToString:@""]);
}

#pragma mark - 摄像头相关
+ (BOOL)isHasTorch
{
    BOOL bIsHasTorch = NO;
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            bIsHasTorch = YES;
        }
    }
    
    return bIsHasTorch;
}

+ (void)turnTorchOn:(BOOL)on
{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]){
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

+ (BOOL)isCanUseCammera
{
    if ([QqcUtility getSystemMainVersion] >= 7)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if (authStatus == AVAuthorizationStatusDenied)
        {
            return NO;
        }
        
        return YES;
    }
    else
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            return YES;
        }
        
        return NO;
    }
}


#pragma mark - App版本相关
+ (NSString*)getAppVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString*)getAppBuildVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSUInteger)getSystemMainVersion
{
    static NSUInteger sysMainVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sysMainVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
    });
    
    return sysMainVersion;
}

+ (NSString*)getSystemVersion
{
    static NSString* sysVersion = @"";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sysVersion = [[UIDevice currentDevice] systemVersion];
    });
    
    return sysVersion;
}

#pragma mark -网络
+ (void)startNetworkNotifier
{
    [reachablity startNotifier];
}

+ (void)stopNetworkNotifier
{
    [reachablity stopNotifier];
}

+ (BOOL)isNetworkReachable
{
    return networkStatus != QqcNotReachable;
}

+ (BOOL)isNetworkReachableViaWiFi
{
    return (networkStatus == QqcReachableViaWiFi);
}

+ (void)isCanConnectedHost:(NSString*)strHost ret:(NetworkBlock)block
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strHost]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,NSData *data,NSError *error) {
                               
                               if ([data length] > 0 && error == nil)
                               {
                                   block(YES);
                               }
                               else
                               {
                                   block(NO);
                               }
                           }];
    
}

//是否能打开某个应用
+ (BOOL)isCanOpenAppWithSchemeURL:(NSString*)strSchemeUrl
{
    BOOL bIsCanOpen = NO;
    NSString*strSchemeUrlFull = [NSString stringWithFormat:@"%@://", strSchemeUrl];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:strSchemeUrlFull]]){
        bIsCanOpen = YES;
    }
    
    return bIsCanOpen;
}

//打开某个应用
+ (void)openAppWithSchemeURL:(NSString*)strSchemeUrl
{
    NSString*strSchemeUrlFull = [NSString stringWithFormat:@"%@://", strSchemeUrl];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:strSchemeUrlFull]];
}

@end
