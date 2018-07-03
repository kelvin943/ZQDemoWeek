//
//  PAURLCommon.m
//  haofang
//
//  Created by PengFeiMeng on 5/6/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAURLCommon.h"
#import "PAMediator+AppConfig.h"

#pragma mark - 对应 hosts.plist 中的 KEY

// 通用配置
#define SECURITY_SCHEME                                             @"security_scheme"
#define SERVERIP                                                    @"SERVERIP"
#define H5_SERVERIP                                                 @"H5_SERVERIP"

// 特殊配置
#define HF_STATS_SERVERIP                                           @"HF_STATS_SERVERIP"    // 统计仅线上支持 https
#define VERSIONCHECKIP                                              @"VERSIONCHECKIP"       // 版本检查用的公共服务
#define HF_UPLOADIMAGE_SERVERIP                                     @"HF_UPLOADIMAGE_SERVERIP"    // 统计仅线上支持 https


#pragma mark - 获取 hosts.plist 中配置的全局方法

// 根据 type 获取相应的 scheme
NSString *schemeForType(NSString * type){
    NSString * scheme   = nil;
    
    if ([type isEqualToString:kURLTypeCommon]) {
        scheme          = @"http";
    } else if ([type isEqualToString:kSchemeTypeSecurity]) {
        PAURLCommon *urlCommon = [PAURLCommon sharedInstance];
        NSDictionary *ipDic = [urlCommon.hostsManager.listData objectAtIndex:urlCommon.apiConfigure];
        scheme = [ipDic objectForKey:SECURITY_SCHEME];
    }
    
    return scheme;
}

// 根据 type 获取相应的 host
NSString *hostForType(NSString *type){
    NSString *host      = nil;
    NSString *key       = nil;
    
    if ([type isEqualToString:kURLTypeCommon]) {
        key             = SERVERIP;
    } else if ([type isEqualToString:kURLTypeH5HostSite]){
        key             = H5_SERVERIP;
    } else if ([type isEqualToString:kURLPAStats]){
        key             = HF_STATS_SERVERIP;
    } else if ([type isEqualToString:kURLVersionCheck]){
        key             = VERSIONCHECKIP;
    } else if ([type isEqualToString:kURLTypeUpLoadImage]){
        key             = HF_UPLOADIMAGE_SERVERIP;
    }
    
    // 指定的 host 类型有误，则直接出错
    assert(key);
    
    PAURLCommon *urlCommon = [PAURLCommon sharedInstance];
    NSDictionary *ipDic = [[urlCommon.hostsManager listData] objectAtIndex:urlCommon.apiConfigure];
    
    // 如果 hosts.plist 读不到，则直接出错
    assert(ipDic);
    
    host                = [ipDic objectForKey:key];
    
    return host;
}

// 根据 urlKey 获取 path
NSString * Common_UrlForKey(NSString * urlKey){
    NSString * url  = [PAURLCommon sharedInstance].urlMaps[urlKey];
    
    assert([url length] > 0);
    
    return url;
}

#pragma mark -

@implementation PAURLCommon

+ (instancetype)sharedInstance {
    static PAURLCommon *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PAURLCommon alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.hostsManager = [[PAPlistManager alloc] initWithFileName:@"hosts" autoCreate:NO];
        self.urlMaps = @{};
        
        // PAURLCommon+Path 中 steupURLMaps 方法，配置所有 PATH
        if ([self respondsToSelector:@selector(steupURLMaps)]) {
            self.urlMaps = [self performSelector:@selector(steupURLMaps)];
        }
    }
    
    return self;
}

- (void)setApiConfigure:(NSUInteger)apiConfigure {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@(apiConfigure) forKey:@"_apiCfg"];
    [defaults synchronize];
}

- (NSUInteger)apiConfigure {
    // 不支持摇一摇切换 Host 环境，则采用默认配置
    if (![[PAMediator sharedInstance] APISWITCH]) {
        return [[PAMediator sharedInstance] APICONFIG];
    }
    
    // 从缓存里读取选择的 Host 环境
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *cfg = [defaults objectForKey:@"_apiCfg"];
    return cfg != nil ? [cfg unsignedIntegerValue] : [[PAMediator sharedInstance] APICONFIG];
}

@end
