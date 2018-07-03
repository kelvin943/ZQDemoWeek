//
//  PANavigator.h
//  haofang
//
//  Created by PengFeiMeng on 4/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PABaseNavigator.h"

// 打开url
BOOL openURL(NSString * url);

#pragma mark -

@protocol PANavigatorDelegate <NSObject>

@optional
- (void)navigator:(PABaseNavigator *)navigator didOpenURL:(NSURL *)url withDestinatedController:(UIViewController *)controller;

@end

#pragma mark -

@interface PANavigator : PABaseNavigator

@property (nonatomic, strong) id<PANavigatorDelegate> delegate;

// 单例
+ (instancetype)sharedInstance;

/*!
 @method
 @abstract      打开url链接
 @param         url 要打开的url
 @discussion    url可以使用类 PAURLMap 中提供的方法来生成
 @return        BOOL
 */
- (BOOL)openURL:(NSString *)url;


/*!
 @method
 @abstract      根据配置参数进行页面跳转
 @param         identifier view标识，用来索引相应的viewcontroller
 @param         initParams 初始化方法参数，初始化方法需遵从PANavigatorProtocol协议中initWithQuery:
 @param         propertyDictionary 属性字典，存放了ViewController相应的属性key，value
 @discussion    使用示例：
                [[PANavigator sharedInstance] gotoViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW queryForInit:@{@"_url": @"http://www.baidu.com"} propertyDictionary:@{@"title": @"你好"}];
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
            propertyDictionary:(NSDictionary *)propertyDictionary;

/*!
 @method
 @abstract      根据配置参数进行页面跳转
 @param         identifier view标识，用来索引相应的viewcontroller
 @param         initParams 初始化方法参数，初始化方法需遵从PANavigatorProtocol协议
 @param         instanceParams 实例化方法参数,需遵从PANavigatorProtocol协议
 @param         propertyDictionary 属性字典，存放了相应的属性key，value
 @discussion    使用示例：
                [[PANavigator sharedInstance] gotoViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW queryForInit:@{@"_url": @"http://www.baidu.com"} propertyDictionary:@{@"title": @"你好"}];
 */
- (void)gotoViewWithIdentifier:(NSString *)identifier
                  queryForInit:(NSDictionary *)initParams
              queryForInstance:(NSDictionary *)instanceParams
            propertyDictionary:(NSDictionary *)propertyDictionary;


/*!
 @method
 @abstract      根据配置参数进行页面跳转
 @param         identifier view标识，用来索引相应的viewcontroller
 @param         initParams 初始化方法参数，初始化方法需遵从PANavigatorProtocol协议
 @param         instanceParams 实例化方法参数,需遵从PANavigatorProtocol协议
 @param         propertyDictionary 属性字典，存放了相应的属性key，value
 @param         retrospect 是否回溯，即当viewcontroller已经在导航堆栈中，是否要跳转回去到这个页面
 @param         animated 是否需要页面切换效果
 @return        UIViewController 将要打开的VC

 @discussion    使用示例：
                [[PANavigator sharedInstance] gotoViewWithIdentifier:APPURL_IDENTIFIER_WEBVIEW queryForInit:@{@"_url": @"http://www.baidu.com"} propertyDictionary:@{@"title": @"你好"}];
 */
- (UIViewController *)gotoViewWithIdentifier:(NSString *)identifier
                                queryForInit:(NSDictionary *)initParams
                            queryForInstance:(NSDictionary *)instanceParams
                          propertyDictionary:(NSDictionary *)propertyDictionary
                                  retrospect:(BOOL)retrospect
                                    animated:(BOOL)animated;

@end
