//
//  UIImage+Category.m
//  haofang
//
//  Created by Aim on 14-3-27.
//  Copyright (c) 2014年 平安好房. All rights reserved.
//

#import "UIImage+Category.h"
#import "UIFont+IconFont.h"

@implementation UIImage(Category)

+ (UIImage *)imageInRect:(CGRect)rect withIconString:(NSString *)string fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UIFont *font = [UIFont iconFontWithSize:fontSize];
    UIImage *image = [self imageInRect:rect withString:string font:font color:color];
    
    return image;
}

+ (UIImage *)imageInRect:(CGRect)rect withString:(NSString *)string font:(UIFont *)font color:(UIColor *)color {
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    [string drawInRect:rect withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageFromIconfont:(NSString *)iconfont size:(NSUInteger)size color:(UIColor *)color {
    CGSize imageSize = CGSizeMake(size, size);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [[UIScreen mainScreen] scale]);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size, size)];
    label.font = [UIFont fontWithName:@"iconfont" size:size];
    label.text = iconfont;
    if(color){
        label.textColor = color;
    }
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    return retImage;
}

- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    //   CGSize imageSize = sourceImage.size;
    //   CGFloat width = imageSize.width;
    //   CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    //   CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    // this is actually the interesting part:
    
    //    UIGraphicsBeginImageContextWithOptions(targetSize, NO, [UIScreen mainScreen].scale);
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    
    return newImage ;
}

- (UIImage *)imageByProportionallyScalingMaximumEdgeTo: (CGFloat) length {
    CGFloat aspectRation = self.size.width / self.size.height;
    CGFloat newWidth =0, newHeight = 0;
    
    if (self.size.width > self.size.height) { // 比较宽的图片
        length = length == 0 ? self.size.width * 0.3 : MIN(length, self.size.width);
        newWidth = length;
        newHeight = newWidth / aspectRation;
    }
    else {  // 比较高的图片
        length = length == 0 ? self.size.height * 0.3 : MIN(length, self.size.height);
        newHeight = length;
        newWidth = aspectRation * newHeight;
    }
    
    return [self imageByScalingToSize:CGSizeMake(newWidth, newHeight)];
}

- (UIImage *)imageByProportionallyScalingMinimumEdgeTo: (CGFloat) length {
    CGFloat aspectRation    = self.size.width / self.size.height;
    CGFloat newWidth        = 0, newHeight = 0;
    
    if (self.size.width > self.size.height) { // 比较宽的图片
        length              = MIN(length, self.size.height);
        newHeight           = length;
        newWidth            = aspectRation * newHeight;
    }
    else {  // 比较高的图片
        length              = MIN(length, self.size.width);
        newWidth            = length;
        newHeight           = newWidth / aspectRation;
    }
    
    return [self imageByScalingToSize:CGSizeMake(newWidth, newHeight)];
}

- (NSData *)compressImageByProportionallyScalingMinimumEdgeTo:(CGFloat)minEdge
                                                    aimLength:(NSUInteger)aimLength
                                             accuracyOfLength:(NSUInteger)accuracy{
    // 第一步，调整尺寸
    CGFloat aspectRatio     = self.size.width / self.size.height;
    CGFloat newWidth        = 0, newHeight = 0;
    
    if (self.size.width > self.size.height) { // 比较宽的图片
        newHeight           = MIN(minEdge, self.size.height) ;
        newWidth            = aspectRatio * newHeight;
    }else {  // 比较高的图片
        newWidth            = MIN(minEdge, self.size.width);
        newHeight           = newWidth / aspectRatio;
    }
    
    UIImage * scaledImage   = [self imageByScalingToSize:CGSizeMake(newWidth, newHeight)];
    
    // 第二步，压缩精度
    NSData * rawData        = UIImageJPEGRepresentation(scaledImage, 1.0);
    NSUInteger rawDataLength= [rawData length];
    
    if (rawDataLength <= aimLength + accuracy) {
        return rawData;
    }else{
        NSData * imageData  = UIImageJPEGRepresentation(scaledImage, 0.99);
        if (imageData.length < aimLength + accuracy) {
            return imageData;
        }
        
        CGFloat maxQuality  = 1.0;
        CGFloat minQuality  = 0.0;
        int flag            = 0;
        
        while (1) {
            CGFloat midQuality = (maxQuality + minQuality)/2;
            
            if (flag == 6) {
                NSLog(@"************* %ld ******** %f *************",UIImageJPEGRepresentation(scaledImage, minQuality).length,minQuality);
                return UIImageJPEGRepresentation(scaledImage, minQuality);
            }
            flag ++;
            
            NSData * imageData = UIImageJPEGRepresentation(scaledImage, midQuality);
            NSInteger len = imageData.length;
            
            if (len > aimLength + accuracy) {
                NSLog(@"-----%d------%f------%ld-----",flag,midQuality,len);
                maxQuality = midQuality;
                continue;
            }else if (len < aimLength - accuracy){
                NSLog(@"-----%d------%f------%ld-----",flag,midQuality,len);
                minQuality = midQuality;
                continue;
            }else{
                NSLog(@"-----%d------%f------%ld--end",flag,midQuality,len);
                return imageData;
                break;
            }
        }
    }
    
    return rawData;
}

- (NSData *)compressImageByProportionallyScalingMaximumEdgeTo:(CGFloat)minEdge
                                                    aimLength:(NSUInteger)aimLength
                                             accuracyOfLength:(NSUInteger)accuracy{
    // 第一步，调整尺寸
    CGFloat aspectRatio     = self.size.width / self.size.height;
    CGFloat newWidth        = 0, newHeight = 0;
    
    if (self.size.width > self.size.height) { // 比较宽的图片
        newWidth            = MIN(minEdge, self.size.width) ;
        newHeight           = newWidth / aspectRatio;
    }else {  // 比较高的图片
        newHeight           = MIN(minEdge, self.size.height);
        newWidth            = aspectRatio * newHeight;
    }
    
    UIImage * scaledImage   = [self imageByScalingToSize:CGSizeMake(newWidth, newHeight)];
    
    // 压缩精度
    NSData * rawData        = UIImageJPEGRepresentation(scaledImage, 1.0);
    NSUInteger rawDataLength= [rawData length];
    
    if (rawDataLength <= aimLength + accuracy) {
        return rawData;
    }else{
        NSData * imageData  = UIImageJPEGRepresentation(scaledImage, 0.99);
        if (imageData.length < aimLength + accuracy) {
            return imageData;
        }
        
        CGFloat maxQuality  = 1.0;
        CGFloat minQuality  = 0.0;
        int flag            = 0;
        
        while (1) {
            CGFloat midQuality = (maxQuality + minQuality)/2;
            
            if (flag == 6) {
                NSLog(@"************* %ld ******** %f *************",UIImageJPEGRepresentation(scaledImage, minQuality).length,minQuality);
                return UIImageJPEGRepresentation(scaledImage, minQuality);
            }
            flag ++;
            
            NSData * imageData = UIImageJPEGRepresentation(scaledImage, midQuality);
            NSInteger len = imageData.length;
            
            if (len > aimLength + accuracy) {
                NSLog(@"-----%d------%f------%ld-----",flag,midQuality,len);
                maxQuality = midQuality;
                continue;
            }else if (len < aimLength - accuracy){
                NSLog(@"-----%d------%f------%ld-----",flag,midQuality,len);
                minQuality = midQuality;
                continue;
            }else{
                NSLog(@"-----%d------%f------%ld--end",flag,midQuality,len);
                return imageData;
                break;
            }
        }
    }
    
    return rawData;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)imageMaskedWithColor:(UIColor *)maskColor {
    NSParameterAssert(maskColor != nil);
    
    CGRect imageRect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(imageRect.size, NO, self.scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextScaleCTM(context, 1.0f, -1.0f);
        CGContextTranslateCTM(context, 0.0f, -(imageRect.size.height));
        
        CGContextClipToMask(context, imageRect, self.CGImage);
        CGContextSetFillColorWithColor(context, maskColor.CGColor);
        CGContextFillRect(context, imageRect);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}



@end

