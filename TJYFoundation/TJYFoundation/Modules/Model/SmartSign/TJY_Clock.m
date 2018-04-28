//
//  TJY_Clock.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/26.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_Clock.h"

@implementation TJY_Clock
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"perId":@"per_id",@"outType":@"out_type",@"isOutworker":@"is_outworker",@"timeType":@"time_type",@"clockDate":@"clock_date",@"divisionId":@"division_id",@"perName":@"per_name",@"divName":@"div_name",@"isC":@"is_c",@"isO":@"is_o",@"isZ":@"is_z",@"Id":@"id"};
}
@end

@implementation  ClockList
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"Id":@"id",@"perName":@"per_name",@"divName":@"div_name"};
}
@end
@implementation ClockDetail
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"clockCount":@"clock_count",@"noClockCount":@"no_clock_count",@"noClockList":@"no_clock_list"};
}
+(NSDictionary *)mj_objectClassInArray{
    return  @{@"clock":[TJY_Clock  class],@"noClockList":[ClockList  class]};
}
@end
