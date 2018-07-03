//
//  PAMediator.m
//  manpanxiang
//
//  Created by Linkou Bian on 13/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAMediator.h"
#import <objc/runtime.h>

@interface PAMediator ()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation PAMediator

+ (instancetype)sharedInstance {
    static PAMediator *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PAMediator alloc] init];
    });
    
    return _sharedInstance;
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName {
    NSDictionary *params = nil;
    return [self performTarget:targetName action:actionName params:params];
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params {
    BOOL shouldCacheTarget = YES;
    return [self performTarget:targetName action:actionName params:params shouldCacheTarget:shouldCacheTarget];
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName params:(NSDictionary *)params shouldCacheTarget:(BOOL)shouldCacheTarget {
    // 映射到符合 Mediator 规范的内部 Target / Action 名称 (注意 action 带有一个参数)
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@:", actionName];
    Class targetClass;
    
    // 如果存在承载 Mediator 方法调用的 Target 对象，复用之
    NSObject *target = self.cachedTarget[targetClassString];
    if (!target) {
        targetClass = NSClassFromString(targetClassString);
        
        if (targetClass) {
            target = [[targetClass alloc] init];
        }
        
    }
    
    // 如果没有 Target 来实现 Mediator 目的，则 ignore 请求。当然，也可以在 PAMediator 中提供 Default Target 来应对此场景
    if (!target) {
        NSLog(@"Error: Mediator can NOT find the target named %@", targetClassString);
        return nil;
    }
    
    // 缓存 target 对象
    if (shouldCacheTarget) {
        self.cachedTarget[targetClassString] = target;
    }
    
    SEL action = NSSelectorFromString(actionString);
    
    // 执行 Action
    if ([target respondsToSelector:action]) {
        return [self safePerformAction:action target:target params:params];
        
    } else {
        
        NSLog(@"Warning: Mediator find the target named %@, but the target can NOT response to %@", targetClassString, actionString);
        
        // 如果无响应，则尝试调用 target 的 notFound 方法统一处理
        SEL action = NSSelectorFromString(@"notFound:");
        if ([target respondsToSelector:action]) {
            
            NSLog(@"Info: Mediator dispatch notFound: message to %@ instead", targetClassString);
            return [self safePerformAction:action target:target params:params];
            
        } else {
            // 在 notFound 都没有时，则 ignore 请求。当然，也可以由 PAMediator 中的 Default Target 来处理
            NSLog(@"Error: Mediator ignore %@ action request for target %@", actionString, targetClassString);
            return nil;
        }
    }
}

// 释放指定缓存中的 Target 对象，暂未公开给业务端
- (void)releaseCachedTargetWithTargetName:(NSString *)targetName {
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@", targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

#pragma mark - Private Methods

- (id)safePerformAction:(SEL)action target:(NSObject *)target params:(NSDictionary *)params {
    NSMethodSignature* methodSig = [target methodSignatureForSelector:action];
    if(!methodSig) {
        return nil;
    }
    
    const char *retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&params atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:params];
#pragma clang diagnostic pop
}

#pragma mark - Properties

- (NSMutableDictionary *)cachedTarget {
    if (!_cachedTarget) {
        _cachedTarget = [[NSMutableDictionary alloc] init];
    }
    
    return _cachedTarget;
}

@end
