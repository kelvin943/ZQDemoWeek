//
//  PAMediator+AppConfig.h
//  manpanxiang
//
//  Created by Linkou Bian on 13/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAMediator.h"

@interface PAMediator (AppConfig)

/**
 @return API 环境
 */
- (NSUInteger)APICONFIG;

/**
 @return 是否支持摇一摇
 */
- (BOOL)APISWITCH;

/**
 @return 导航栏返回按钮的图标字 Code 值
 */
- (NSString *)PAICONFONT_BACK;

/**
 @return 导航栏按钮颜色
 */
- (NSUInteger)BAR_BUTTON_TITLE_COLOR_HEX;

/**
 @return 应用的 scheme 标识（不是 scheme）
 */
- (NSString *)URLSchemeIdnentifier;

/**
 @return 重新登录 Notification Name
 */
- (NSString *)PANotificationReloginRequired;

@end
