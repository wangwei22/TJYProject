//
//  TJY_ConfigInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/21.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_ConfigInfo.h"

@implementation TJY_ConfigInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"endWorkTime":@"end_work_time",
             @"friIsOn":@"fri_is_on",
             @"Id":@"id",
             @"monIsOn":@"mon_is_on",
             @"staIsOn":@"sta_is_on",
             @"startWorkTime":@"start_work_time",
             @"sunIsOn":@"sun_is_on",
             @"thurIsOn":@"thur_is_on",
             @"tuesIsOn":@"tues_is_on",
             @"wedIsOn":@"wed_is_on"
             };
}
@end
