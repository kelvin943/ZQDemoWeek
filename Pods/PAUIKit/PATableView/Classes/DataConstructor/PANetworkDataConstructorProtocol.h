//
//  PANetworkDataConstructorProtocol.h
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/31.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
  用协议的方式声明子类可覆盖的方法，如有特殊需求可以@required
 */
@protocol PANetworkDataConstructorProtocol <NSObject>

@optional

/*!
 @method
 @abstract      加载数据
 @discussion    子类覆盖此方法，若有多次请求，可封装为多个请求方法，然后在此处调用，具体情况具体对待
 */
- (void)loadData;

/*!
 @method
 @abstract      重置数据
 @discussion    此方法在数据重新加载的时候需要调用
 */
- (void)resetData;

/*!
 @method
 @abstract      所有item个数
 @discussion    此方法获取所有item个数
 @return        NSUInteger 总数
 */
- (NSUInteger)allItemCount;

/*!
 @method
 @abstract      没有更多的数据可以加载
 @discussion    可根据此方法判断是否还有更多数据来加载
 */
- (BOOL)hasNoMore;

@end
