//
//  PABannerCell.h
//  manpanxiang
//
//  Created by Linkou Bian on 11/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAImageView.h"

@interface PABannerCell : UICollectionViewCell

@property (nonatomic, strong) PAImageView *imageView;

+ (NSString *)cellReuseIdentifier;

@end
