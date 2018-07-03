//
//  PAPlistManager.h
//
//  Created by luochenhao on 10/4/11.
//  Copyright 2011 平安好房. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAPlistManager : NSObject

@property (nonatomic, copy, readonly) NSString *fileName;   // 文件名，不带后缀
@property (nonatomic, strong) id listData;                  // Property list data
@property (nonatomic, assign, readonly) BOOL fromMainBundle;// 是否从 main bunlde 读取

/**
 管理 Property 文件

 @param fileName 不带后缀的 Property 文件名
 @param create YES  默认目录下不存在 fileName 所对应的文件则创建
               NO   默认目录下不存在 fileName 所对应的文件则尝试从 MainBundle 中读取
 @return PAPlistManager
 */
- (instancetype)initWithFileName:(NSString *)fileName autoCreate:(BOOL)create;


/**
 将 listData 持久化到 Property 文件

 @return 是否成功保存
 */
- (BOOL)save;

@end
