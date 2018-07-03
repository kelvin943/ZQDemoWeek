//
//  UIViewController+Category.m
//  haofang
//
//  Created by PengFeiMeng on 3/26/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "UIViewController+Category.h"
#import <objc/runtime.h>
#import "UIBarButtonItem+Category.h"

@implementation UIViewController (Category)

#pragma mark - view life circle

+ (void)load {
    Method viewDidLoad          = class_getInstanceMethod([UIViewController class], @selector(viewDidLoad));
    Method viewDidLoadCustom    = class_getInstanceMethod([UIViewController class], @selector(viewDidLoadCustom));

    method_exchangeImplementations(viewDidLoad, viewDidLoadCustom);
}

- (void)viewDidLoadCustom{
    if (self.isViewLoaded) {
        //autoresize
        self.view.autoresizesSubviews = YES;
        self.view.autoresizingMask    = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

        self.edgesForExtendedLayout                 = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars       = NO;
        self.automaticallyAdjustsScrollViewInsets   = NO;
    }

    [self viewDidLoadCustom];
}

@end
