//
//  UserInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/16.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
MJCodingImplementation
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"divisionId":@"division_id",
              @"entryTime":@"entry_time",
              @"homeAddress":@"home_address",
              @"isQuit":@"is_quit",
              @"perLevel":@"per_level",
              @"perMobile":@"per_mobile",
              @"perName":@"per_name",
              @"quitTime":@"quit_time",
              @"userId":@"user_id",
              };
}
@end
