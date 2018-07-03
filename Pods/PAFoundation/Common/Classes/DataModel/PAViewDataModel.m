//
//  PAViewDataModel.m
//  haofang
//
//  Created by PengFeiMeng on 4/28/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#import "PAViewDataModel.h"

@implementation PAViewDataModel


- (NSNumber *)viewConformsToProtocol:(Protocol *)protocol{
    NSNumber * flag = nil;
    
    if (self.viewClass) {
        flag        = [NSNumber numberWithBool:[self.viewClass conformsToProtocol:protocol]];
    }
    
    return flag;
}
@end
