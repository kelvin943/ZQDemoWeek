//
//  PAPageControllerCollectionViewDataSource.m
//  manpanxiang
//
//  Created by Linkou Bian on 22/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAPageControllerCollectionViewDataSource.h"
#import "PAPageControllerCollectionViewCell.h"

@interface PAPageControllerCollectionViewDataSource ()

// 保持一个对 Page Controller 的弱引用
@property (nonatomic, weak) PAPageController *pageController;

@end

@implementation PAPageControllerCollectionViewDataSource

- (instancetype)initWithPageController:(PAPageController*)pageController {
    if (self = [super init]) {
        _pageController = pageController;
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.pageController.dataSource numberOfPagesInPageController:self.pageController];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [PAPageControllerCollectionViewCell reuseIdentifier];
    PAPageControllerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIViewController *controller = [self viewControllerAtIndex:indexPath.item];
    cell.viewController = controller;
    
    return cell;
}

#pragma mark - Public Methods

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    UIViewController *controller = [self.pageController.dataSource pageController:self.pageController pageAtIndex:index];
    return controller;
}

@end
