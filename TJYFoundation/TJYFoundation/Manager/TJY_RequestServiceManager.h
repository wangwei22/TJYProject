//
//  TJY_RequestServiceManager.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#pragma  mark  delegate
@protocol  TJY_RequestServiceManagerDelegate<NSObject>
@optional
/**
 请求完成时-调用
 */
-(void)getFinished:(NSDictionary *)obj tag:(long long)tag;

/**
 请求失败时-调用
 */
-(void)getError:(NSError *)error tag:(long long)tag;
@end
@interface TJY_RequestServiceManager : NSObject
#pragma mark -method
- (id)initWithDelegate:(id)delegate;
-(void)cancel;
#pragma mark - 其他
-(void)startHttpRequest:(NSDictionary*)dic target:(NSString*)target tag:(long long)tag;
@end
