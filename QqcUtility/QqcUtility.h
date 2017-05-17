//
//  QqcUtility.h
//  QqcBaseFramework
//
//  Created by qiuqinchuan on 15/10/14.
//  Copyright © 2015年 Qqc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void(^NetworkBlock)(BOOL bRet);

@interface QqcUtility : NSObject

#pragma mark - 设备系统相关
/**
 *  获取终端标识符，采用uuid做于唯一性标志
 *
 *  @return 返回终端标识符
 */
+ (NSString *)terminalSign;

/**
 *  获取设备描述
 *
 *  @return 设备描述
 */
+ (NSString*)getDevDesc;

/**
 *  判断系统语言是否为中文
 *
 *  @return YES,是中文系统；NO,不是中文系统
 */
+(BOOL)isChinessSysLanguage;

/**
 *  判断系统时间是否12小时进制
 *
 *  @return 是-yes，否-no
 */
+ (BOOL)isTwelveHourFormat;

#pragma mark - 摄像头相关
/**
 *  是否有闪光灯
 *
 *  @return YES,有闪光灯；NO，没有闪光灯
 */
+ (BOOL)isHasTorch;

/**
 *  闪光灯控制
 *
 *  @param on YES,开；NO，关闭
 */
+ (void)turnTorchOn:(BOOL)on;

/**
 *  相机隐私检测
 *
 *  @return YES,可以使用；NO，不可以使用
 */
+ (BOOL)isCanUseCammera;

#pragma mark - App版本相关
/**
 *  获取App的主版本
 *
 *  @return App的主版本
 */
+ (NSString*)getAppVersion;

/**
 *  获取App的Build版本
 *
 *  @return App的Build版本
 */
+ (NSString*)getAppBuildVersion;

/**
 *  获取系统主版本号
 *
 *  @return 返回系统的主版本号
 */
+ (NSUInteger)getSystemMainVersion;

/**
 *  获取系统版本号
 *
 *  @return 返回系统的版本号
 */
+ (NSString*)getSystemVersion;


#pragma mark -网络
/**
 *  开始监听网络，开始监听网络，要监听网络的变化必须要调用该方法，建议在AppDelegate里调用
 */
+ (void)startNetworkNotifier;

/**
 *  结束监听网络
 */
+ (void)stopNetworkNotifier;

/**
 *  判断网络是否正常
 *
 *  @return 是-yes，否-no
 */
+ (BOOL)isNetworkReachable;

/**
 *  判断是否在WIFI环境下
 *
 *  @return 是-yes，否-no
 */
+ (BOOL)isNetworkReachableViaWiFi;

/**
 *  判断是否连通某个地址
 *
 *  @param strHost 某个地址
 *  @param block   结果回调
 */
+ (void)isCanConnectedHost:(NSString*)strHost ret:(NetworkBlock)block;

//是否能打开某个应用
+ (BOOL)isCanOpenAppWithSchemeURL:(NSString*)strSchemeUrl;

//打开某个应用
+ (void)openAppWithSchemeURL:(NSString*)strSchemeUrl;


@end
