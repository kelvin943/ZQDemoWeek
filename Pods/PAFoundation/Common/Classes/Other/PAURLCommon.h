//
//  PAURLCommon.h
//  haofang
//
//  Created by PengFeiMeng on 5/6/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAPlistManager.h"

#pragma mark - 获取 hosts.plist 中对应的配置

#define kSchemeTypeSecurity                                         @"__scheme_security__"
#define kURLTypeCommon                                              @"__url_common__"
#define kURLTypeH5HostSite                                          @"__url_h5_site__"

// 统计的 host 配置已包含 scheme（其实每个 host 配置都直接带上 scheme 会更灵活）
#define kURLPAStats                                                 @"__url_stats__"
#define kURLVersionCheck                                            @"__url_version__"
#define kURLTypeUpLoadImage                                         @"__url_image__"


// 根据 type 获取相应的 scheme
NSString *schemeForType(NSString *type);
// 根据 type 获取相应的 host
NSString *hostForType(NSString *type);
// 根据 urlKey 获取 path
NSString *Common_UrlForKey(NSString *urlKey);

#pragma mark -

@interface PAURLCommon : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) PAPlistManager                        *hostsManager;
@property (nonatomic, retain) NSDictionary                          *urlMaps;
@property (nonatomic, assign) NSUInteger                            apiConfigure;

@end
