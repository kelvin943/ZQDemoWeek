//
//  PAPageController.h
//  PAUIKit
//
//  Created by Linkou Bian on 21/11/2017.
//

#import "PAPageControllerProtocol.h"
#import "PAPageControllerTransitionCoordinator.h"
#import "PAViewController.h"

@protocol PAPageControllerDelegate, PAPageControllerDataSource;

// 包含多个子 VC 的容器 VC，左右滑动或直接代码方式可切换子 VC。每个子 VC 的生命周期方法正常被调用
@interface PAPageController : PAViewController <_PAPageControllerProtocol>

// 反馈当前显示的 VC 及其索引给使用者（暂不对外公开？）
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

// Page VC 是否处于从子 VC 切换到另一个子 VC 过程中（暂不对外公开？）
@property (nonatomic, assign, readonly) BOOL inTransition;

// Page VC 滚动的区域，默认全屏滚动
@property (nonatomic, assign) UIEdgeInsets pageContetnInset;

@property (nonatomic, weak) id<PAPageControllerDelegate> delegate;
@property (nonatomic, weak) id<PAPageControllerDataSource> dataSource;

// 在容器 Page VC 的子 VC 切换时，可借助此 coordinator 同步完成动画。与 UIViewController 的 transitionCoordinator 一样，仅当 transition 进行时才存在，其他时候为 nil
@property (nonatomic, strong, readonly) id<PAPageControllerTransitionCoordinatorContext> context;
@property (nonatomic, strong, readonly) id<PAPageControllerTransitionCoordinator> pageTransitionCoordinator;

/**
 设置好该容器 VC 的 dataSource 后，需要调用 reloadPages 以使得内部的 Collection View 重新加载
 */
- (void)reloadPages;

/**
 直接以代码的方式触发，以切换至某个子页面

 @param currentIndex 目标子页面的索引
 @param animated 容器的 Collection View 切换时是否带动画
 
 @note 关联的外部视图无动画
 */
- (void)setCurrentIndex:(NSUInteger)currentIndex animated:(BOOL)animated;

@end

#pragma mark -

@protocol PAPageControllerDelegate <NSObject>

@optional

/**
 容器 VC 的 transition 开始，外部可在此 delegate 方法中设置关联视图的动画

 @param pageController 容器 VC
 @param context 在 transition 过程中可用的 transition 上下文
 */
- (void)pageController:(PAPageController *)pageController willStartTransition:(id<PAPageControllerTransitionCoordinatorContext>)context;

/**
 容器 VC 的 transition 结束，因为外部关联视图的相关代码可以在 page transition coordinator 的 completion block 中实现，此 delegate 方法不暴露也 OK 的

 @param pageController 容器 VC
 @param context 在 transition 过程中可用的 transition 上下文
 */
- (void)pageController:(PAPageController *)pageController didEndTransition:(id<PAPageControllerTransitionCoordinatorContext>)context;

@end

#pragma mark -

@protocol PAPageControllerDataSource <NSObject>

/**
 容器 VC 有多少页

 @param pageController 容器 VC
 @return 页数
 */
- (NSInteger)numberOfPagesInPageController:(PAPageController *)pageController;

/**
 获取指定页号的子页面 VC

 @param pageController 容器 VC
 @param index 页号
 @return 子页面 VC
 */
- (UIViewController *)pageController:(PAPageController *)pageController pageAtIndex:(NSInteger)index;

@end

