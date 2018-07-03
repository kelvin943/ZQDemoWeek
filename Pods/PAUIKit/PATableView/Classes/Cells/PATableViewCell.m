//
//  PATableViewCell.m
//  haofang
//
//  Created by PengFeiMeng on 9/4/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PATableViewCell.h"
#import "PATableViewCellItemBasicProtocol.h"

@implementation PATableViewCell

- (void)setObject:(id<PATableViewCellItemBasicProtocol>)object {
    _object = object;
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass([self class]);
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id<PATableViewCellItemBasicProtocol>)object {
    if (object.cellHeight > 0) {
        return object.cellHeight.floatValue;
    }
    return 44.0;
}

@end
