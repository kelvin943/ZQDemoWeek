//
//  PAEmptyCell.h
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/10/13.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PATableViewCell.h"
#import "PADataModel.h"

@class PAEmptyCellItem;

/**
 空cell，用以显示纯色高度不等的分割
 */
@interface PAEmptyCell : PATableViewCell

@property (nonatomic,strong) PAEmptyCellItem *item;

@end

@interface PAEmptyCellItem : PADataModel

@property (nonatomic,strong) UIColor *bgColor;

// height: 10; color: 0xF7F7F7
+ (instancetype)emptyCellItem;
+ (instancetype)emptyCellItemWithHeight:(CGFloat)height;
+ (instancetype)emptyCellItemWithBackgroundColor:(NSUInteger)hex;
+ (instancetype)emptyCellItemWithHeight:(CGFloat)height backgroundColor:(NSUInteger)hex;

@end
