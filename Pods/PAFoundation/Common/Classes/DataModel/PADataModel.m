//
//  PADataModel.m
//  haofang
//
//  Created by PengFeiMeng on 3/24/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PADataModel.h"

@implementation PADataModel

#pragma mark - Properties declared in PATableViewCellItemBasicProtocol

@synthesize cellClass               = _cellClass;
@synthesize cellType                = _cellType;
@synthesize cellHeight              = _cellHeight;
@synthesize cellTarget              = _cellTarget;
@synthesize cellPosition            = _cellPosition;
@synthesize cellLineIndent          = _cellLineIndent;
@synthesize hideUpLineForFirst      = _hideUpLineForFirst;
@synthesize hideDownLineForLast     = _hideDownLineForLast;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [self init]) {
    }
    
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellPosition = PACellPositionMiddle;
        self.cellLineIndent = 16.0f;
    }
    return self;
}

@end
