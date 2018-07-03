//
//  PAWebViewJavascriptPOST_HTML.m
//  manpanxiang
//
//  Created by Linkou Bian on 19/09/2017.
//  Copyright © 2017 Mapping Shine (Shanghai) Network Technology Co.,Ltd. All rights reserved.
//

#import "PAWebViewJavascriptPOST_HTML.h"

/**
 原先使用 JSPOST.html 文件，仿照 WVJB 改造成了字符串方法。这样，拆解 IPA 后，看不到 JSPOST.html 文件，隐藏实现细节。
 同时，以库的形式存在时（比如私有 Pod 或 framework 等形式），不必关心 html 资源文件，便于客户程序使用。

 @return 含有辅助 WKWebView 发送 POST 请求的 HTML 字符串
 */
NSString * PAWebViewJavascriptPOST_html() {
#define __wvjp_html_func__(x) #x
    
    // BEGIN webviewJSPostHTMLCode
    static NSString * webviewJSPostHTMLCode = @__wvjp_html_func__(
    
<html>
<head>
<script>
//调用格式： post('URL', {"key": "value"});
function post(path, params) {
  var method = "post";
  var form = document.createElement("form");
  form.setAttribute("method", method);
  form.setAttribute("action", path);
  
  for(var key in params) {
      if(params.hasOwnProperty(key)) {
          var hiddenField = document.createElement("input");
          hiddenField.setAttribute("type", "hidden");
          hiddenField.setAttribute("name", key);
          hiddenField.setAttribute("value", params[key]);
          
          form.appendChild(hiddenField);
      }
  }
  document.body.appendChild(form);
  form.submit();
}
</script>
</head>
<body>
</body>
</html>
    
    ); // END webviewJSPostHTMLCode
    
#undef __wvjp_html_func__
    return webviewJSPostHTMLCode;
};
