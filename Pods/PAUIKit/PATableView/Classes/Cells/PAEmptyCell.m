//
//  PAEmptyCell.m
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/10/13.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAEmptyCell.h"
#import "UIColor+Category.h"

static const CGFloat DefaultCellHeight = 10.0f;

@implementation PAEmptyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<PATableViewCellItemBasicProtocol>)object
{
    float height = 0;
    if ([object conformsToProtocol:@protocol(PATableViewCellItemBasicProtocol)]) {
        if ([object respondsToSelector:@selector(cellHeight)]) {
            if ([object cellHeight]) {
                height = [[object cellHeight] floatValue];
            } else {
                height = DefaultCellHeight;
            }
        }
    }
    
    return height;
}

- (void)setObject:(id<PATableViewCellItemBasicProtocol>)object {
    [super setObject:object];
    
    if ([object isKindOfClass:[PAEmptyCellItem class]]) {
        PAEmptyCellItem *item = (PAEmptyCellItem *)object;
        self.item = item;
        self.backgroundColor = self.item.bgColor;
    }
}

@end

@implementation PAEmptyCellItem

// height: 10; color: 0xF7F7F7
+ (instancetype)emptyCellItem {
    return [self emptyCellItemWithHeight:10];
}

+ (instancetype)emptyCellItemWithHeight:(CGFloat)height {
    return [self emptyCellItemWithHeight:height backgroundColor:0xF7F7F7];
}

+ (instancetype)emptyCellItemWithBackgroundColor:(NSUInteger)hex {
    return [self emptyCellItemWithHeight:10 backgroundColor:hex];
}

+ (instancetype)emptyCellItemWithHeight:(CGFloat)height backgroundColor:(NSUInteger)hex {
    PAEmptyCellItem *item = [self new];
    item.cellHeight = @(height);
    item.bgColor = [UIColor colorWithHex:hex];
    item.cellClass = [PAEmptyCell class];
    
    return item;
}

@end


