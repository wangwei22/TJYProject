//
//  TJY_HomeRequestService.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomeRequestService.h"

@implementation TJY_HomeRequestService
-(void)getListAdNews:(NSInteger)tag{
      NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:@"1",@"id", nil];
      [self startHttpRequest:dic target:@"api/index/getSilde" tag:tag];
}
-(void)getAccountRegistName:(NSString*)name password:(NSString*)password  mobile:(NSString*)mbile department:(NSString*)department duty:(NSString*)duty keyCode:(NSString*)keyCode tag:(NSInteger)tag{
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:name,@"per_name",
                           password,@"password",
                           mbile,@"per_mobile",
                           department,@"division_id",
                           duty,@"duties_id",
                           keyCode,@"key",nil];
    [self  startHttpRequest:dic target:@"api/public/register" tag:tag];
}
-(void)getDepartmentAndDuties:(NSInteger)tag{
    [self  startHttpRequest:nil target:@"api/public/getD" tag:tag];
}
-(void)getLoginAccountWithMobile:(NSString*)mobile  password:(NSString*)password  tag:(NSInteger)tag{
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:mobile,@"per_mobile",
                           password,@"password",nil];
    [self  startHttpRequest:dic target:@"api/public/login" tag:tag];
}
-(void)getLogoutAccountWithUserId:(NSString*)userId token:(NSString*)token tag:(NSInteger)tag{
    NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:userId,@"user_id",
                           token,@"token", nil];
    [self  startHttpRequest:dic target:@"api/public/logout" tag:tag];
}
-(void)getAccountInfomation:(NSInteger)tag{
    [self  startHttpRequest:nil target:@"api/public/getP" tag:tag];
}
@end
