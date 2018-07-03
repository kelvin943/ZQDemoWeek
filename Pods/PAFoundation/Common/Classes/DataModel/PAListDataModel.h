//
//  PAListDataModel.h
//  haofang
//
//  Created by PengFeiMeng on 3/27/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PADataModel.h"

/*!
 @class
 @abstract  列表数据模型，用来存放列表数据，其中包含分页和查询相关标识
 */
@interface PAListDataModel : PADataModel

//数据数组
@property (nonatomic, retain) NSMutableArray *  items;
//当前页码
@property (nonatomic, retain) NSNumber       *  page;
//当前页面数据数量
@property (nonatomic, retain) NSNumber       *  rows;
//是否有更多
@property (nonatomic, assign) BOOL           hasMore;
//总数量
@property (nonatomic, assign) NSInteger      totalRecords;

//根据 Item 位置设置对应 Cell 的分隔线
- (void)updatePositionsWithMoreItems:(BOOL)hasMore;

@end
