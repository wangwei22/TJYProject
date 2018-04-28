//
//  TJY_SignClockInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SignClockInfo.h"

@implementation TJY_SignClockInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"dkCount":@"dk_count",@"dkCountCd":@"dk_count_cd",@"dkCountWq":@"dk_count_wq",@"dkCountZt":@"dk_count_zt",@"wdkCount":@"wdk_count",@"ydCount":@"yd_count",};
}
@end
@implementation  MonthClockInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"kqCount":@"kq_count",@"cdCount":@"cd_count",@"ztCount":@"zt_count",@"wqCount":@"wq_count",@"kgkCount":@"kg_count",@"qjCount":@"qj_count"};
}
@end

@implementation BaseModel
@end
