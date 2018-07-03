//
//  PAURLMap.m
//  haofang
//
//  Created by PengFeiMeng on 4/30/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAURLMap.h"
#import "NSString+URL.h"
#import "PANavigator.h"

#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#include <mach-o/ldsyms.h>


NSArray<NSString *>* PAReadViewControllerAnnotations(char *sectionName,const struct mach_header *mhp);

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide)
{
    NSArray<NSString *> *annotations = PAReadViewControllerAnnotations(PAURLMapSectName, mhp);
    for (NSString *map in annotations) {
        NSData *jsonData =  [map dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (!error) {
            if ([json isKindOfClass:[NSDictionary class]] && [json allKeys].count) {
                
                NSString *identifier = [json allKeys][0];
                NSString *clsName  = [json allValues][0];
                
                if (identifier && clsName) {
                    [[PANavigator sharedInstance] mapIdentifier:identifier toController:clsName];
                }
            }
        }
    }
    
}
__attribute__((constructor))
void initProphet() {
    _dyld_register_func_for_add_image(dyld_callback);
}

NSArray<NSString *>* PAReadViewControllerAnnotations(char *sectionName,const struct mach_header *mhp)
{
    NSMutableArray *configs = [NSMutableArray array];
    unsigned long size = 0;
#ifndef __LP64__
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp, SEG_DATA, sectionName, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t*)getsectiondata(mhp64, SEG_DATA, sectionName, &size);
#endif
    
    unsigned long counter = size/sizeof(void*);
    for(int idx = 0; idx < counter; ++idx){
        char *string = (char*)memory[idx];
        NSString *str = [NSString stringWithUTF8String:string];
        if(!str)continue;
        
        if(str) [configs addObject:str];
    }
    
    return configs;
    
    
}

@implementation PAURLMap

+ (NSString *)urlForViewWithIdentifier:(NSString *)identifier params:(NSDictionary *)params {
    NSString * url              = nil;
    
    if (identifier) {
        NSString * scheme       = [PAURLHelper appUrlScheme];
        NSString * host         = APPURL_HOST_VIEW;
        NSString * path         = identifier;
        url                     = [NSString stringWithFormat:@"%@://%@/%@",scheme,host,path];
        url                     = [url stringByAddingURLParams:params];
    }
    
    return url;
}

+ (NSString *)urlForServiceWithIdentifier:(NSString *)identifier params:(NSDictionary *)params {
    NSString * url              = nil;
    
    if (identifier) {
        NSString * scheme       = [PAURLHelper appUrlScheme];
        NSString * host         = APPURL_HOST_SERVICE;
        NSString * path         = identifier;
        url                     = [NSString stringWithFormat:@"%@://%@/%@",scheme,host,path];
        url                     = [url stringByAddingURLParams:params];
    }
    
    return url;
}

@end
