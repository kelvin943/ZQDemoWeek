//
//  PATableHeaderDragRefreshView.h
//  haofang
//
//  Created by PengFeiMeng on 4/1/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

typedef NS_ENUM(NSInteger, PAPullRefreshState) {
    PAPullRefreshPulling    = 0,   // 下拉中
    PAPullRefreshNormal     = 1,   // 正常状态
    PAPullRefreshLoading    = 2    // 加载ing
};

@protocol PARefreshTableHeaderDelegate;

@interface PATableHeaderDragRefreshView : UIView

/**
 delegate
 */
@property (nonatomic, weak) id<PARefreshTableHeaderDelegate, NSObject> delegate;

/**
 更新刷新的状态
 */
- (void)paRefreshScrollViewDidScroll:(UIScrollView *)scrollView;


/**
 传入scrollView,判断是否触发下拉
 */
- (void)paRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

/**
 结束加载状态
 */
- (void)paRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@protocol PARefreshTableHeaderDelegate


/**
 触发回调下拉刷新
 */
- (void)paRefreshTableHeaderDidTriggerRefresh:(PATableHeaderDragRefreshView *)view;


/**
 获取是否处于加载状态
 */
- (BOOL)paRefreshTableHeaderDataSourceIsLoading:(PATableHeaderDragRefreshView *)view;

@end
