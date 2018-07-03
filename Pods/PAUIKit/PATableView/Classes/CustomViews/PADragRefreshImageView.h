//
//  PADragRefreshImageView.h
//  haofang
//
//  Created by Steven.Lin on 6/4/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PATableRefreshStatus) {
    PATableRefreshStatusLoading          = 0,
    PATableRefreshStatusPullToReload     = 1,
    PATableRefreshStatusReleaseToReload  = 2
};

@interface PADragRefreshImageView : UIImageView

/**
 *  @brief  scrollView 下拉的距离
 */
@property (assign, nonatomic) CGFloat pullOffset;
@property (assign, nonatomic) BOOL isLoading;
@property (weak, nonatomic) id delegate;

/**
 更新状态

 @param status
 */
- (void) setStatus:(PATableRefreshStatus)status;


/**
 开始动画
 */
- (void)startRotateAnimation;

/**
 停止动画
 */
- (void)stopRotateAnimation;

@end
