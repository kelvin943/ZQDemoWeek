//
//  PAPageControllerCollectionViewDelegate.m
//  manpanxiang
//
//  Created by Linkou Bian on 22/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAPageControllerCollectionViewDelegate.h"
#import "PAPageControllerTransitionCoordinatorImpl.h"
#import "PAPageControllerCollectionViewCell.h"

@interface PAPageControllerCollectionViewDelegate ()

// 保持一个对 Page Controller 的弱引用
@property (nonatomic, weak) PAPageController *pageController;

@end

@implementation PAPageControllerCollectionViewDelegate

- (instancetype)initWithPageController:(PAPageController*)pageController {
    if (self = [super init]) {
        _pageController = pageController;
    }
    
    return self;
}

#pragma mark - UICollectionViewDelegate Methods

// 在此处设置 view 而不是 collectionView:cellForItemAtIndexPath: 处设置，是为了让 vc 的生命周期方法在正确的时机被调用
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 当 setCurrentIndex:animated: 跳过一些子页面时，暂不加载其视图
    // 为何此处不用容器 vc 的 context.toIndex 呢？如果 setCurrentIndex:animated:NO 则 context 在此 delegate 方法之前被销毁，故增加了 toIndex 属性
    if (indexPath.row != self.toIndex) {
        return;
    }
    
    PAPageControllerCollectionViewCell *pageCell = (PAPageControllerCollectionViewCell *)cell;
    [pageCell addChildViewIfNeeded];
}

// 确保容器 VC 销毁前，只有当前现实的 VC 会调用 will/did disappear
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // 滑动未取消掉，只有 fromIndex 对应的 cell 需要卸载 content view
    if (self.draggingTargetIndex != self.fromIndex && indexPath.row != self.fromIndex) {
        return;
    }
    
    PAPageControllerCollectionViewCell *pageCell = (PAPageControllerCollectionViewCell *)cell;
    [pageCell.viewController.view removeFromSuperview];
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat relativeOffset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    
    if (self.pageController.inTransition) {
        [self.pageController _updateTransitionWithOffset:relativeOffset];
    } else if ([self scrollViewIsDragged:scrollView fromEdgeOfPage:self.pageController.currentIndex]) {
        // 根据向后一页或前一页滑，计算出目标页索引
        NSInteger newIndex = (NSInteger)(relativeOffset > self.pageController.currentIndex ? ceil(relativeOffset) : floor(relativeOffset));
        
        // 对于可达到的 toIndex，调用 startTransitionToIndex 后，inTransition 将为 YES
        if (newIndex >= 0 && newIndex < [self.pageController.dataSource numberOfPagesInPageController:self.pageController]) {
            [self.pageController _startTransitionToIndex:newIndex by:PAPageControllerTransitionTriggeredByUser];
        }
    }
}

// setContentOffset 且 animated 为 YES 时执行，在 animated 为 NO 时，容器 VC 直接结束 transition
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.pageController.inTransition) {
        [self.pageController _finishTransition];
    }
}

// setContentOffset 且 animated 为 YES 时执行，在 animated 为 NO 时，容器 VC 直接赋值 draggingTargetIndex
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    _draggingTargetIndex = round(targetContentOffset->x / CGRectGetWidth(scrollView.bounds));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate && self.pageController.inTransition) {
        [self.pageController _finishTransition];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.pageController.inTransition) {
        [self.pageController _finishTransition];
    }
}

#pragma mark - Private Methods

- (BOOL)scrollViewIsDragged:(UIScrollView *)scrollView fromEdgeOfPage:(NSUInteger)pageIndex {
    CGFloat relativeOffset = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds);
    BOOL isLeavingPageEdge = ABS(relativeOffset - pageIndex) > DBL_EPSILON;
    
    return scrollView.dragging && isLeavingPageEdge;
}

@end
