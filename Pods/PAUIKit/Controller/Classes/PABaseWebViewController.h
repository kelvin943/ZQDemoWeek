//
//  PABaseWebViewController.h
//  manpanxiang
//
//  Created by Linkou Bian on 19/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "PAViewController.h"
#import "WKWebViewJavascriptBridge.h"

/**
 满盘享 1.0 中的页面都是 H5 (包括登录、Tab 页等)，而且每个特定的 H5 页面 Controller 需要自定义，所以挪了下列属性到头文件中。
 */
@interface PABaseWebViewController : PAViewController

@property (nonatomic, strong) WKWebView         *wkWebView;
@property (nonatomic, copy)   NSString          *URLString;
@property (nonatomic, assign) BOOL              titleLocked;            // 锁定标题，不随 webview 加载而变化
@property (nonatomic, assign) BOOL              hideEstimatedProgress;  // 隐藏进度条
@property (nonatomic, strong) NSNumber          *needsNavigationBar;    // 是否显示导航栏

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

/**
 重新根据 URL 构造 Request 去 reload 的方式，出现白屏的概率较采用 WebView 的 reload 低，但会丢失先前的浏览位置。
 */
- (void)reload;

#pragma mark - Template Methods

/**
 在 Web 容器 didLoad 时调用
 
 默认实现：空
 */
- (void)setupWebViewJavascriptBridge;

/**
 由 Web 容器在加载 Get 请求时调用，设置 APP 定制的请求头
 
 默认实现：空
 */
- (void)customizeHTTPHeaderFieldsForRequest:(NSMutableURLRequest *)request;

/**
 Web 容器 didFinishNavigation 时调用，可在此处设置 返回/关闭 按钮。
 
 默认实现：在 WebView 可返回时，仅在 DEBUG 模式显示 关闭 按钮。
 */
- (void)configureNavigationBar;

/**
 在 Web 容器 didFailProvisionalNavigation 时调用
 
 默认实现：空
 */
- (void)onFailedProvisionalNavigationWithError:(NSError *)error;

@end
