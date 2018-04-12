//
//  TJY_JSHandle.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/12.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_JSHandle.h"

@implementation TJY_JSHandle
-(instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration {
    self = [super init];
    if (self) {
        _webVC = webVC;
        _configuration = configuration;
        //js handler
        //注册JS 事件
        //        [configuration.userContentController addScriptMessageHandler:self name:@"showImages"];
        [configuration.userContentController addScriptMessageHandler:self name:@"backPage"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"showVideo"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"issueMoment"];
        //        [configuration.userContentController addScriptMessageHandler:self name:@"JSShare"];
        
    }
    return self;
}
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqualToString:@"backPage"]) {
        //返回
        if (self.webVC.presentingViewController) {
            [self.webVC dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.webVC.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)cancelHandler{
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"showImages"];
    [_configuration.userContentController removeScriptMessageHandlerForName:@"backPage"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"showVideo"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"issueMoment"];
    //    [_configuration.userContentController removeScriptMessageHandlerForName:@"JSShare"];
}
-(void)dealloc{
    [self  cancelHandler];
}
@end
