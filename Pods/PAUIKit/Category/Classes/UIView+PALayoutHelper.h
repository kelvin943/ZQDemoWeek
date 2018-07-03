//
//  UIView+PALayoutHelper.h
//  manpanxiang
//
//  Created by Linkou Bian on 13/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (PALayoutHelper)

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;

@property (nonatomic) CGPoint topLeft;
@property (nonatomic) CGPoint topRight;
@property (nonatomic) CGPoint bottomRight;
@property (nonatomic) CGPoint bottomLeft;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

- (void)topOfView:(UIView *)view;
- (void)topOfView:(UIView *)view withMargin:(CGFloat)margin;
- (void)bottomOfView:(UIView *)view;
- (void)bottomOfView:(UIView *)view withMargin:(CGFloat)margin;
- (void)leftOfView:(UIView *)view;
- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin;
- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same;
- (void)rightOfView:(UIView *)view;
- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin;
- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same;


@end
