//
//  UIView+PALayoutHelper.m
//  manpanxiang
//
//  Created by Linkou Bian on 13/10/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "UIView+PALayoutHelper.h"

@implementation UIView (PALayoutHelper)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)x {
    return self.origin.x;
}

- (void)setX:(CGFloat)x {
    CGPoint origin = self.origin;
    origin.x = x;
    self.origin = origin;
}

- (CGFloat)y {
    return self.origin.y;
}

- (void)setY:(CGFloat)y {
    CGPoint origin = self.origin;
    origin.y = y;
    self.origin = origin;
}

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGPoint)topLeft {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame));
}

- (void)setTopLeft:(CGPoint)topLeft {
    self.origin = topLeft;
}

- (CGPoint)topRight {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame));
}

- (void)setTopRight:(CGPoint)topRight {
    CGPoint origin = self.origin;
    origin.x = topRight.x - self.width;
    origin.y = topRight.y;
    self.origin = origin;
}

- (CGPoint)bottomRight {
    return CGPointMake(CGRectGetMaxX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setBottomRight:(CGPoint)bottomRight {
    CGPoint origin = self.origin;
    origin.x = bottomRight.x - self.width;
    origin.y = bottomRight.y - self.height;
    self.origin = origin;
}

- (CGPoint)bottomLeft {
    return CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame));
}

- (void)setBottomLeft:(CGPoint)bottomLeft {
    CGPoint origin = self.origin;
    origin.x = bottomLeft.x;
    origin.y = bottomLeft.y - self.height;
    self.origin = origin;
}



- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)topOfView:(UIView *)view {
    [self bottomOfView:view withMargin:0];
}

- (void)topOfView:(UIView *)view withMargin:(CGFloat)margin {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.y = view.frame.origin.y - self.frame.size.height - margin;
    
    self.frame = rect;
}

- (void)bottomOfView:(UIView *)view {
    [self bottomOfView:view withMargin:0];
}

- (void)bottomOfView:(UIView *)view withMargin:(CGFloat)margin {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.y = view.frame.origin.y + view.frame.size.height + margin;
    
    self.frame = rect;
}

- (void)leftOfView:(UIView *)view {
    [self leftOfView:view withMargin:0];
}

- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin {
    [self leftOfView:view withMargin:margin sameVertical:NO];
}

- (void)leftOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.x = view.frame.origin.x - rect.size.width - margin;
    
    if (same) {
        rect.origin.y = view.frame.origin.y;
        rect.size.height = view.frame.size.height;
    }
    
    self.frame = rect;
}

- (void)rightOfView:(UIView *)view {
    [self rightOfView:view withMargin:0];
}

- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin {
    [self rightOfView:view withMargin:margin sameVertical:NO];
}

- (void)rightOfView:(UIView *)view withMargin:(CGFloat)margin sameVertical:(BOOL)same {
    if (nil == view) {
        return;
    }
    
    CGRect rect = self.frame;
    
    rect.origin.x = view.frame.origin.x + view.frame.size.width + margin;
    
    if (same) {
        rect.origin.y = view.frame.origin.y;
        rect.size.height = view.frame.size.height;
    }
    
    self.frame = rect;
}





@end
