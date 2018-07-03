//
//  PAPageControllerProtocol.h
//  manpanxiang
//
//  Created by Linkou Bian on 28/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAPageControllerTransitionCoordinator.h"

/**
 因为 Collection View 的 Delegate 使用独立的文件实现，需要访问容器 VC 的部分方法，而且仅供内部使用，不想直接暴露在容器 VC 的头文件中。
 */
@protocol _PAPageControllerProtocol <NSObject>

/**
 仅供内部实现使用。手动在容器 VC 中滑，或代码方式直接跳（setCurrentIndex:animated:）至某子 VC 时会被调用。需要使用 Page Transition Coordinator 执行关联的外部动画; 同时借助 Container Controller API 确保子 VC 的生命周期方法的执行
 
 @param toIndex 目标索引
 @param triggeredBy 触发方式，如：手动或者代码
 */
- (void)_startTransitionToIndex:(NSUInteger)toIndex by:(PAPageControllerTransitionTriggeredBy)triggeredBy;

/**
 仅供内部实现使用。Collection View 滚动过程中，需要使用 Page Transition Coordinator 更新关联的外部动画
 
 @param relativeOffset 内部 Collection View 的 content offset 相对于 scroll view 的宽，如 2.1、2.15、2.2 等等
 */
- (void)_updateTransitionWithOffset:(CGFloat)relativeOffset;

/**
 仅供内部实现使用。Collection View 滚动结束，需要使用 Page Transition Coordinator 结束关联的外部动画; 同时借助 Container Controller API 确保子 VC 的生命周期方法的执行
 */
- (void)_finishTransition;

@end
