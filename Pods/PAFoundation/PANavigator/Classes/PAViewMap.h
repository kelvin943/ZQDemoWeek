//
//  PAViewMap.h
//  haofang
//
//  Created by PengFeiMeng on 5/6/14.
//  Copyright (c) 2014 平安好房. All rights reserved.
//

#ifndef haofang_PAViewMap_h
#define haofang_PAViewMap_h


#define APPURL_HOST_VIEW                                                @"view"
#define APPURL_HOST_SERVICE                                             @"service"

// 参数，是否回溯
#define APPURL_PARAM_RETROSPECT                                         @"_retrospect"
// 参数，是否需要切换效果
#define APPURL_PARAM_ANIMATED                                           @"_animated"

#pragma mark - --------------------- SERVICE ---------------------

// 退出当前页面()  使用 openURL 调用
#define APPURL_SERVICE_IDENTIFIER_VIEWEXIT                              @"viewExit"
// 退到root页面
#define APPURL_SERVICE_IDENTIFIER_POPTOROOT                             @"popToRoot"

#pragma mark - ---------------------  VIEW   ---------------------

#define APPURL_VIEW_IDENTIFIER_WEBVIEW                                  @"webview"

#endif
