//
//  PAMediator.h
//  manpanxiang
//
//  Created by Linkou Bian on 13/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAMediator : NSObject

+ (instancetype)sharedInstance;

// 本地组件调用入口
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName;
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params;
- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget;

@end
