//
//  PAResponseDataProtocol.h
//  manpanxiang
//
//  Created by Linkou Bian on 28/08/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @brief 不再使用 PAResponseDataModel 类型，而是替换成 Protocol。
        如果 JSON Response 里新增统一的字段，或者需要使用 NSHTTPURLResponse 的属性（如 allHeaderFields），
        则可以在此处声明。然后由 PAWebService 统一设置。
 */
@protocol PAResponseDataProtocol <NSObject>

@end
