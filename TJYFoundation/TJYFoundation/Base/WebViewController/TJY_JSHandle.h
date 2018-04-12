//
//  TJY_JSHandle.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/12.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
@interface TJY_JSHandle : NSObject <WKScriptMessageHandler>
@property(nonatomic,weak,readonly) UIViewController * webVC;
@property(nonatomic,strong,readonly)WKWebViewConfiguration * configuration;

-(instancetype)initWithViewController:(UIViewController *)webVC configuration:(WKWebViewConfiguration *)configuration;

-(void)cancelHandler;

@end
