//
//  PABasicDataConstructor.m
//  haofang
//
//  Created by PengFeiMeng on 4/14/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PABasicDataConstructor.h"

@implementation PABasicDataConstructor

#pragma mark - generate data

- (void)constructData {
    
}

#pragma mark - Property Method

- (NSMutableArray *)items {
    if (_items == nil) {
        self.items              = [NSMutableArray array];
    }
    
    return _items;
}

@end
