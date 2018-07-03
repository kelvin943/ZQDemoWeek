//
//  PAViewDataModel.h
//  haofang
//
//  Created by PengFeiMeng on 4/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PADataModel.h"

/*!
 @class
 @abstract      view相关数据封装，这些数据用于viewcontroller全局跳转使用
 */
@interface PAViewDataModel : PADataModel

// view 的类
@property (nonatomic, strong)   Class                   viewClass;
// view 初始化方法
@property (nonatomic, strong)   NSValue             *   viewInitMethod;
// view 实例化方法
@property (nonatomic, strong)   NSValue             *   viewInstanceMethod;
// 初始化方法参数，是字典类型
@property (nonatomic, strong)   NSMutableDictionary *   queryForInitMethod;
// 实例方法参数，字典类型
@property (nonatomic, strong)   NSMutableDictionary *   queryForInstanceMethod;
// identifier
@property (nonatomic, copy)     NSString            *   identifier;
/*!
 @property
 @abstract      字典，用来存放属性键值对
 */
@property (nonatomic, strong)   NSDictionary        *    propertyDictionary;


/*!
 @method
 @abstract      viewcontroller是否遵守协议
 @param         protocol 协议
 @return        NSNumber,是否遵守协议
 */
- (NSNumber *)viewConformsToProtocol:(Protocol *)protocol;

@end
