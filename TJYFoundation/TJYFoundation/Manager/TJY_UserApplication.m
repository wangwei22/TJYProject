//
//  TJY_UserApplication.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/16.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_UserApplication.h"

@implementation TJY_UserApplication
+(instancetype)shareManager{
    static  TJY_UserApplication  * _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_manager) {
            _manager = [[TJY_UserApplication  alloc] init];
        }
    });
    return  _manager;
}
-(instancetype)init{
    if (self = [super init]) {
        NSString  * docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [docmentPath  stringByAppendingPathComponent:kArchiveUserInfo];
        //解档, 读取缓存数据
        _loginUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        _isLogined = YES;
        if(!_loginUser) {
            _isLogined = NO;
        }
    }
    return   self;
}
-(void)setLoginUser:(UserInfo *)loginUser{
    //用户信息缓存到本地
    _loginUser = loginUser;
    
    NSString  * docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docmentPath  stringByAppendingPathComponent:kArchiveUserInfo];
    
    //归档
    if (_loginUser) {
        
        //归档, 将用户信息缓存起来
        
        [NSKeyedArchiver archiveRootObject:_loginUser toFile:filePath];
        _isLogined = YES;
        
    }else{
        //删除归档文件
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filePath]) {
            [defaultManager removeItemAtPath:filePath error:nil];
        }
        _isLogined = NO ;
        
    }
}
-(void)logout{
    NSString  * docmentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [docmentPath  stringByAppendingPathComponent:kArchiveUserInfo];
    //删除归档文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:filePath]) {
        [defaultManager removeItemAtPath:filePath error:nil];
    }
    KPostNotification(KNotificationLoginStateChange, @NO);
    _isLogined = NO ;
    _loginUser = nil;
}
@end
