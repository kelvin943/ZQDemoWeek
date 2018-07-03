//
//  PAPageControllerCollectionViewDataSource.h
//  manpanxiang
//
//  Created by Linkou Bian on 22/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAPageController.h"

@interface PAPageControllerCollectionViewDataSource : NSObject<UICollectionViewDataSource>

- (instancetype)initWithPageController:(PAPageController*)pageController;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
