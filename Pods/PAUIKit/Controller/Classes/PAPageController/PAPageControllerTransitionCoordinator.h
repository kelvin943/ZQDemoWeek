//
//  PAPageControllerTransitionCoordinator.h
//  manpanxiang
//
//  Created by Linkou Bian on 21/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PAPageControllerTransitionTriggeredBy) {
    PAPageControllerTransitionTriggeredByUser,
    PAPageControllerTransitionTriggeredByProgram
};

@protocol PAPageControllerTransitionCoordinatorContext;

typedef void(^PAPageControllerTransitionAnimationBlock)(id<PAPageControllerTransitionCoordinatorContext> context);
typedef void(^PAPageControllerTransitionCompletionBlock)(id<PAPageControllerTransitionCoordinatorContext> context);

#pragma mark -

@protocol PAPageControllerTransitionCoordinatorContext <NSObject>

@property (nonatomic, assign, readonly) NSTimeInterval transitionDuration;

@property (nonatomic, assign, readonly) NSInteger fromIndex;
@property (nonatomic, assign, readonly) NSInteger toIndex;

@property (nonatomic, strong, readonly) __kindof UIViewController *fromViewController;
@property (nonatomic, strong, readonly) __kindof UIViewController *toViewController;

// 子 VC 间的切换是否被取消
@property (nonatomic, assign, readonly, getter=isCancelled) BOOL cancelled;
// scroll view 的 content offset 相对于 scroll view 的宽，如 2.1、2.15、2.2 等等
@property (nonatomic, assign, readonly) CGFloat relativeOffset;
// 子 VC 切换的触发来源，是用户手动还是程序自动
@property (nonatomic, assign, readonly) PAPageControllerTransitionTriggeredBy triggeredBy;

@end

#pragma mark -

// 在 Page VC 的子 VC 切换时，可借助此 coordinator 同步完成动画。与 VC 的 transitionCoordinator 一样，仅当 transition 进行时存在。
@protocol PAPageControllerTransitionCoordinator <NSObject>

- (void)animateAlongsidePagingInView:(UIView *)view
                           animation:(PAPageControllerTransitionAnimationBlock)animation
                          completion:(PAPageControllerTransitionAnimationBlock)completion;

@end
