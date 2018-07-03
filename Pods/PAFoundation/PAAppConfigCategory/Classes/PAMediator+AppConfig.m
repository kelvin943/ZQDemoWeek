//
//  PAMediator+AppConfig.m
//  manpanxiang
//
//  Created by Linkou Bian on 13/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAMediator+AppConfig.h"

NSString *const kPAMediatorTargetAppConfig              = @"AppConfig";
NSString *const kPAMediatorActionAPICONFIG              = @"APICONFIG";
NSString *const kPAMediatorActionAPISWITCH              = @"APISWITCH";
NSString *const kPAMediatorActionPAICONFONT_BACK        = @"PAICONFONT_BACK";
NSString *const kPAMediatorActionBarButtonTitleColorHex = @"BarButtonTitleColorHex";
NSString *const kPAMediatorActionURLSchemeIdnentifier   = @"URLSchemeIdnentifier";
NSString *const kPAMediatorActionPANotificationReloginRequired  = @"PANotificationReloginRequired";

@implementation PAMediator (AppConfig)

- (NSUInteger)APICONFIG {
    id returnValue = [self performTarget:kPAMediatorTargetAppConfig action:kPAMediatorActionAPICONFIG];
    return [returnValue unsignedIntegerValue];
}

- (BOOL)APISWITCH {
    id returnValue = [self performTarget:kPAMediatorTargetAppConfig action:kPAMediatorActionAPISWITCH];
    return [returnValue boolValue];
}

- (NSString *)PAICONFONT_BACK {
    id returnValue = [self performTarget:kPAMediatorTargetAppConfig action:kPAMediatorActionPAICONFONT_BACK];
    return returnValue;
}

- (NSUInteger)BAR_BUTTON_TITLE_COLOR_HEX {
    id returnValue = [self performTarget:kPAMediatorTargetAppConfig action:kPAMediatorActionBarButtonTitleColorHex];
    return [returnValue unsignedIntegerValue];
}

- (NSString *)URLSchemeIdnentifier {
    id returnValue = [self performTarget:kPAMediatorTargetAppConfig action:kPAMediatorActionURLSchemeIdnentifier];
    return returnValue;
}

- (NSString *)PANotificationReloginRequired {
    id returnValue = [self performTarget:kPAMediatorTargetAppConfig action:kPAMediatorActionPANotificationReloginRequired];
    return returnValue;
}

@end
