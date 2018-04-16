//
//  TJY_HomeRequestService.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_RequestServiceManager.h"

@interface TJY_HomeRequestService : TJY_RequestServiceManager
/**
 *  启动页广告
 *
 *  @param tag 请求标识
 */
-(void)getListAdNews:(NSInteger)tag;
/**
 *  注册
 *
 *  @param tag 请求标识
 */
-(void)getAccountRegistName:(NSString*)name password:(NSString*)password  mobile:(NSString*)mbile department:(NSString*)department duty:(NSString*)duty keyCode:(NSString*)keyCode tag:(NSInteger)tag;
/**
 *  获取部门和职位
 *
 *  @param tag 请求标识
 */
-(void)getDepartmentAndDuties:(NSInteger)tag;
/**
 *  用户登录
 *
 *  @param tag 请求标识
 */
-(void)getLoginAccountWithMobile:(NSString*)mobile  password:(NSString*)password  tag:(NSInteger)tag;
/**
 *  退出登录
 *
 *  @param tag 请求标识
 */
-(void)getLogoutAccountWithUserId:(NSString*)userId token:(NSString*)token tag:(NSInteger)tag;
/**
 *  获取所有用户
 *
 *  @param tag 请求标识
 */
-(void)getAccountInfomation:(NSInteger)tag;
@end












































