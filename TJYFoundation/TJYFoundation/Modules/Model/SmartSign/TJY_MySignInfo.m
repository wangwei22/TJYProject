//
//  TJY_MySignInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/27.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MySignInfo.h"

@implementation TJY_MySignInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"cdClock":@"cd_clock",@"cqClock":@"cq_clock",@"divName":@"div_name",@"kgClock":@"kg_clock",@"perName":@"per_name",@"wqClock":@"wq_clock",@"xxClock":@"xx_clock",@"ztClock":@"zt_clock",@"qkClock":@"qk_clock"};
}
@end

@implementation CdClock
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"lateTimeSum":@"late_time_sum",@"resCount":@"res_count",@"resList":@"res_list"};
}
+(NSDictionary *)mj_objectClassInArray{
    return  @{@"resList":[ResList  class]};
}
@end

@implementation ResList
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"clockDate":@"clock_date",@"clockTime":@"clock_time",@"Id":@"id",@"lateTime":@"late_time",@"perId":@"per_id",@"timeSum":@"time_sum"};
}
@end
