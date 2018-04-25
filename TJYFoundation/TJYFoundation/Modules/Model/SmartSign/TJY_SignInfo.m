//
//  TJY_SignInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/23.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SignInfo.h"

@implementation TJY_SignInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"clockDate":@"clock_date",@"clockRange":@"clock_range",@"clockTime":@"clock_time",@"isOutworker":@"is_outworker",@"outTime":@"out_time",@"outType":@"out_type",@"perId":@"per_id",@"timeType":@"time_type",@"Id":@"id"};
}
@end
