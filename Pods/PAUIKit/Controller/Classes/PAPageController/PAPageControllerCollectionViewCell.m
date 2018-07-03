//
//  PAPageControllerCollectionViewCell.m
//  manpanxiang
//
//  Created by Linkou Bian on 22/11/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAPageControllerCollectionViewCell.h"

@implementation PAPageControllerCollectionViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

- (void)addChildViewIfNeeded {
    if (![self containsViewOfController:self.viewController]) {
        [self.contentView addSubview:self.viewController.view];
        self.viewController.view.frame = self.contentView.bounds;
    }
}

- (BOOL)containsViewOfController:(__kindof UIViewController *)controller {
    if (self.contentView == controller.view.superview) {
        return YES;
    }
    
    return NO;
}

@end
