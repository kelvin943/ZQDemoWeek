//
//  PADataModel.h
//  haofang
//
//  Created by PengFeiMeng on 3/24/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PAResponseDataProtocol.h"
#import "PATableViewCellItemBasicProtocol.h"

/*!
 @class
 @abstract      数据模型类，为所有数据模型父类
 @discussion    实现 PAResponseDataProtocol 协议，应对可能统一新增响应字段或需要 NSHTTPURLResponse 属性的可能;
                实现 PATableViewCellItemBasicProtocol 协议, 增加数据模型对 tableview cell 的适配能力
 */
@interface PADataModel : NSObject <PAResponseDataProtocol, PATableViewCellItemBasicProtocol>

// 在旧的基于 AFN 2.x 的网络层框架下，依赖 AFN 的 operation 存放 userInfo。
// 所以，在升级至基于 AFN 3.x 的网络层框架时，将 userInfo 的依赖挪至 PADataModel 中。
@property (nonatomic, copy) NSDictionary *userInfo;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;

@end

