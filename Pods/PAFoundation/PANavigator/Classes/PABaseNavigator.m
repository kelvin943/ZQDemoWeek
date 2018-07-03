//
//  PABaseNavigator.m
//  haofang
//
//  Created by PengFeiMeng on 4/22/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PABaseNavigator.h"
#import "NSObject+Category.h"
#import "PAViewMap.h"

@interface PABaseNavigator()

/*!
 @property
 @abstract      存放viewcontroller相关信息,key是viewcontroller对象的identifier，
 value是PAViewDataModel对象
 */
@property (nonatomic, strong) NSMutableDictionary * viewModalDict;


@property (nonatomic, strong) UIViewController *modalContainerViewController;

@end

@implementation PABaseNavigator

#pragma mark - init

- (instancetype)init{
    if (self = [super init]) {
        //读取viewcontroller相关配置
        [self readViewControllerConfigurations];
    }
    
    return self;
}

#pragma mark - functions

- (void)readViewControllerConfigurations{
    NSString * viewMapPath = [[NSBundle mainBundle] pathForResource:@"viewMap" ofType:@"plist"];
    NSArray * viewMaps = [NSArray arrayWithContentsOfFile:viewMapPath];
    
    if (viewMaps && viewMaps.count) {
        for (NSDictionary * viewMap in viewMaps) {
            NSString * className  = [viewMap objectForKey:@"className"];
            NSString * identifier = [viewMap objectForKey:@"identifier"];
            
            if (className && className.length && identifier && identifier.length) {
                Class viewClass   = NSClassFromString(className);
                
                // PANavigatorProtocol协议规范的方法
                SEL initMethod    = @selector(initWithQuery:);
                SEL instanceMethod= @selector(doInitializeWithQuery:);
                
                // 创建viewcontroller配置对象
                PAViewDataModel * viewDataModel = [[PAViewDataModel alloc] init];
                viewDataModel.viewClass         = viewClass;
                viewDataModel.viewInitMethod    = [NSValue valueWithPointer:initMethod];
                viewDataModel.viewInstanceMethod= [NSValue valueWithPointer:instanceMethod];
                
                [self.viewModalDict setObject:viewDataModel forKey:identifier];
            }
        }
    }
}

- (void)mapIdentifier:(NSString *)identifier toController:(NSString *)className {
    if (className && className.length && identifier && identifier.length) {
        Class viewClass   = NSClassFromString(className);
        
        // PANavigatorProtocol协议规范的方法
        SEL initMethod    = @selector(initWithQuery:);
        SEL instanceMethod= @selector(doInitializeWithQuery:);
        
        // 创建viewcontroller配置对象
        PAViewDataModel * viewDataModel = [[PAViewDataModel alloc] init];
        viewDataModel.viewClass         = viewClass;
        viewDataModel.viewInitMethod    = [NSValue valueWithPointer:initMethod];
        viewDataModel.viewInstanceMethod= [NSValue valueWithPointer:instanceMethod];
        
        [self.viewModalDict setObject:viewDataModel forKey:identifier];
    }
}

- (id)checkIfViewClassExists:(Class)viewClass inStack:(NSArray *)stack{
    id controller           = nil;
    
    if (stack && viewClass) {
        for (int i = 0; i < stack.count; i++) {
            id object       = [stack objectAtIndex:i];
            
            if ([object isKindOfClass:viewClass]) {
               controller   = object;
            }
        }
    }
    
    return controller;
}

- (NSArray *)navigationStack{
    NSArray * stack             = nil;
    
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        stack                   = [(UINavigationController *)self.rootViewController viewControllers];
    }
    
    return stack;
}

#pragma mark - jump

- (UIViewController *)pushViewControllerWithViewDataModel:(PAViewDataModel *)viewDataModel animated:(BOOL)animated{
    UIViewController * controller           = nil;
    
    if (viewDataModel) {
        // 获取相关参数
        Class       viewClass               = viewDataModel.viewClass;
        SEL         initMethod              = [viewDataModel.viewInitMethod pointerValue];
        
        NSObject * object                   = nil;
        
        if (viewClass && initMethod) {
             object                          = [viewClass alloc];
            // 配置object
            [self configObject:object withViewDataModel:viewDataModel shouldCallInitMethod:YES];
            
            
            // 跳转
            if ([object isKindOfClass:[UIViewController class]]) {
                controller                  = (UIViewController *)object;
                [self pushViewController:controller animated:animated];
                viewDataModel.queryForInitMethod = nil;
            }
        }
    }
    
    return controller;
}

- (UIViewController *)pushViewControllerWithViewDataModel:(PAViewDataModel *)viewDataModel
                                               retrospect:(BOOL)retrospect
                                                 animated:(BOOL)animated{
    UIViewController *controller            = nil;
    
    // 不回溯，直接push一个新的viewcontroller
    if (!retrospect) {
        controller                          = [self pushViewControllerWithViewDataModel:viewDataModel animated:animated];
        
        return controller;
    }
    
    if (viewDataModel) {
        // viewcontroller相关参数
        Class       viewClass               = viewDataModel.viewClass;
        
        // 检查是否在导航堆栈中已经存在此类的viewcontroller
        controller                          = [self checkIfViewClassExists:viewClass inStack:[self navigationStack]];
        if (controller) {
            // 导航堆栈中存在这个类型的controller,那么跳转到这个controller
            // 配置controller
            [self configObject:controller withViewDataModel:viewDataModel shouldCallInitMethod:NO];
            
            // 跳转
            [self popToViewController:controller animated:animated];
            viewDataModel.queryForInitMethod = nil;
            
            return controller;
        }else{
            // 导航堆栈中不存在这个类型的controller,那么跳转到新的controller
            [self pushViewControllerWithViewDataModel:viewDataModel animated:animated];
        }
    }
    
    return controller;
}

#pragma mark - basic navigation

- (void)pushViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        if (controller && [controller isKindOfClass:[UIViewController class]]) {
            [(UINavigationController *)self.rootViewController pushViewController:controller animated:animated];
        }
    }
}


#pragma mark - Queued invocation

- (void)popToViewController:(UIViewController *)controller animated:(BOOL)animated{
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        if (controller && [controller isKindOfClass:[UIViewController class]] && [[(UINavigationController *)self.rootViewController viewControllers] containsObject:controller]) {
            [(UINavigationController *)self.rootViewController popToViewController:controller animated:animated];
        }
    }
}

#pragma mark - config

- (void)configObject:(NSObject *)object withViewDataModel:(PAViewDataModel *)viewDataModel shouldCallInitMethod:(BOOL)shouldCallInitMethod{
    if (viewDataModel && object) {
        // 获取相关参数
        Class       viewClass               = viewDataModel.viewClass;
        SEL         initMethod              = [viewDataModel.viewInitMethod pointerValue];
        SEL         instanceMethod          = [viewDataModel.viewInstanceMethod pointerValue];
        NSDictionary * queryForInitM        = viewDataModel.queryForInitMethod;
        NSDictionary * queryForInstanceM    = viewDataModel.queryForInstanceMethod;
        NSDictionary * propertyDict         = viewDataModel.propertyDictionary;
        
        //queryForInitM                       = queryForInitM == nil ? [NSDictionary dictionary] : queryForInitM;
        //queryForInstanceM                   = queryForInstanceM == nil ? [NSDictionary dictionary] : queryForInstanceM;
        
        
        if (viewClass && initMethod) {
            // 初始化
            if ([object respondsToSelector:initMethod] && shouldCallInitMethod) {
                NSArray * params            = nil;
                if (queryForInitM) {
                    params                  = @[queryForInitM];
                }
                [object performSelector:initMethod withObjects:params];
            }
            // 属性
            if (propertyDict) {
                for (NSString * key in propertyDict.allKeys) {
                    id value                = [propertyDict objectForKey:key];
                    SEL getMethod           = NSSelectorFromString(key);
                    if ([object respondsToSelector:getMethod]) {
                        [object setValue:value forKey:key];
                    }
                }
            }
            // 实例方法
            if ([object respondsToSelector:instanceMethod]) {
                NSArray * params            = nil;
                if (queryForInstanceM) {
                    params                  = @[queryForInstanceM];
                }
                [object performSelector:instanceMethod withObjects:params];
            }
        }
    }
}

#pragma mark - setter/getter

- (NSMutableDictionary *)viewModalDict{
    if (_viewModalDict == nil) {
        _viewModalDict          = [NSMutableDictionary dictionary];
    }
    
    return _viewModalDict;
}

- (PAViewDataModel *)viewDataModelForIdentifier:(NSString *)identifier{
    PAViewDataModel * viewDataModel         = nil;
    
    viewDataModel                           = [self.viewModalDict objectForKey:identifier];
    
    return viewDataModel;
}

- (UIViewController *)rootViewController {
    if (!_rootViewController) {
        _rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    }
    
    return _rootViewController;
}

- (UIViewController *)topViewController{
    UIViewController * controller   = nil;
    
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        controller                  = [(UINavigationController *)self.rootViewController topViewController];
    }
    
    return controller;
}

- (UIViewController *)visibleViewController{
    UIViewController * controller   = nil;
    
    if (self.rootViewController && [self.rootViewController isKindOfClass:[UINavigationController class]]) {
        controller                  = [(UINavigationController *)self.rootViewController visibleViewController];
    }
    
    return controller;
}

@end


@implementation PABaseNavigator (PAViewController)

- (void)viewExit:(NSDictionary *)query{
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        BOOL animated = YES;
        if (query) {
            NSString * animatedString   = [query objectForKey:APPURL_PARAM_ANIMATED];
            if (animatedString) {
                animated                = [animatedString boolValue];
            }
        }
        [(UINavigationController *)self.rootViewController popViewControllerAnimated:animated];
    }
}

- (void)popToRoot:(NSDictionary *)query{
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        BOOL animated = YES;
        if (query) {
            NSString * animatedString   = [query objectForKey:APPURL_PARAM_ANIMATED];
            if (animatedString) {
                animated                = [animatedString boolValue];
            }
        }
        [(UINavigationController *)self.rootViewController popToRootViewControllerAnimated:animated];
    }
}

@end
