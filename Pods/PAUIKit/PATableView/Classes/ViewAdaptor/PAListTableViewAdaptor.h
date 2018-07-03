//
//  PAListTableViewAdaptor.h
//  haofang
//
//  Created by PengFeiMeng on 3/27/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PATableHeaderDragRefreshView.h"
#import "PALoadFooterView.h"

#import "PATableViewCellItemBasicProtocol.h"
#import "PATableViewCell.h"

@protocol PAListTableViewAdaptorDelegate ;

/*!
 @class
 @abstract      该类处理tableview适配工作
 @discussion    处理plain类型的tableview相关适配工作,使用的时候需要将tableview的datasource和delegate设置成本类的实例对象
 */
@interface PAListTableViewAdaptor : NSObject <UITableViewDataSource, UITableViewDelegate>

/**
 tableView
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 cell 显示所需数据数组,其中每个数据模型都必须实现PATableViewCellItemBasicProtocol协议
 */
@property (nonatomic, strong) NSMutableArray *items;

/**
 下拉刷新控制开关
 */
@property (nonatomic, assign) BOOL dragRefreshEnable;

/**
 上拉刷新控制开关
 */
@property (nonatomic, assign) BOOL loadMoreEnable;

/**
 下拉刷新View
 */
@property (nonatomic, strong) PATableHeaderDragRefreshView *headerRefreshView;

/**
 上拉加载View
 */
@property (nonatomic, strong) PALoadFooterView *loadMoreView;

/**
 delegate是让代理对象去处理点击事件
 */
@property (nonatomic, weak)   id<PAListTableViewAdaptorDelegate> delegate;


/**
 网络加载完毕时，调用此方法还原下拉刷新的状态
 */
- (void)finishLoadingData;

@end

/*!
 @protocol
 @abstract  PAListTableViewAdaptor 代理
 */
@protocol PAListTableViewAdaptorDelegate <NSObject>

@optional

/**
 处理tableview cell选中事件

 @param tableView tableView
 @param object 选中的cell对用的数据模型
 @param indexPath 被选中的cell的indexpath
 */
- (void)tableView:(UITableView *)tableView didSelectObject:(id<PATableViewCellItemBasicProtocol>)object rowAtIndexPath:(NSIndexPath *)indexPath;

/**
 对cell设置数据源之后调用

 @param tableView tableView
 @param object 选中的cell对用的数据模型
 @param cell cell
 */
- (void)tableView:(UITableView *)tableView didSetObject:(id<PATableViewCellItemBasicProtocol>)object cell:(UITableViewCell *)cell;

/**
 类似tableview的代理，是否可以编辑cell
 
 @param tableView tableView
 @param indexPath indexPath
 @return 是否可以编辑cell
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 类似tableview的代理，设置tablview编辑样式

 @param tableView tableView
 @param indexPath indexPath
 @return 编辑样式
 */
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 类似tableview的代理，处理编辑事件

 @param tableView  tableView
 @param editingStyle 编辑样式
 @param indexPath indexPath
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 类似tableview的代理，设置删除左滑动时的标题

 @param tableView tableView
 @param indexPath indexPath
 @return 标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 是否处理网络请求的加载状态

 @param tableView tableView
 @return 是否在加载
 */
- (BOOL)tableViewDataIsLoading:(UITableView *)tableView;


/**
 下拉刷新回调事件

 @param tableView tableView
 */
- (void)tableViewTriggerRefresh:(UITableView *)tableView;


/**
 上拉加载回调事件

 @param tableView tableView
 */
- (void)tableViewReachToEnd:(UITableView *)tableView;

@end
