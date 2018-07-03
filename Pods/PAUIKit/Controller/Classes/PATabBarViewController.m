//
//  PATabBarViewController.m
//  haofang
//
//  Created by PengFeiMeng on 3/25/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PATabBarViewController.h"
#import "UIViewController+PAFullscreenPage.h"

@interface PATabBarViewController ()

@end

@implementation PATabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

- (instancetype)initWithQuery:(NSDictionary *)query{
    self = [super init];
    if (self) {
        if (query && [query isKindOfClass:[NSDictionary class]]) {
        }
    }
    
    return self;
}

//- (void)doInitializeWithQuery:(NSDictionary *)query {
//
//    // 把回溯拿到的字典参数，回传给TabBarController的子controller，子controller可根据传入参数，处理响应逻辑
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:query];
//    // 剔除回溯以及传给TabBarController的字段以免干扰
//    [params removeObjectForKey:@"selectedIndex"];
//    [params removeObjectForKey:@"_retrospect"];
//
//    UIViewController *vc = self.viewControllers[self.selectedIndex];
//    if ([vc respondsToSelector:@selector(doInitializeWithQuery:)]) {
//        [vc performSelector:@selector(doInitializeWithQuery:) withObject:params];
//    }
//
//}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    // 将代码切换tab和手动切换tab二者统一, 这两种场景进入页面隐藏或显示导航栏时不应出现动画
    UIViewController *vc = self.viewControllers[selectedIndex];
    vc.pa_fromTabbarSelection = YES;
    
    [super setSelectedIndex:selectedIndex];    
}

#pragma mark - Override

// TabBar Controller 也是放在 Nav 中的，并不需要为 TabBar Controller 注入全屏处理相关的代码
- (BOOL)pa_willAppearInjectBlockIgnored {
    return YES;
}

// TabBar Controller 也是放在 Nav 中的，并不需要设置返回按钮;
// 当然也可以通过协议方法 shouldSetBackBarButton 控制.
- (void)setBackBarButton{
    
}

@end
