//
//  PATableViewCell.h
//  haofang
//
//  Created by PengFeiMeng on 9/4/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PATableViewCellItemBasicProtocol.h"

@class PATableViewCell;

/**
 按钮点击代理，简单事件无需额外写代理
 */
@protocol PATableViewCellButtonDelegate <NSObject>

- (void)cell:(PATableViewCell *)cell didTappedButton:(UIButton *)button;

@end

/*!
 @class
 @abstract      自定义tableview cell
 @discussion    此cell应为其他cell的父类或根类
 */

@interface PATableViewCell : UITableViewCell


/**
 cell对应的数据源
 */
@property (nonatomic, strong) id<PATableViewCellItemBasicProtocol> object;

/**
 提供简单的按钮代理，以方便调用
 */
@property (nonatomic, weak) id<PATableViewCellButtonDelegate> buttonDelegate;

/**
 默认取 Cell 的类名

 @return cell 标识
 */
+ (NSString *)cellIdentifier;

/**
 子类需要覆盖此方法返回cell高度，否则使用默认高度44

 @param tableView tableView
 @param object object
 @return cell 高度
 */
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id<PATableViewCellItemBasicProtocol>)object;

@end
