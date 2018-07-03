//
//  PAImageView.m
//  haofang
//
//  Created by leo on 14-9-5.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "PAImageView.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"

#import "UIImageView+WebCache.h"

#pragma clang diagnostic pop

@implementation PAImageView

- (void)setUrlPath:(NSString *)urlPath {
    _urlPath = urlPath;
    NSURL *imageURL = [NSURL URLWithString:_urlPath];
    
    if ([[imageURL scheme] isEqualToString:@"assets-library"]) {
        return;
    }
    
    if (!self.imageDidLoadHandler) {
        [self sd_setImageWithURL:imageURL placeholderImage:self.defaultImage];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self sd_setImageWithURL:[NSURL URLWithString:self.urlPath]
            placeholderImage:self.defaultImage
                     options:SDWebImageAllowInvalidSSLCertificates | SDWebImageRetryFailed
                    progress:nil
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                       if (!error) {
                           weakSelf.imageDidLoadHandler(weakSelf, image);
                       }
                   }];
}

@end
