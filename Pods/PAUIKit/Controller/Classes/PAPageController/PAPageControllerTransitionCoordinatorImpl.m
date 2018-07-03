//
//  PAPageControllerTransitionCoordinatorImpl.m
//  manpanxiang
//
//  Created by Linkou Bian on 21/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAPageControllerTransitionCoordinatorImpl.h"

@implementation PAPageControllerTransitionCoordinatorContextImpl

@end

#pragma mark -

@interface PAPageControllerTransitionCoordinatorImpl ()

@property (nonatomic, strong) id<PAPageControllerTransitionCoordinatorContext> context;

@property (nonatomic, strong) NSMutableArray<UIView *> *animatingViews;
@property (nonatomic, strong) NSMutableArray<PAPageControllerTransitionAnimationBlock> *animationBlocks;
@property (nonatomic, strong) NSMutableArray<PAPageControllerTransitionCompletionBlock> *completionBlocks;

@end

@implementation PAPageControllerTransitionCoordinatorImpl

- (instancetype)initWithContext:(id<PAPageControllerTransitionCoordinatorContext>)context {
    if (self = [super init]) {
        _context = context;
    }
    
    return self;
}

- (void)dealloc {
    for (UIView *view in self.animatingViews) {
        [self resumeLayer:view.layer];
        
        // 移除 sub layer 的动画
        [self restoreSublayerStateOfLayer:view.layer];
    }
}

- (void)startTransition {
    for (UIView *view in self.animatingViews) {
        [self pauseLayer:view.layer withTimeOffset:0];
    }
    
    // 执行 animation blocks
    if ([self.animationBlocks count] > 0) {
        // 屏幕刷新结束后调用，适合做 UI 的不停重绘，动画或视频的渲染等
        CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startAnimationsAfterScreenUpdate:)];
        [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)updateTransitionProgress:(CGFloat)progress {
    for (UIView *view in self.animatingViews) {
        CFTimeInterval timeOffset = progress * [self.context transitionDuration];
        [self pauseLayer:view.layer withTimeOffset:timeOffset];
    }
}

- (void)finishTransition:(BOOL)complete {
    for (UIView* view in self.animatingViews) {
        [self resumeLayer:view.layer];
    }
    
    // 执行 completion blocks
    dispatch_async(dispatch_get_main_queue(), ^{
        for (PAPageControllerTransitionCompletionBlock completionBlock in self.completionBlocks) {
            completionBlock(self.context);
        }
        
        [self.completionBlocks removeAllObjects];
    });
}

#pragma mark - Protocol Methods

- (void)animateAlongsidePagingInView:(UIView *)view
                           animation:(PAPageControllerTransitionAnimationBlock)animation
                          completion:(PAPageControllerTransitionAnimationBlock)completion {
    // 将 animating view 加到 queue 里
    if (![self.animatingViews containsObject:view]) {
        [self.animatingViews addObject:view];
    }
    
    // 将 animation / completion block 加到对应的 queue 里
    if (animation) {
        [self.animationBlocks addObject:animation];
    }
    
    if (completion) {
        [self.completionBlocks addObject:completion];
    }
}

#pragma mark - Private Methods

// https://developer.apple.com/library/content/qa/qa1673/_index.html
- (void)pauseLayer:(CALayer *)layer withTimeOffset:(CFTimeInterval)offset {
    layer.speed = 0;
    layer.timeOffset = offset;
}

- (void)resumeLayer:(CALayer *)layer {
    layer.speed = 1;
    layer.timeOffset = 0;
}

- (void)restoreSublayerStateOfLayer:(CALayer*)layer {
    // Use stack instead of recursion to keep from stack overflow.
    NSMutableArray<CALayer *> *layerStack = [NSMutableArray arrayWithObject:layer];
    while (layerStack.count > 0) {
        CALayer* layer = layerStack.lastObject;
        [layer removeAllAnimations]; // Remove all the animations on the fly
        
        [layerStack removeLastObject];
        
        if (layer.sublayers.count > 0) {
            [layerStack addObjectsFromArray:layer.sublayers];
        }
    }
}

- (void)startAnimationsAfterScreenUpdate:(CADisplayLink*)displayLink {
    [displayLink invalidate];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.animationBlocks count] == 0) {
            return;
        }
        
        [UIView animateWithDuration:[self.context transitionDuration] animations:^{
            for (PAPageControllerTransitionAnimationBlock animationBlock in self.animationBlocks) {
                animationBlock(self.context);
            }
        }];
        
        [self.animationBlocks removeAllObjects];
    });
}

#pragma mark - Properties

- (NSMutableArray *)animatingViews {
    if (!_animatingViews) {
        _animatingViews = [NSMutableArray array];
    }
    
    return _animatingViews;
}

- (NSMutableArray *)animationBlocks {
    if (!_animationBlocks) {
        _animationBlocks = [NSMutableArray array];
    }
    
    return _animationBlocks;
}

- (NSMutableArray *)completionBlocks {
    if (!_completionBlocks) {
        _completionBlocks = [NSMutableArray array];
    }
    
    return _completionBlocks;
}

@end
