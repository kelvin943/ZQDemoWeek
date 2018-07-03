//
//  UIImage+Category.h
//  manpanxiang
//
//  Created by Linkou Bian on 23/08/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 根据 NSString 生成 UIImage 对象

 @param rect 图片所含文本
 @param string 图标字
 @param fontSize 字号
 @param color 颜色
 @return 根据图标字生成的图片
 */
+ (UIImage *)imageInRect:(CGRect)rect withIconString:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color;


/**
 根据 NSString 生成 UIImage 对象

 @param rect 图片大小
 @param string 图片所含文本
 @param font 文本字体
 @param color 文本颜色
 @return 生成的 UIImage 对象
 */

+ (UIImage *)imageInRect:(CGRect)rect withString:(NSString *)string font:(UIFont *)font color:(UIColor *)color;


/**
 *  根据iconfont获取image
 *
 *  @param iconfont iconfont的名字
 *  @param size     尺寸
 *  @param color    颜色
 *
 *  @return UIImage
 */
+ (UIImage *)imageFromIconfont:(NSString *)iconfont size:(NSUInteger)size color:(UIColor *)color;

/**
 修复图片翻转问题（比如拍照，或者选择照片之后图片翻转）
 */
- (UIImage *)fixOrientation;

/**
 图片大小调整,按比例调整图片大小，以size中最大的边做依据调整
 
 @param targetSize 目标大小
 @return UIImage
 */
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;

/**
 图片大小调整,强制调整图片大小，会造成图片比例失衡
 
 @param targetSize 目标大小
 @return  UIImage
 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

/**
 @method
 @abstract      图片保持比例拉伸并保证最大一边不超过指定大小
 @param         length 拉伸后最大一边的大小
 @discussion    拉伸的同时保证图片比例不变化
 @return        UIImage
 */
- (UIImage *)imageByProportionallyScalingMaximumEdgeTo: (CGFloat) length;

/**
 @method
 @abstract      图片保持比例拉伸并保证最小一边不超过原始图片最小一边的大小
 @param         length 拉伸后小一边的大小
 @discussion    拉伸的同时保证图片比例不变化
 @return        UIImage
 */
- (UIImage *)imageByProportionallyScalingMinimumEdgeTo: (CGFloat) length;

- (NSData *)compressImageByProportionallyScalingMinimumEdgeTo:(CGFloat)minEdge
                                                    aimLength:(NSUInteger)aimLength
                                             accuracyOfLength:(NSUInteger)accuracy;


- (NSData *)compressImageByProportionallyScalingMaximumEdgeTo:(CGFloat)minEdge
                                                    aimLength:(NSUInteger)aimLength
                                             accuracyOfLength:(NSUInteger)accuracy;

/**
 @method
 @abstract      给定颜色值获取一张图片
 @param         color 图片颜色
 @discussion    给定一个颜色值，获取对应颜色值的图片
 @return        图片image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  Creates and returns a new image object that is masked with the specified mask color.
 *
 *  @param maskColor The color value for the mask. This value must not be `nil`.
 *
 *  @return A new image object masked with the specified color.
 */
- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor;

@end

