//
//  PABaseWebViewController.m
//  manpanxiang
//
//  Created by Linkou Bian on 19/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PABaseWebViewController.h"
#import "PAWebViewJavascriptPOST_HTML.h"

#import "PAMediator+AppConfig.h"

#import "UIBarButtonItem+Category.h"
#import "NSString+URL.h"
#import "UIColor+Category.h"

#import "PAURLHelper.h"
#import "PANavigator.h"

@interface PAWKProcessPool : WKProcessPool

+ (instancetype)sharedInstance;

@end

@implementation PAWKProcessPool

+ (instancetype)sharedInstance {
    static PAWKProcessPool *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PAWKProcessPool alloc] init];
    });
    
    return _sharedInstance;
}

@end

typedef NS_ENUM(NSInteger, PAWebViewLoadType) {
    PAWebViewLoadTypeGetURLString   = 1,        // 从 URL 通过 Get 方式加载
    PAWebViewLoadTypePOSTURLString,             // 以 POST 方式加载
    PAWebViewLoadTypeLocalHTML,                 // 加载 Bundle 中的 HTML
};

@interface PABaseWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UIProgressView    *progressView;

@property(nonatomic,assign)   PAWebViewLoadType loadType;

@property (nonatomic, copy)   NSString          *expectedTitle;
@property(nonatomic, assign)  BOOL              needLoadJSPOST; // JS 发送 POST 的 Flag，为真的时候会调用 JS 的 POST 方法，防止重复表单提交
@property (nonatomic, strong) NSDictionary      *postParams;
@property (nonatomic, assign) BOOL              reloadWhenViewAppear;        // 是否在viewWillAppear刷新

@property (nonatomic, copy)   NSArray           *webViewKeyPathsToObserve;

@end

@implementation PABaseWebViewController

- (instancetype)initWithQuery:(NSDictionary *)query {
    if (self = [super init]) {
        if (query && [query isKindOfClass:[NSDictionary class]] ) {
            self.expectedTitle                  = [query objectForKey:@"_title"];
            self.titleLocked                    = [[query objectForKey:@"_titleLocked"] boolValue];
            self.URLString                      = [query objectForKey:@"_url"];
            self.postParams                     = [query objectForKey:@"_postParams"];
            self.reloadWhenViewAppear           = [[query objectForKey:@"_reloadWhenViewAppear"] boolValue];
            
            NSString *needsNavigationBar        = [query objectForKey:@"_needsNavigationBar"];
            self.needsNavigationBar             = needsNavigationBar ? [NSNumber numberWithBool:[needsNavigationBar boolValue]] : @YES;
            
            self.hideEstimatedProgress          = [[query objectForKey:@"_hideEstimatedProgress"] boolValue];
            
            // 开发过程中发现加载百度的很多页面并没有执行到 didFinish，所以采用 KVO 监听 title 和 canGoBack
            _webViewKeyPathsToObserve = @[NSStringFromSelector(@selector(title)),
                                          NSStringFromSelector(@selector(estimatedProgress)),
                                          NSStringFromSelector(@selector(canGoBack))];
        }
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.expectedTitle;
    
    [self setupWebViewJavascriptBridge];
    [self loadWebPage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.reloadWhenViewAppear) {
        [self reload];
    }
}

// 此处若不设置宽高，WebView 内容可能无法完整显示
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.wkWebView.frame = CGRectMake(CGRectGetMinX(self.wkWebView.frame), CGRectGetMinY(self.wkWebView.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
}

-(void)dealloc{
    NSLog(@"PAWebViewController dealloc");
    
    for (NSString *keyPath in self.webViewKeyPathsToObserve) {
        [self.wkWebView removeObserver:self forKeyPath:keyPath];
    }
}

#pragma mark - Public Methods

- (void)reload {
    if ([self.wkWebView isLoading]) {
        return;
    }
    
    [self loadWebPage];
}

#pragma mark - Template Methods

- (void)setupWebViewJavascriptBridge {
    // 模板方法，由子类定制
}

- (void)configCookieWhenLoadRequest:(NSMutableURLRequest *)request {
    // 模板方法，由子类定制
}

- (void)customizeHTTPHeaderFieldsForRequest:(NSMutableURLRequest *)request {
    // 模板方法，由子类定制
}

- (void)configureNavigationBar {
    // 模板方法，默认实现
    NSString *backIconCode = [[PAMediator sharedInstance] PAICONFONT_BACK];
    
    if (self.loadType == PAWebViewLoadTypePOSTURLString) {
        self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem barItemWithIconTitle:backIconCode target:self action:@selector(tapClose:)]];
        
    }
#ifdef DEBUG
    else if ([self.wkWebView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem barItemWithIconTitle:backIconCode target:self action:@selector(tapBack:)],
                                                   [UIBarButtonItem barItemWithTextTitle:@"关闭" target:self action:@selector(tapClose:)]];
    }
#endif
    else {
        self.navigationItem.leftBarButtonItems = @[[UIBarButtonItem barItemWithIconTitle:backIconCode target:self action:@selector(tapBack:)]];
    }
}

- (void)onFailedProvisionalNavigationWithError:(NSError *)error {
    // 模板方法，由子类定制
}

#pragma mark - Private Methods

- (void)loadWebPage {
    switch (self.loadType) {
        case PAWebViewLoadTypeGetURLString: {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
            
            // 使得 PHP 能从 $_COOKIE 对象中获取到 Cookie
            [self configCookieWhenLoadRequest:request];
            
            // 使得 PHP 能从 Header 中取得自定义的数据
            [self customizeHTTPHeaderFieldsForRequest:request];
            
            [self.wkWebView loadRequest:request];
            
            break;
        }
        case PAWebViewLoadTypePOSTURLString: {
            self.needLoadJSPOST = YES;
            
            // 借助本地 JS 完成 POST 请求
            NSString *html = PAWebViewJavascriptPOST_html();
            [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
            
            break;
        }
        case PAWebViewLoadTypeLocalHTML: {
            // iOS 9 & above
            NSURL *baseURL = [[[NSBundle mainBundle] bundleURL] URLByAppendingPathComponent:@"www"];
            [self.wkWebView loadFileURL:[NSURL fileURLWithPath:self.URLString] allowingReadAccessToURL:baseURL];
            
            break;
        }
    }
}

// 调用 JS 发送 POST 请求
- (void)postRequestWithJS {
    NSMutableString *mutableString = [NSMutableString new];
    for (NSString *key in self.postParams) {
        [mutableString appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key, [self.postParams objectForKey:key]]];
    }
    [mutableString deleteCharactersInRange:NSMakeRange(mutableString.length - 1, 1)];
    
    // 拼装成调用 JavaScript 的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, mutableString];
    // 调用 JS 代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
        NSLog(@"WKWebView posted params via local js function");
    }];
}

#pragma mark - Target Action Methods

- (void)tapBack:(id)sender {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    } else {
        [self backTo];
    }
}

- (void)tapClose:(id)sender {
    [self backTo];
}

#pragma mark - WKNavigationDelegate Methods

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 忽略 WVJB 的 URL 以避免重复执行 handler
    // @see https://github.com/marcuswestin/WebViewJavascriptBridge/issues/267
    WebViewJavascriptBridgeBase *bridgeBase = [self.bridge valueForKey:@"_base"];
    if ([bridgeBase isWebViewJavascriptBridgeURL:navigationAction.request.URL]) {
        return;
    }
    
    // NSLog(@"WKWebView URL: %@", navigationAction.request.URL);
    // NSLog(@"decidePolicyForNavigationAction | %zd", navigationAction.navigationType);
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    switch (navigationAction.navigationType) {
        case WKNavigationTypeLinkActivated: {
            policy = [self processURL:navigationAction.request.URL];
            break;
        }
        case WKNavigationTypeOther: {
            policy = [self processURL:navigationAction.request.URL];
            break;
        }
        default: {
            break;
        }
    }
    
    decisionHandler(policy);
}

- (WKNavigationActionPolicy)processURL:(NSURL *)url {
    WKNavigationActionPolicy policy = WKNavigationActionPolicyAllow;
    
    if ([PAURLHelper isAppURL:url]) {
        // manpanxiang://
        openURL(url.absoluteString);
        policy = WKNavigationActionPolicyCancel;
        
    } else if ([url.absoluteString hasPrefix:@"tel"] || [url.absoluteString hasPrefix:@"sms"]) {
        // WKWebview 不能识别的协议类型：phone, email, maps, etc.
        [[UIApplication sharedApplication] openURL:url];
        policy = WKNavigationActionPolicyCancel;
        
    } else {
        // http://
        NSDictionary *params = [url.query getURLParams];
        NSString *openWith = [params objectForKey:@"_openWith"];
        
        // 用 Safari 打开
        if ([openWith isEqualToString:@"browser"]){
            [[UIApplication sharedApplication] openURL:url];
            policy = WKNavigationActionPolicyCancel;
            
        }
        // 新页面打开
        else if ([openWith isEqualToString:@"webView_Blank"]) {
            openURL(url.absoluteString);
            policy = WKNavigationActionPolicyCancel;
            
        }
        // 同一页面打开
        else if ([openWith isEqualToString:@"webView_Keep"]) {
            policy = WKNavigationActionPolicyAllow;
            
        }
        else {
            policy = WKNavigationActionPolicyAllow;
        }
    }
    
    return policy;
}

// 开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    // 显示加载进度条
    self.progressView.hidden = self.hideEstimatedProgress;
    
    // 显示状态栏菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (!self.titleLocked) self.title = @"正在载入...";
    
    // 清除右上角按钮
    [self clearNavigationBar];
}

// 这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用）
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用 JS 发送 POST 请求
        [self postRequestWithJS];
        
        // 将 Flag 置为 NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    
    // 获取加载网页的标题
    if (!self.titleLocked) self.title = self.wkWebView.title;
    
    // 禁用 WebView 的长按交互
    [self disableTouchCallout];
    [self disableUserSelect];
    
    // 隐藏状态栏菊花
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    // 配置左上角按钮
    [self configureNavigationBar];
}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Error: Failed to load web page with error:\n%@", error);
    
    // Ignore NSURLErrorDomain error -999.
    if([error code] == NSURLErrorCancelled) return;
    // Ignore "Fame Load Interrupted" errors. Seen after app store links.
    if (error.code == 102 && [error.domain isEqual:@"WebKitErrorDomain"]) return;
    
    [self onFailedProvisionalNavigationWithError:error];
    
    if (!self.titleLocked) self.title = @"加载失败";
    
    [self clearNavigationBar];
}

// 跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"Error: Webview failed to navigate with error:\n%@", error);
}

// 当 WKWebView 总体内存占用过大，页面即将白屏的时候会调用
//
// 腾讯分享的文章称，此时 webView.URL 取值尚不为 nil，可以执行 [webView reload] 解决白屏问题。
// 在 WKWebView 白屏的时候，另一种现象是 webView.titile 会被置空。因此，可以在 viewWillAppear 的时候
// 检测 webView.title 是否为空来 reload 页面。
//
// 目前没有遇到问题，只是纯打印
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"Error: Webview content process did terminate :-(");
    NSLog(@"URL: %@", webView.URL);
    NSLog(@"Title: %@", webView.title);
}

// 对于 HTTPS 都会触发此代理
// https://forums.developer.apple.com/thread/15610
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler{
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    CFDataRef exceptions = SecTrustCopyExceptions(serverTrust);
    SecTrustSetExceptions(serverTrust, exceptions);
    CFRelease(exceptions);
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:serverTrust]);
    
}

#pragma mark - WKWebView UIDelegate

// 如果不实现，网页的 alert 函数无效
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {    // js 里面的alert实现，如果不实现，网页的alert函数无效
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler();
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

// 如果不实现，网页的 alert 函数无效
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          completionHandler(YES);
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action){
                                                          completionHandler(NO);
                                                      }]];
    
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - User Interaction

// 禁止用户选择
- (void)disableUserSelect{
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
}

// 禁用长按弹出框
- (void)disableTouchCallout{
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
}

#pragma mark - KVO

// 监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object != self.wkWebView) {
        return;
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]) {
        
        if (self.hideEstimatedProgress) {
            return;
        }
        
        [self.progressView setAlpha:1.0f];
        
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
        
        return;
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(title))]) {
        if (!self.titleLocked && [self.wkWebView.title length] > 0) {
            self.title = self.wkWebView.title;
        }
        
        return;
    }
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(canGoBack))]) {
        [self configureNavigationBar];
        
        return;
    }
}

#pragma mark - Override

- (void)clearNavigationBar {
    self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL)pa_prefersNavigationBarHidden {
    return ![self.needsNavigationBar boolValue];
}

#pragma mark - Properties

- (WKWebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
        [_bridge setWebViewDelegate:self];
        
        // 我们在 WKWebView 中已预注入 Bridge 相关 JS 代码，不会出现注入前从 native 端调用 bridge 服务
        // 故而不需要处理 startupmessageQueue 中的消息（也不应该有消息）。
        // 因此直接置该 queue 为 nil 以使得 native 调用时发起的消息直接被处理，而不是被放到这个 queue 中。
        //
        // 如果想和 __BRIDGE_LOADED__ 消息处理过程一致，即一方面注入 JS 另一方面处理 queue，
        // 可以给 bridge 增加个 category 方法，processStartupMessageInQueue
        //
        WebViewJavascriptBridgeBase *bridgeBase = [_bridge valueForKey:@"_base"];
        bridgeBase.startupMessageQueue = nil;
    }
    
    return _bridge;
}

extern NSString * WebViewJavascriptBridge_js();

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.allowsInlineMediaPlayback = YES;
        
        WKPreferences *preferences = [[WKPreferences alloc] init];
        preferences.minimumFontSize = 10;
        configuration.preferences = preferences;
        
        WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        configuration.userContentController = userContentController;
        
        // 提前注入 Bridge 所需的 JS 代码，省的前端调用 setupWebViewJavascriptBridge 才触发
        NSString *js = [NSString stringWithFormat:@"%@%@", @";window.WVJBCallbacks = []", WebViewJavascriptBridge_js()];
        WKUserScript *userScript = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [configuration.userContentController addUserScript:userScript];
        
        // Use a WKProcessPool to share cookies between web views.
        configuration.processPool = [PAWKProcessPool sharedInstance];
        
        _wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _wkWebView.backgroundColor = [UIColor colorWithHex:0xF0F0F0];
        if ([_wkWebView respondsToSelector:@selector(setAllowsLinkPreview:)]) {
            _wkWebView.allowsLinkPreview = NO; // In iOS 10 and later, the default value is true; before that, the default value is false.
        }
        
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; // iOS11 以后加载本地页面引起内容向下偏移问题
        }
        
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        // KVO 加载进度
        for (NSString *keypath in self.webViewKeyPathsToObserve) {
            [_wkWebView addObserver:self forKeyPath:keypath options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    
    return _wkWebView;
}

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 5);
        [_progressView setTrackTintColor:[UIColor whiteColor]];
        _progressView.progressTintColor = [UIColor colorWithHex:0x50A0E6];
    }
    return _progressView;
}

- (PAWebViewLoadType)loadType {
    if (self.postParams) {
        _loadType = PAWebViewLoadTypePOSTURLString;
    } else if ([self.URLString hasPrefix:@"/"]) {
        _loadType = PAWebViewLoadTypeLocalHTML;
    } else {
        _loadType = PAWebViewLoadTypeGetURLString;
    }
    
    return _loadType;
}

@end
