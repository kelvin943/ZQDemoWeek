//
//  PANavigatorProtocol.h
//  haofang
//
//  Created by PengFeiMeng on 4/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kInitMethod                                     @"__INITMETHOD__"
#define kInstanceMethod                                 @"__INSTANCEMETHOD__"
#define kClass                                          @"__CLASS__"

/*!
 @protocol  
 @abstract      使用导航器进行导航的类需要实现次协议
 */
@protocol PANavigatorProtocol <NSObject>

@required
/*!
 @method
 @abstract      初始化
 @param         query 初始化参数，字典形式
 @return        实例对象
 */
- (instancetype)initWithQuery:(NSDictionary *)query;

@optional

/*!
 @method
 @abstract      做初始化工作
 @param         query 初始化参数，字典形式
 */
- (void)doInitializeWithQuery:(NSDictionary *)query;

@end
