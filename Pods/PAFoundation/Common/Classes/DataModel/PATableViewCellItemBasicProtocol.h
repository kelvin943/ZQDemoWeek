//
//  PATableViewCellItemProtocol.h
//  haofang
//
//  Created by PengFeiMeng on 3/27/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PACellPosition) {
    PACellPositionNone,
    PACellPositionFirst,
    PACellPositionMiddle,
    PACellPositionLast,
    PACellPositionOnly
};

@protocol PATableViewCellItemBasicProtocol <NSObject>

/*!
 @property
 @abstract  cell 的类
 */
@property (nonatomic, assign) Class     cellClass;

/*!
 @property
 @abstract  cell 类型
 */
@property (nonatomic, copy)   NSString  *cellType;

/*!
 @property
 @abstract  cell 高度
 */
@property (nonatomic, strong) NSNumber  *cellHeight;

/*!
 @property
 @abstract  cell 所含子控件的事件接收者
 */
@property (nonatomic, weak) id          cellTarget;

/*!
 @property
 @abstract  cell的位置，默认 PACellPositionMiddle
 */
@property (nonatomic, assign) PACellPosition cellPosition;

/*!
 @property
 @abstract  cell边线的缩进值，默认 16.0
 */
@property (nonatomic, assign) CGFloat cellLineIndent;

@property (nonatomic, assign) BOOL hideUpLineForFirst;
@property (nonatomic, assign) BOOL hideDownLineForLast;

@end
