//
//  PANetworkDataConstructor.h
//  haofang
//
//  Created by PengFeiMeng on 4/14/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PABasicDataConstructor.h"
#import "PANetworkDataConstructorProtocol.h"
#import "PADataModel.h"

@protocol PANetworkDataConstructorDelegate ;

/*!
 @class
 @abstract      网络数据构造器，子类可以实现相关方法实现网络数据构造
 */
@interface PANetworkDataConstructor : PABasicDataConstructor <PANetworkDataConstructorProtocol>
{
    BOOL _loading;
}

/**
 通过代理方法可以获取网络请求结果回调
 */
@property (nonatomic, weak) id<PANetworkDataConstructorDelegate> delegate;

/**
 标记网络请求是否正在进行
 */
@property (nonatomic, readonly, getter = isLoading) BOOL loading;

@end

@protocol PANetworkDataConstructorDelegate <NSObject>

@optional

/**
 网络加载完毕

 @param dataConstructor 数据组装对象
 @param dataModel 数据返回，PADataModel的子类
 */
- (void)dataConstructor:(id)dataConstructor didFinishLoad:(PADataModel *)dataModel;

/**
 网络请求发生错误

 @param dataConstructor 数据组装对象
 @param error 出错详情
 */
- (void)dataConstructorDidFailLoadData:(id)dataConstructor withError:(NSError *)error;

@end
