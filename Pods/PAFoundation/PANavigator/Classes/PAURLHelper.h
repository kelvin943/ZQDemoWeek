//
//  PAURLHelper.h
//  haofang
//
//  Created by PengFeiMeng on 5/1/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAViewMap.h"



@interface PAURLHelper : NSObject

/*!
 @method
 @abstract      判断url是否web url，相对于app而言
 @param         URL URL
 @return        BOOL
 */
+ (BOOL)isWebURL:(NSURL*)URL;

/*!
 @method
 @abstract      判断是否app url
 @param         URL URL
 @return        BOOL
 */
+ (BOOL)isAppURL:(NSURL *)URL;

/*!
 @method
 @abstract      应用url协议
 @return        NSString
 */
+ (NSString *)appUrlScheme;

@end
