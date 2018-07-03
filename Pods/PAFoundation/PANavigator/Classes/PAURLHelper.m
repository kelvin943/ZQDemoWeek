//
//  PAURLHelper.m
//  haofang
//
//  Created by PengFeiMeng on 5/1/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAURLHelper.h"
#import "PAMediator+AppConfig.h"

@implementation PAURLHelper

+ (BOOL)isWebURL:(NSURL*)URL {
    return [URL.scheme caseInsensitiveCompare:@"http"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"https"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"ftp"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"ftps"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"data"] == NSOrderedSame
    || [URL.scheme caseInsensitiveCompare:@"file"] == NSOrderedSame;
}

+ (BOOL)isAppURL:(NSURL *)URL {
    if (!URL) return NO;
    
    if ([URL.scheme length] == 0)
        return NO;
    
    BOOL flag               = NO;
    
    NSString * appScheme    = [PAURLHelper appUrlScheme];
    flag                    = [URL.scheme caseInsensitiveCompare:appScheme] == NSOrderedSame;
    
    return flag;
}

+ (NSString *)appUrlScheme {
    NSString * urlScheme = nil;
    NSString * expectedUrlSchemeIdentifier = [[PAMediator sharedInstance] URLSchemeIdnentifier];
    
    NSArray * schemes    = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
    
    for (NSDictionary * scheme in schemes) {
        NSString * identifier = [scheme objectForKey:@"CFBundleURLName"];
        
        if (identifier && [identifier isEqualToString:expectedUrlSchemeIdentifier]) {
            NSArray * items   = [scheme objectForKey:@"CFBundleURLSchemes"];
            if (items && items.count) {
                urlScheme         = [items objectAtIndex:0];
                break;
            }
        }
    }
    
    return urlScheme;
}

@end
