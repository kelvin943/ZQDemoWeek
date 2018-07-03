//
//  PAPageControllerCollectionViewDelegate.h
//  manpanxiang
//
//  Created by Linkou Bian on 22/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAPageController.h"
#import "PAPageControllerTransitionCoordinator.h"

// 注意 UIScrollViewDelegate 继承了 UIScrollViewDelegate
@interface PAPageControllerCollectionViewDelegate : NSObject <UICollectionViewDelegate>

// 因为 setCurrentIndex:animated:NO 时直接结束 transition 会释放 context，而 Collection View 的 delegate 方法在此之后执行
// 故而备份 from/to index 到 Collection View 的 delegate 实例中
@property (nonatomic, assign) NSUInteger fromIndex;
@property (nonatomic, assign) NSUInteger toIndex;

// 处理滑动但取消的场景下，didEndDisplayingCell 判断所需
@property (nonatomic, assign) NSUInteger draggingTargetIndex;

- (instancetype)initWithPageController:(PAPageController*)pageController;

@end
