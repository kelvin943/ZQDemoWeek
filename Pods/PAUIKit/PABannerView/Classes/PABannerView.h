//
//  PABannerView.h
//  manpanxiang
//
//  Created by Linkou Bian on 11/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PABannerViewDataSource, PABannerViewDelegate;

/**
 用于轮播广告的控件，支持循环、自动滚动（可以自定义滚动间隔）等
 */
@interface PABannerView : UIView

// 是否支持循环滚动，默认支持
@property (nonatomic, assign) BOOL supportLoop;
// 是否支持自动滚动，默认支持
@property (nonatomic, assign) BOOL supportAutoScroll;
// 自动滚动的间隔时间，默认 5 秒
@property (nonatomic, assign) NSTimeInterval autoScrollInterval;

@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, assign) CGRect pageControlFrame;

@property (nonatomic, weak) id<PABannerViewDataSource> dataSource;
@property (nonatomic, weak) id<PABannerViewDelegate> delegate;

// 务必调用
- (void)reloadData;

@end

#pragma mark -

/**
 1. 有几页广告、每一页的视图，完全由使用方定制
 2. 在 scrollViewDidScroll 处设置 page 索引而不是等动画停止，这样快速滑动时也能保证 page 索引和广告对应
 3. 稳定的显示在某一广告处时（不含快速滑动时经过的广告），会以 delegate 方法通知出去
 4. 采用 N+2 的原理实现循环展示，故在边缘页时继续手动快速滑，会有一定概率出现滑到底了的假象（其实是真相），因为
    还未来得及默默的归位。这个问题并不大。
 5. 若要解决上述问题，可以将 numberOfItems 虚拟成一个较大数字，比如 10000 * N + N + 10000 * N （对外透明）
 */
@protocol PABannerViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInBannerView:(PABannerView *)banner;
- (NSString *)bannerView:(PABannerView *)banner imageUrlStringAtIndex:(NSUInteger)index;

@end

#pragma mark -

@protocol PABannerViewDelegate <NSObject>

@optional
- (void)banner:(PABannerView *)banner didSelectItemAtIndex:(NSInteger)index;

@end
