//
//  PAImageView.h
//  haofang
//
//  Created by leo on 14-9-5.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PAImageView;

typedef void(^PAImageViewDidLoadImage)(PAImageView *imageView, UIImage *image);

@interface PAImageView : UIImageView

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) PAImageViewDidLoadImage imageDidLoadHandler;

@end
