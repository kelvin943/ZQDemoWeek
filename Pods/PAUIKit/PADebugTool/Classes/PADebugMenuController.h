//
//  PADebugMenuController.h
//  manpanxiang
//
//  Created by 刘玉龙 on 2017/8/22.
//  Copyright © 2017年 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PAViewController.h"

@interface PADebugAction : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) SEL selector;

+ (instancetype)actionWithTitle:(NSString *)title selector:(SEL)selector;

@end

@interface PADebugMenuController : PAViewController

@property (nonatomic, strong) NSArray<NSArray<PADebugAction *> *>   *actions;

@end
