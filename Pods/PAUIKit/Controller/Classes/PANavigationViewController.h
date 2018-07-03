//
//  PANavigationViewController.h
//  haofang
//
//  Created by PengFeiMeng on 3/25/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 @discussion 页面切换中禁止侧滑；切换至新页面后，根据页面自己的 disableInteractiveGesture 方法返回值决定是否支持侧滑。
 */
@interface PANavigationViewController : UINavigationController

@end
