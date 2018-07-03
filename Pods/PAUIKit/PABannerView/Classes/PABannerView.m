//
//  PABannerView.m
//  manpanxiang
//
//  Created by Linkou Bian on 11/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PABannerView.h"
#import "PABannerCell.h"

@interface PABannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong, readwrite) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *autoScrollTimer;

@end

@implementation PABannerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        _supportLoop                                    = YES;
        _supportAutoScroll                              = YES;
        _autoScrollInterval                             = 5.0f;
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
    
    // 若未对 pageControl 设置过 frame, 则使用以下默认 frame
    if (CGRectEqualToRect(self.pageControlFrame, CGRectZero)) {
        CGFloat w = self.frame.size.width;
        CGFloat h = 37.0;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - h;
        self.pageControl.frame = CGRectMake(x, y, w, h);
    }
}

// 避免因 timer 引起内存问题
- (void)removeFromSuperview {
    [self destroyAutoScrollTimer];
    [super removeFromSuperview];
}

- (void)reloadData {
    [self destroyAutoScrollTimer];
    [self.collectionView reloadData];
    self.pageControl.numberOfPages = [self totalPageCount];
    
    if ([self totalPageCount] > 0) {
        // 支持循环展示时则应该跳过最前面的占位页
        NSUInteger initialIndex = [self canLoop] ? 1 : 0;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:initialIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    self.pageControl.hidden = [self totalPageCount] > 1 ? NO : YES;
    self.collectionView.scrollEnabled = [self totalPageCount] > 1 ? YES : NO;
    
    [self setupAutoScrollTimer];
}

#pragma mark - Private Methods

- (void)setupAutoScrollTimer {
    if (![self canAutoScroll]) {
        return;
    }
    
    self.autoScrollTimer = [NSTimer timerWithTimeInterval:self.autoScrollInterval target:self selector:@selector(scrollToNextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.autoScrollTimer forMode:NSRunLoopCommonModes];
}

- (void)destroyAutoScrollTimer {
    [self.autoScrollTimer invalidate];
    self.autoScrollTimer = nil;
}

// scrollToNextPage 是自动滚动逻辑，在 scrollToItemAtIndexPath:atScrollPosition: 之后不需要调用 didScrollToItemAtIndexPath:
// 因为自动与手动滚动都会走到 loop 中，didScrollToItemAtIndexPath: 在 loop 中处理较合理！
- (void)scrollToNextPage {
    
    // 1. 不支持自动滚屏，则不处理
    if (![self canAutoScroll]) {
        return;
    }
    
    // 2. 不支持循环滚屏
    if (![self canLoop]) {
        
        // 已经处于最后一页，则不处理
        if ([self currentPage] == [self totalPageCount] - 1) {
            return;
        }
        
        // 自动切换到下一页
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self currentPage] + 1) inSection:0];
        [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        return;
    }
    
    // 3. 支持循环滚屏
    if ([self currentPage] == [self totalPageCount] + 1) {
        return;
    }
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:([self currentPage] + 1) inSection:0];
    [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (BOOL)canAutoScroll {
    return self.supportAutoScroll && [self totalPageCount] > 1;
}

- (BOOL)canLoop {
    return self.supportLoop && [self totalPageCount] > 1;
}

- (NSUInteger)totalPageCount {
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInBannerView:)]) {
        return [self.dataSource numberOfItemsInBannerView:self];
    }
    
    return 0;
}

- (NSUInteger)currentPage {
    CGFloat pageSide = self.pageSize.width;
    CGFloat offset = self.collectionView.contentOffset.x;
    
    return (NSInteger)(floor((offset - pageSide / 2) / pageSide) + 1);
}

- (CGSize)pageSize {
    CGSize pageSize = self.flowLayout.itemSize;
    pageSize.width += self.flowLayout.minimumLineSpacing;
    
    return pageSize;
}

- (NSUInteger)mappedIndexForLoopingIndexPath:(NSIndexPath *)indexPath {
    NSUInteger mappedIndex = indexPath.row;
    
    if ([self canLoop]) {
        if (indexPath.row == 0) {
            mappedIndex = [self totalPageCount] - 1;
        } else if (indexPath.row == [self totalPageCount] + 1) {
            mappedIndex = 0;
        } else {
            mappedIndex = indexPath.row - 1;
        }
    }
    
    return mappedIndex;
}

// 支持循环滚动的方案
// @see https://adoptioncurve.net/archives/2013/07/building-a-circular-gallery-with-a-uicollectionview/
//
- (void)loop {
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:[self currentPage] inSection:0];
    
    if ([self canLoop]) {
        // Calculate where the collection view should be at the right-hand end item
        if ([self currentPage] == [self totalPageCount] + 1) {
            // user is scrolling to the right from the last item to the 'fake' item 1.
            // reposition offset to show the 'real' item 1 at the left-hand end of the collection view
            newIndexPath = [NSIndexPath indexPathForItem:1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            
        } else if ([self currentPage] ==  0)  {
            // user is scrolling to the left from the first item to the fake 'item N'.
            // reposition offset to show the 'real' item N at the right end end of the collection view
            newIndexPath = [NSIndexPath indexPathForItem:([self totalPageCount]) inSection:0];
            [self.collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    NSUInteger pageCount = [self totalPageCount];
    if ([self canLoop]) {
        return pageCount ? (pageCount + 2) : 0;
    } else {
        return pageCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PABannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PABannerCell cellReuseIdentifier] forIndexPath:indexPath];
    
    // 循环滚动时，N 个数据模型支撑 N + 2 个 Cell 的显示
    NSUInteger mappedIndex = [self mappedIndexForLoopingIndexPath:indexPath];
    
    NSString *url = @"";
    if ([self.dataSource respondsToSelector:@selector(bannerView:imageUrlStringAtIndex:)]) {
        url = [self.dataSource bannerView:self imageUrlStringAtIndex:mappedIndex];
    }
    
    cell.imageView.urlPath = url;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(banner:didSelectItemAtIndex:)]) {
        
        NSUInteger mappedIndex = [self mappedIndexForLoopingIndexPath:indexPath];
        [self.delegate banner:self didSelectItemAtIndex:mappedIndex];
    }
}

#pragma mark - UIScrollViewDelegate Methods

// 拖动滚屏时会执行
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loop];
}

// 自动滚屏时会执行
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self loop];
}

// 确保快速滑动时 page control 及时更新
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:[self currentPage] inSection:0];
    NSUInteger mappedIndex = [self mappedIndexForLoopingIndexPath:newIndexPath];
    self.pageControl.currentPage = mappedIndex;
}

// 拖动滚屏时避免受自动滚屏影响
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self destroyAutoScrollTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupAutoScrollTimer];
}

#pragma mark - Properties

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // 注册 cell
        [_collectionView registerClass:[PABannerCell class] forCellWithReuseIdentifier:[PABannerCell cellReuseIdentifier]];
    }
    
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = self.bounds.size;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    
    return _flowLayout;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    
    return _pageControl;
}

- (void)setPageControlFrame:(CGRect)pageControlFrame {
    _pageControlFrame = pageControlFrame;
    self.pageControl.frame = pageControlFrame;
}

@end
