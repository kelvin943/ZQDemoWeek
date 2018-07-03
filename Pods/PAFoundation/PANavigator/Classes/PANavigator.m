//
//  PANavigator.m
//  haofang
//
//  Created by PengFeiMeng on 4/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PANavigator.h"
#import "PAURLHelper.h"
#import "NSString+URL.h"

BOOL openURL(NSString * url){
    BOOL handles = [[PANavigator sharedInstance] openURL:url];
    
    return handles;
}

@implementation PANavigator

+ (instancetype)sharedInstance {
    static PANavigator *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PANavigator alloc] init];
    });
    
    return _sharedInstance;
}

#pragma mark - open url
- (BOOL)openURL:(NSString *)url{
    BOOL handled = NO;
    
    if (url) {
        NSURL * URL         = [NSURL URLWithString:url];

        NSString * scheme   = URL.scheme;
        NSString * host     = URL.host;
        NSString * query    = URL.query;
        NSString * fragment = URL.fragment;
        NSString * path     = URL.path;
        
        //去除path前的“/”字符
        if (path && path.length) {
            path                = [path substringFromIndex:1];
        }
        
#pragma unused(scheme)
#pragma unused(host)
#pragma unused(query)
#pragma unused(fragment)
#pragma unused(path)
        
        UIViewController *controller                = nil;
        
        if ([PAURLHelper isAppURL:URL]) {
            
            if ([host isEqualToString:APPURL_HOST_VIEW]) {
                NSString * viewIdentifier           = path;
                NSDictionary * params               = [query getURLParams];
                NSString * retrospect               = [params objectForKey:APPURL_PARAM_RETROSPECT];
                NSString * animated                 = [params objectForKey:APPURL_PARAM_ANIMATED];
                BOOL shouldRetrospect               = retrospect ? [retrospect boolValue] : NO;
                BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;
                
                PAViewDataModel * viewDataModel     = [self viewDataModelForIdentifier:viewIdentifier];
                viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:params];
                viewDataModel.viewInstanceMethod    = nil;
                viewDataModel.queryForInstanceMethod= nil;
                viewDataModel.propertyDictionary    = params;
                
                controller = [self pushViewControllerWithViewDataModel:viewDataModel retrospect:shouldRetrospect animated:shouldAnaimate];
            }else if ([host isEqualToString:APPURL_HOST_SERVICE]){
                NSString * function                 = path;
                NSDictionary * params               = [query getURLParams];
                
                SEL selector                        = NSSelectorFromString([NSString stringWithFormat:@"%@:",function]);
                
                [self processService:selector params:params];
            }
            
            handled                                 = YES;
            
        } else if([PAURLHelper isWebURL:URL]){
            // 对url判断，并进行相关处理，比如是否使用webview打开，还是使用safari打开，
            // 若在webview中打开，那么可以一些配置，比如title，是否需要导航栏等
            // 默认使用webview打开
            NSDictionary * params                   = [query getURLParams];
            NSString * openWith                     = [params objectForKey:@"_openWith"];
            NSString * title                        = [params objectForKey:@"_title"];
            NSString * needsNavigationBar           = [params objectForKey:@"_needsNavigationBar"];
            NSString * hideEstimatedProgress        = [params objectForKey:@"_hideEstimatedProgress"];
            NSString * reloadWhenViewAppear         = [params objectForKey:@"_reloadWhenViewAppear"];
            
            // 移除参数
            NSString * newUrlString                 = url;
            newUrlString                            = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_openWith",openWith]
                                                                                     withString:@""];
            newUrlString                            = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_title",title]
                                                                                     withString:@""];
            newUrlString                            = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_needsNavigationBar",needsNavigationBar]
                                                                                     withString:@""];
            newUrlString                            = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_hideEstimatedProgress",hideEstimatedProgress]
                                                                                              withString:@""];
            newUrlString                            = [newUrlString stringByReplacingOccurrencesOfString:
                                                       [NSString stringWithFormat:@"%@=%@",@"_reloadWhenViewAppear",reloadWhenViewAppear]
                                                                                              withString:@""];
            
            if (openWith && [openWith isEqualToString:@"browser"]) {
                // 使用浏览器打开
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newUrlString]];
            } else{
                // 使用webview打开
                title                               = title ? title : @"";
                hideEstimatedProgress               = hideEstimatedProgress ? hideEstimatedProgress : @"false";
                reloadWhenViewAppear                = reloadWhenViewAppear ? reloadWhenViewAppear : @"false";
                
                NSMutableDictionary * jumpParams           = @{@"_title": title, @"_hideEstimatedProgress": hideEstimatedProgress, @"_url": newUrlString, @"_reloadWhenViewAppear":reloadWhenViewAppear}.mutableCopy;
                if (needsNavigationBar) {
                    jumpParams[@"_needsNavigationBar"] = needsNavigationBar;
                }
                
                NSString * viewIdentifier           = APPURL_VIEW_IDENTIFIER_WEBVIEW;
                NSString * retrospect               = [params objectForKey:APPURL_PARAM_RETROSPECT];
                NSString * animated                 = [params objectForKey:APPURL_PARAM_ANIMATED];
                BOOL shouldRetrospect               = retrospect ? [retrospect boolValue] : ((openWith && [openWith isEqualToString:@"webView_Keep"])?YES:NO);
                BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;
                
                controller = [self gotoViewWithIdentifier:viewIdentifier
                                             queryForInit:jumpParams
                                         queryForInstance:nil
                                       propertyDictionary:@{@"urlString": newUrlString}
                                               retrospect:shouldRetrospect
                                                 animated:shouldAnaimate];
            }
            
            handled                                 = YES;
            
        } else{
            [[UIApplication sharedApplication] openURL:URL];
            
            handled                                 = YES;
        }
        
        // 截取H5传入的参数，用于统计
        if (self.delegate && [self.delegate respondsToSelector:@selector(navigator:didOpenURL:withDestinatedController:)]) {
            [self.delegate navigator:self didOpenURL:URL withDestinatedController:controller];
        }
    }
    
    return handled;
}

#pragma mark - jump
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary{
    if (identifier) {
        PAViewDataModel * viewDataModel     = [self viewDataModelForIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.propertyDictionary    = propertyDictionary;
        viewDataModel.viewInstanceMethod    = nil;
        viewDataModel.queryForInstanceMethod= nil;
        
        NSString * animated                 = [initParams objectForKey:APPURL_PARAM_ANIMATED];
        BOOL shouldAnaimate                 = animated ? [animated boolValue] : YES;
        [self pushViewControllerWithViewDataModel:viewDataModel animated:shouldAnaimate];
    }
}

- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary{
    if (identifier) {
        PAViewDataModel * viewDataModel     = [self viewDataModelForIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.propertyDictionary    = propertyDictionary;
        viewDataModel.viewInstanceMethod    = [NSValue valueWithPointer:@selector(doInitializeWithQuery:)];
        viewDataModel.queryForInstanceMethod= [NSMutableDictionary dictionaryWithDictionary:instanceParams];
        
        [self pushViewControllerWithViewDataModel:viewDataModel animated:YES];
    }
}

- (UIViewController *)gotoViewWithIdentifier:(NSString *)identifier
                                queryForInit:(NSDictionary *)initParams
                            queryForInstance:(NSDictionary *)instanceParams
                          propertyDictionary:(NSDictionary *)propertyDictionary
                                  retrospect:(BOOL)retrospect
                                    animated:(BOOL)animated{
    if (identifier) {
        PAViewDataModel * viewDataModel     = [self viewDataModelForIdentifier:identifier];
        viewDataModel.queryForInitMethod    = [NSMutableDictionary dictionaryWithDictionary:initParams];
        viewDataModel.propertyDictionary    = propertyDictionary;
        viewDataModel.viewInstanceMethod    = [NSValue valueWithPointer:@selector(doInitializeWithQuery:)];
        viewDataModel.queryForInstanceMethod= [NSMutableDictionary dictionaryWithDictionary:instanceParams];
        
        return [self pushViewControllerWithViewDataModel:viewDataModel retrospect:retrospect animated:animated];
    }
    
    return nil;
}

#pragma mark - perform

//
// 当迁移到 ARC 时，下面代码遇到过 performSelector may cause a leak because its selector is unknown
//
// 解决办法来自 wbyoung
// https://stackoverflow.com/a/20058585
//
- (void)processService:(SEL)selector params:(NSDictionary *)params{
    if (!selector) {
        return;
    }
    
    if (self.topViewController && [self.topViewController respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))[self.topViewController methodForSelector:selector])(self.topViewController, selector, params);
    }else if ([self respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))[self methodForSelector:selector])(self, selector, params);
    }
}

@end
