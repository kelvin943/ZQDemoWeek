//
//  PAPageControllerTransitionCoordinatorImpl.h
//  manpanxiang
//
//  Created by Linkou Bian on 21/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAPageControllerTransitionCoordinator.h"

// 相对于协议，将 readonly 属性声明为 readwrite
@interface PAPageControllerTransitionCoordinatorContextImpl : NSObject<PAPageControllerTransitionCoordinatorContext>

@property (nonatomic, assign) NSTimeInterval transitionDuration;

@property (nonatomic, assign) NSInteger fromIndex;
@property (nonatomic, assign) NSInteger toIndex;

@property (nonatomic, strong) __kindof UIViewController *fromViewController;
@property (nonatomic, strong) __kindof UIViewController *toViewController;

// 子 VC 间的切换是否被取消
@property (nonatomic, assign, getter=isCancelled) BOOL cancelled;
// scroll view 的 content offset 相对于 scroll view 的宽，如 2.1、2.15、2.2 等等
@property (nonatomic, assign) CGFloat relativeOffset;
// 子 VC 切换的触发来源，是用户手动还是程序自动
@property (nonatomic, assign) PAPageControllerTransitionTriggeredBy triggeredBy;

@end

#pragma mark -

// 相对于协议，增加如下方法
@interface PAPageControllerTransitionCoordinatorImpl : NSObject<PAPageControllerTransitionCoordinator>

- (instancetype)initWithContext:(id<PAPageControllerTransitionCoordinatorContext>)context;

// 为何不放到 protocol 中？这是给容器 VC 使用的，不是给容器 VC 的使用者使用！
- (void)startTransition;
- (void)updateTransitionProgress:(CGFloat)progress;
- (void)finishTransition:(BOOL)complete;

@end
