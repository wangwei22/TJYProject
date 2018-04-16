//
//  TJY_UserApplication.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/16.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"
@interface TJY_UserApplication : NSObject
/**
 *  是否是登录状态
 */
@property (nonatomic,assign,readonly) BOOL isLogined;
@property(nonatomic,strong)UserInfo  * loginUser;
+(instancetype)shareManager;
/**
 *  退出登录
 */
- (void)logout;
@end
