//
//  PAPageController.m
//  PAUIKit
//
//  Created by Linkou Bian on 21/11/2017.
//

#import "PAPageController.h"
#import "PAPageControllerCollectionViewCell.h"
#import "PAPageControllerCollectionViewDelegate.h"
#import "PAPageControllerCollectionViewDataSource.h"
#import "PAPageControllerTransitionCoordinatorImpl.h"

@interface PAPageController ()

// 容器 VC 内部基于 Collection View 实现，该 Collection View 的 DataSource 及 Delegate 由实现在单独文件中
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;
@property (nonatomic, strong) PAPageControllerCollectionViewDataSource *collectionViewDataSource;
@property (nonatomic, strong) PAPageControllerCollectionViewDelegate *collectionViewDelegate;

@property (nonatomic, assign) BOOL collectionViewAnimationDisabled;

// 之所以用具体的实现而不是 id<XXX> 的方式声明，是因为实现中改变了属性的访问性，或增加了新方法
// 协议的作用，主要在于对外传出去的类型符合最低权限原则
@property (nonatomic, strong) PAPageControllerTransitionCoordinatorContextImpl *context;
@property (nonatomic, strong) PAPageControllerTransitionCoordinatorImpl *pageTransitionCoordinator;

@end

@implementation PAPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageContetnInset = UIEdgeInsetsZero;
    
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat top = self.pageContetnInset.top;
    CGFloat bottom = self.pageContetnInset.bottom;
    CGFloat left = self.pageContetnInset.left;
    CGFloat right = self.pageContetnInset.right;

    self.collectionViewFlowLayout.itemSize = CGSizeMake(self.view.bounds.size.width - left - right, self.view.bounds.size.height - top - bottom);
    self.collectionView.frame = CGRectMake(left, top, self.view.bounds.size.width - left - right, self.view.bounds.size.height - top - bottom);
}

#pragma mark - Public Methods

- (void)reloadPages {
    [self.collectionView reloadData];
}

- (void)setCurrentIndex:(NSUInteger)currentIndex animated:(BOOL)animated {
    _collectionViewAnimationDisabled = !animated;
    
    // 处于 transition 中（出现的场景较少），若是由程序触发的，则 finish，否则 cancel 掉
    if (_inTransition) {
        BOOL shouldComplete = (_context.triggeredBy == PAPageControllerTransitionTriggeredByProgram);
        [self _finishTransition:shouldComplete];
    }
    
    // 准备页面切换
    [self _startTransitionToIndex:currentIndex by:PAPageControllerTransitionTriggeredByProgram];
    _currentIndex = currentIndex;
    
    // 页面切换
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:currentIndex inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    
    // animated 为 NO 时，scrollViewDidEndScrollingAnimation: 不会执行，故此场景需直接结束页面切换
    if (!animated) {
        [self _finishTransition:YES];
    }
}

#pragma mark - Internal Methods (_PAPageControllerProtocol)

- (void)_startTransitionToIndex:(NSUInteger)toIndex by:(PAPageControllerTransitionTriggeredBy)triggeredBy {
    if (_currentIndex == toIndex) {
        return;
    }
    
    // 用于 scrollViewDidScroll: 中区分 transition 是新开始还是更新中
    _inTransition = YES;
    
    // 备份到 Collection View Delegate，因为 setCurrentIndex:animated:NO 时直接结束 transition 会释放 context，而 Collection View 的 delegate 方法在此之后执行
    self.collectionViewDelegate.fromIndex = _currentIndex;
    self.collectionViewDelegate.toIndex = toIndex;
    
    // 备份到 Collection View Delegate，因为 setCurrentIndex:animated:NO 时不会执行 scrollViewWillEndDragging:withVelocity:targetContentOffset: 方法
    self.collectionViewDelegate.draggingTargetIndex = toIndex;
    
    // 开始 transition，构造 context，一直到结束 transition 期间，context 均可用
    _context = [[PAPageControllerTransitionCoordinatorContextImpl alloc] init];
    
    _context.fromIndex = _currentIndex;
    _context.toIndex = toIndex;
    
    _context.fromViewController = [self.collectionViewDataSource viewControllerAtIndex:_currentIndex];
    _context.toViewController = [self.collectionViewDataSource viewControllerAtIndex:toIndex];
    
    _context.triggeredBy = triggeredBy;
    
    // 仅手动触发才对关联的外部视图应用动画
    if (triggeredBy == PAPageControllerTransitionTriggeredByUser) {
        _context.transitionDuration = 1;
        _pageTransitionCoordinator = [[PAPageControllerTransitionCoordinatorImpl alloc] initWithContext:_context];
        
        _collectionViewAnimationDisabled = NO;
    } else {
        _context.transitionDuration = 0;
        _pageTransitionCoordinator = nil;
        
        // _collectionViewAnimationDisabled 在 setCurrentIndex:animated: 处已设置
    }
    
    // 使用 container controller api 切换 from / to VC
    [self didStartTransitionWithContext:_context];
    
    // 通知外部
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:willStartTransition:)]) {
        [self.delegate pageController:self willStartTransition:_context];
    }
    
    // 执行代理中设置的关联视图动画
    [_pageTransitionCoordinator startTransition];
}

- (void)_updateTransitionWithOffset:(CGFloat)relativeOffset {
    _context.relativeOffset = relativeOffset;
    
    // 仅手动触发才对关联的外部视图应用动画
    if (_context.triggeredBy == PAPageControllerTransitionTriggeredByUser) {
        
        // 因为要用于外部视图动画的进度设置，故将 collection view 的 relative offset 转成 0.x 的形式
        CGFloat progress = (relativeOffset - _context.fromIndex) / (_context.toIndex - _context.fromIndex);
        progress = MIN(MAX(0, progress), 1);
        
        // 更新代理中设置的关联视图动画
        [_pageTransitionCoordinator updateTransitionProgress:progress];
    }
}

- (void)_finishTransition {
    // 离 fromIndex 比距离 toIndex 更远，则应该 complete，否则 cancel
    BOOL shouldComplete = ABS(_context.relativeOffset - _context.fromIndex) > ABS(_context.relativeOffset - _context.toIndex);
    [self _finishTransition:shouldComplete];
}

- (void)_finishTransition:(BOOL)complete {
    if (complete) {
        _currentIndex = self.context.toIndex;
    } else {
        _context.cancelled = YES;
    }
    
    _inTransition = NO;
    
    // 使用 container controller api 切换 from / to VC
    [self didFinishTransitionWithContext:_context];
    
    // 通知外部
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageController:didEndTransition:)]) {
        [self.delegate pageController:self didEndTransition:_context];
    }
    
    // 结束代理中设置的关联视图动画
    [_pageTransitionCoordinator finishTransition:complete];
    
    // 销毁相伴于 transition 创建的对象
    _context = nil;
    _pageTransitionCoordinator = nil;
}

#pragma mark - Private Methods

/**
 *  移除
 *  [controller willMoveToParentViewController:nil];
 *  [controller.view removeFromSuperview];
 *  [controller removeFromParentViewController];
 *
 *  添加
 *  [self.pageController addChildViewController:controller];
 *  [controller didMoveToParentViewController:self.pageController];
 */
- (void)didStartTransitionWithContext:(id<PAPageControllerTransitionCoordinatorContext>)context {
    [self prepareTransition:NO viewController:context.fromViewController];
    [self prepareTransition:YES viewController:context.toViewController];
}

- (void)didFinishTransitionWithContext:(id<PAPageControllerTransitionCoordinatorContext>)context {
    if (context.cancelled) {
        [self cancelTransition:NO viewController:context.fromViewController];
        [self cancelTransition:YES viewController:context.toViewController];
    }
    
    [self finishTransition:NO cancelled:context.cancelled viewController:context.fromViewController];
    [self finishTransition:YES cancelled:context.cancelled viewController:context.toViewController];
}

- (void)prepareTransition:(BOOL)isAppearing viewController:(UIViewController *)viewController {
    if (isAppearing) {
        // When your custom container calls the addChildViewController: method, it automatically calls
        // the willMoveToParentViewController: method of the view controller to be added as a child
        // before adding it.
        [self addChildViewController:viewController];
        
        // 禁掉 Collection View 的动画后，对将要显示的 controller 不去手动触发 view[Will|Did]Appear 而由 cell will display 时 addSubView 触发
        if (!_collectionViewAnimationDisabled) {
            [viewController beginAppearanceTransition:YES animated:YES];
        }
        
    } else {
        [viewController willMoveToParentViewController:nil];
        
        // 禁掉 Collection View 的动画后，对将要消失的 controller 不去手动触发 view[Will|Did]Disappear 而由 cell end display 时 removeFromSuperView 触发
        if (!_collectionViewAnimationDisabled) {
            [viewController beginAppearanceTransition:NO animated:YES];
        }
    }
}

- (void)cancelTransition:(BOOL)isAppearing viewController:(UIViewController *)viewController {
    if (isAppearing) {
        [viewController willMoveToParentViewController:nil];
        [viewController beginAppearanceTransition:NO animated:YES];
    } else {
        [viewController willMoveToParentViewController:self];
        [viewController beginAppearanceTransition:YES animated:YES];
    }
}

- (void)finishTransition:(BOOL)isAppearing cancelled:(BOOL)cancelled viewController:(UIViewController *)viewController {
    if (cancelled) {
        isAppearing = !isAppearing;
    }
    
    if (isAppearing) {
        
        // 禁掉 Collection View 的动画后，对将要显示的 controller 不去手动触发 view[Will|Did]Appear 而由 cell will display 时 addSubView 自动触发
        if (!_collectionViewAnimationDisabled) {
            [viewController endAppearanceTransition];
        }
        
        [viewController didMoveToParentViewController:self];
    } else {
        // 禁掉 Collection View 的动画后，对将要消失的 controller 不去手动触发 view[Will|Did]Disappear 而由 cell end display 时 removeFromSuperView 触发
        if (!_collectionViewAnimationDisabled) {
            [viewController endAppearanceTransition];
        }
        
        [viewController removeFromParentViewController];
    }
}

#pragma mark - Properties

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (!_collectionViewFlowLayout) {
        _collectionViewFlowLayout = [UICollectionViewFlowLayout new];
        _collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewFlowLayout.itemSize = self.view.bounds.size;
        _collectionViewFlowLayout.minimumLineSpacing = 0;
        _collectionViewFlowLayout.minimumInteritemSpacing = 0;
    }
    
    return _collectionViewFlowLayout;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.collectionViewFlowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.scrollsToTop = NO;
        _collectionView.bounces = NO;
        _collectionView.dataSource = self.collectionViewDataSource;
        _collectionView.delegate = self.collectionViewDelegate;
        
        [_collectionView registerClass:[PAPageControllerCollectionViewCell class] forCellWithReuseIdentifier:[PAPageControllerCollectionViewCell reuseIdentifier]];
        [_collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    }
    
    return _collectionView;
}

- (PAPageControllerCollectionViewDelegate *)collectionViewDelegate {
    if (!_collectionViewDelegate) {
        _collectionViewDelegate = [[PAPageControllerCollectionViewDelegate alloc] initWithPageController:self];
    }
    
    return _collectionViewDelegate;
}

- (PAPageControllerCollectionViewDataSource *)collectionViewDataSource {
    if (!_collectionViewDataSource) {
        _collectionViewDataSource = [[PAPageControllerCollectionViewDataSource alloc] initWithPageController:self];
    }
    
    return _collectionViewDataSource;
}

@end

