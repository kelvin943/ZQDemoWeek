//
//  PANavigationViewController.m
//  haofang
//
//  Created by PengFeiMeng on 3/25/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PANavigationViewController.h"
#import "PAViewController.h"

@interface PANavigationViewController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL inTransition;

@end

@implementation PANavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interactivePopGestureRecognizer.delegate = self;
    [self.interactivePopGestureRecognizer addTarget:self action:@selector(panOnViewController:)];
    self.delegate = self;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.inTransition = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    self.inTransition = NO;
    
    // 对于 root 的控制器，关闭动作识别
    self.interactivePopGestureRecognizer.enabled = [self.viewControllers count] > 1;
    
    if ([viewController.class conformsToProtocol:@protocol(PAViewControllerProtocol)]) {
        UIViewController<PAViewControllerProtocol> *vc = (UIViewController<PAViewControllerProtocol> *)viewController;
        
        // 调用可选方法前先判断
        if ([vc respondsToSelector:@selector(disableInteractiveGesture)]) {
            self.interactivePopGestureRecognizer.enabled = ![vc disableInteractiveGesture];
        }
    }
}

- (void)panOnViewController : (UIGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            self.inTransition = NO;
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return (gestureRecognizer == self.interactivePopGestureRecognizer && !self.inTransition);
}

@end
