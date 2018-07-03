//
//  NSObject+Category.m
//  haofang
//
//  Created by PengFeiMeng on 4/19/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "NSObject+Category.h"

@implementation NSObject (Category)

- (BOOL)isNilOrNull{
    BOOL flag = self && self != [NSNull null];
    return !flag;
}


- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects{
    // 方法签名
    NSMethodSignature * signature   = [self methodSignatureForSelector:aSelector];
    
    if (signature) {
        NSString * selectorString       = NSStringFromSelector(aSelector);
        NSInteger colonCount            = [self countOfAppearanceOfString:@":" inString:selectorString];
        
        // 判断传入参数数量是否跟方法中参数数量相同
        if (objects) {
            if (objects.count != colonCount) {
                return nil;
            }
        }else{
            if (colonCount) {
                return nil;
            }
        }
        
        // 调用对象
        NSInvocation * invocation   = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:aSelector];
        
        // 传入参数
        if (objects && objects.count) {
            for (int i = 0; i < objects.count; i++) {
                id obj = [objects objectAtIndex:i];
                [invocation setArgument:&obj atIndex:i+2];
            }
        }
        
        // 调用
        [invocation invoke];
        if (signature.methodReturnLength) {
            
            // NSInvocation 在 ARC 下获取返回值，谨防过度 release 问题。result 指向了返回对象，但并不持有
            // 参考 https://github.com/dukeland/EasyJSWebView/pull/6 的解说
            //
            id returnValue;
            void *result;
            [invocation getReturnValue:&result];
            
            // 当 NSInvocation 调用的是 alloc 时，只有把返回对象的内存管理权移交出来，让外部对象帮它释放才行（读 JSPatch 源代码了解到的知识）
            // 严格来说，我们还需要处理 copy/mutableCopy 以及以这些名称开头的方法。但出于 performance 及实际应用场景的考量，仅示意一下 alloc
            // 及 new，以对开发者提供一点有益的提示。
            //
            if ([selectorString isEqualToString:@"alloc"] || [selectorString isEqualToString:@"new"]) {
                returnValue = (__bridge_transfer id)result;
            } else {
                returnValue = (__bridge id)result;
            }
            
            return returnValue;
        }else{
            return nil;
        }
    }
    return nil;
}

- (NSInteger)countOfAppearanceOfString:(NSString *)string inString:(NSString *)originalString{
    NSInteger count           = 0;
    
    if (originalString) {
        if ([originalString rangeOfString:string].location != NSNotFound) {
            NSArray * components = [originalString componentsSeparatedByString:string];
            
            if (components && components.count) {
                count   = components.count - 1;
            }
        }
    }
    
    return count;
}

- (NSString *)stringValue{
    NSString * string = [NSString stringWithFormat:@"%@",self];
    
    return string;
}


- (id)objectForKey:(id <NSCopying>)aKey{
    id object = nil;
    
    return object;
}
@end
