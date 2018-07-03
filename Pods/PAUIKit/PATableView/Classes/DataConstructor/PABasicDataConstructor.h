//
//  PABasicDataConstructor.h
//  haofang
//
//  Created by PengFeiMeng on 4/14/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract      基础数据构造器，由子类实现相关的构造逻辑
 */
@interface PABasicDataConstructor : NSObject

/*!
 @property
 @abstract      可变数组，用来存放构造出来的数据
 */
@property (nonatomic, retain) NSMutableArray *items;

/*!
 @method
 @abstract      构造数据
 @discussion    可以是静态数据，也可以是网络请求数据，或缓存数据，由子类来实现这个方法
 */
- (void)constructData;

@end
