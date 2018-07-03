//
//  PABannerCell.m
//  manpanxiang
//
//  Created by Linkou Bian on 11/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PABannerCell.h"

@implementation PABannerCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Propertyes

- (PAImageView *)imageView {
    if (!_imageView) {
        _imageView = [[PAImageView alloc] initWithFrame:self.bounds];
        _imageView.defaultImage = [UIImage imageNamed:@"house_detail_default"];
    }
    
    return _imageView;
}

#pragma mark - Static Methods

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
