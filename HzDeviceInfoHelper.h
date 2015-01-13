//
//  HzDeviceInfoHelper.h
//  21cms
//
//  Created by 何 峙 on 14-5-19.
//  Copyright (c) 2014年 何 峙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HzDeviceInfoHelper : NSObject

/**
 *  @brief  获取运营商名字
 */
+ (NSString *)getTeleServiceProviderName;

/**
 *  @brief  获取设备型号
 */
+ (NSString *)getPlatform;

/**
 *  @brief  获取网络类型
 */
+ (NSString *)getNetworkType;

/**
 *  @brief  获取App的版本号
 */
+ (NSString *)getAppVersion;

/**
 *  @brief  获取编译的版本号（内部版本号）
 */
+ (NSString *)appBuildNumber;

/**
 *  @brief  获取系统版本号
 */
+ (NSString *)getSystemVersion;

/**
 *  @brief  获取系统名字
 */
+ (NSString *)getSystemName;

+ (BOOL)isiPhone4;

+ (void)checkNetworkReachabilityWithCompletions:(void (^)(BOOL isReachable))completion;

@end
