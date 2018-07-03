//
//  PAPageControllerCollectionViewCell.h
//  manpanxiang
//
//  Created by Linkou Bian on 22/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAPageControllerCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) __kindof UIViewController *viewController;

+ (NSString *)reuseIdentifier;
- (void)addChildViewIfNeeded;

@end
