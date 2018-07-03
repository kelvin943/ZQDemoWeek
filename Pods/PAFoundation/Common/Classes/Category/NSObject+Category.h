//
//  NSObject+Category.h
//  haofang
//
//  Created by PengFeiMeng on 4/19/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Category)


/*!
 @method
 @abstract      判断对象是否未nil或[NSNull null]对象
 @return        BOOL
 */
- (BOOL)isNilOrNull;

/*!
 @method
 @abstract      执行selector方法
 @param         aSelector 要执行的方法
 @param         objects 参数
 @return        id
 */
- (id)performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

/*!
 @method
 @abstract      获取字符串值
 */
- (NSString *)stringValue;

@end
