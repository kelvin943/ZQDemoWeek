//
//  PAListDataModel.m
//  haofang
//
//  Created by PengFeiMeng on 3/27/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAListDataModel.h"

@implementation PAListDataModel


#pragma mark - synthesize
@synthesize items              = _items;
@synthesize page               = _page;
@synthesize rows               = _rows;
@synthesize hasMore            = _hasMore;
@synthesize totalRecords       = _totalRecords;

#pragma mark - setter/getter

- (NSMutableArray *)items{
    if (_items == nil) {
        _items = [NSMutableArray array];
    }
    
    return _items;
}

- (void)updatePositionsWithMoreItems:(BOOL)hasMore {
    PADataModel *firstItem = [self.items firstObject];
    firstItem.cellPosition = PACellPositionFirst;
    
    if (hasMore) {
        return;
    }
    
    if ([self.items count] == 1) {
        firstItem.cellPosition = PACellPositionOnly;
    } else {
        PADataModel *lastItem = [self.items lastObject];
        lastItem.cellPosition = PACellPositionLast;
    }
}

@end
