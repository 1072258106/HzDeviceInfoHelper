//
//  HzDeviceInfoHelper.m
//  21cms
//
//  Created by 何 峙 on 14-5-19.
//  Copyright (c) 2014年 何 峙. All rights reserved.
//

#import "HzDeviceInfoHelper.h"
#import <UIKit/UIKit.h>
#import <sys/types.h>
#import <sys/sysctl.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "Reachability.h"
#import <AFNetworking/AFNetworking.h>

#define iOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

NSString * const kHzDeviceInfoHelperNetworkNothing = @"network nothing";
NSString * const kHzDeviceInfoHelperNetwork3G = @"3g";
NSString * const kHzDeviceInfoHelperNetworkWIFI = @"wifi";
NSString * const kHzDeviceInfoHelperNetworkUnknown = @"network unknown";

@interface HzDeviceInfoHelper ()

+ (NSString *)getDeviceVersion;
+ (NSString *)getNetworkTypePreviousiOS7;

@end

@implementation HzDeviceInfoHelper

+ (NSString *)getTeleServiceProviderName{
    CTTelephonyNetworkInfo *networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSString *temp = @"no name";
    if(carrier != nil){
        temp = [carrier carrierName];
    }
    NSString *result = [[[NSString alloc] initWithString:temp] autorelease];
    [networkInfo release];
    
    return result;
}

+ (NSString *)getPlatform{
    NSString *platform = [HzDeviceInfoHelper getDeviceVersion];
    if([platform isEqualToString:@"iPhone1,1"])   return @"iPhone 1G";
    if([platform isEqualToString:@"iPhone1,2"])   return @"iPhone 3G";
    if([platform isEqualToString:@"iPhone2,1"])   return @"iPhone 3GS";
    if([platform isEqualToString:@"iPhone3,1"])   return @"iPhone 4";
    if([platform isEqualToString:@"iPhone3,2"])   return @"Verizon iPhone 4";
    if([platform isEqualToString:@"iPhone4,1"])   return @"iPhone 4S";
    if([platform isEqualToString:@"iPhone5,1"])   return @"iPhone 5";
    if([platform isEqualToString:@"iPod1,1"])     return @"iPod Touch 1G";
    if([platform isEqualToString:@"iPod2,1"])     return @"iPod Touch 2G";
    if([platform isEqualToString:@"iPod3,1"])     return @"iPod Touch 3G";
    if([platform isEqualToString:@"iPod4,1"])     return @"iPod Touch 4G";
    if([platform isEqualToString:@"iPod5,1"])     return @"iPod Touch 5G";
    if([platform isEqualToString:@"iPad1,1"])     return @"iPad";
    if([platform isEqualToString:@"iPad2,1"])     return @"iPad 2 (WiFi)";
    if([platform isEqualToString:@"iPad2,4"])     return @"iPad 2 (WiFi)";
    if([platform isEqualToString:@"iPad2,2"])     return @"iPad 2 (GSM)";
    if([platform isEqualToString:@"iPad2,3"])     return @"iPad 2 (CDMA)";
    if([platform isEqualToString:@"iPad3,1"])     return @"iPad 3";
    if([platform isEqualToString:@"iPad3,2"])     return @"iPad 3";
    if([platform isEqualToString:@"iPad3,3"])     return @"iPad 3";
    if([platform isEqualToString:@"iPad3,4"])     return @"iPad 4";
    if([platform isEqualToString:@"i386"])        return @"Simulator";
    
    return platform;
}

+ (NSString *)getNetworkType{
    if(iOS7OrLater){
        CTTelephonyNetworkInfo *networkInfo = [[[CTTelephonyNetworkInfo alloc] init] autorelease];
        if(!(networkInfo.currentRadioAccessTechnology)){
            return [HzDeviceInfoHelper getNetworkTypePreviousiOS7];
        }
        else{
            return networkInfo.currentRadioAccessTechnology;
        }
    }
    else{
        return [HzDeviceInfoHelper getNetworkTypePreviousiOS7];
    }
}

+ (NSString *)getAppVersion{
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    return versionStr;
}


+ (NSString *)appBuildNumber{
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
    return versionStr;
}

+ (NSString *)getSystemVersion{
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    return systemVersion;
}

+ (NSString *)getSystemName{
    NSString *systemName = [UIDevice currentDevice].systemName;
    return systemName;
}

+ (NSString *)appName{
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
    return appName;
}

+ (BOOL)isiPhone4{
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        CGSize screenSize = [UIScreen mainScreen].currentMode.size;
        if (screenSize.height <= 960.0f) {
            return YES;
        }
    }
    
    return NO;
}

+ (void)checkNetworkReachabilityWithCompletions:(void (^)(BOOL))completion{
    AFHTTPRequestOperationManager *afManger = [AFHTTPRequestOperationManager manager];
    afManger.responseSerializer = [AFHTTPResponseSerializer serializer];
    [afManger GET:@"http://www.baidu.com" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (responseObject) {            
            if (completion) {
                completion(YES);
            }
            
            return;
        }
        
        if (completion) {
            completion(NO);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (completion) {
            completion(NO);
        }
        
    }];
}


#pragma mark - Private methods

+ (NSString *)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    //NSLog(@"%s, %@", __FUNCTION__, platform);
    
    return platform;
}

+ (NSString *)getNetworkTypePreviousiOS7{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    NSString *result;
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            result = kHzDeviceInfoHelperNetworkNothing;
            break;
        case ReachableViaWWAN:
            result = kHzDeviceInfoHelperNetwork3G;
            break;
        case ReachableViaWiFi:
            result = kHzDeviceInfoHelperNetworkWIFI;
            break;
        default:
            result = kHzDeviceInfoHelperNetworkUnknown;
            break;
    }
    
    return result;
}

@end
