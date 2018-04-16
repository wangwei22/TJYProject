//
//  UIResponder+RemoteEvent.m
//  HubeiMobileNews
//
//  Created by 徐锐 on 16/6/7.
//  Copyright © 2016年 cnhubei. All rights reserved.
//

#import "UIResponder+RemoteEvent.h"
#import <objc/runtime.h>

@implementation UIResponder (RemoteEvent)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        
        SEL oriSEL = @selector(remoteControlReceivedWithEvent:);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        SEL cusSEL = @selector(myRemoteControlReceivedWithEvent:);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        method_exchangeImplementations(oriMethod, cusMethod);
    });
}

- (void)myRemoteControlReceivedWithEvent:(UIEvent *)event
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"myRemoteControlReceived" object:event];
    [self myRemoteControlReceivedWithEvent:event];
}
//- (void)remoteControlReceivedWithEvent:(UIEvent *)event
//{
//    
//}
@end
