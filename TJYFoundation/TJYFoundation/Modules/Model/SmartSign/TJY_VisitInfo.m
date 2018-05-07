//
//  TJY_VisitInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_VisitInfo.h"

@implementation TJY_VisitInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"noSignSum":@"no_sign_sum",@"personnelSum":@"personnel_sum",@"signList":@"sign_list",@"signSum":@"sign_sum",@"noSignList":@"no_sign_list"};
}
+(NSDictionary *)mj_objectClassInArray{
    return  @{@"noSignList":[NoSign  class],@"signList":[Sign  class]};
}
@end

@implementation NoSign
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"Id":@"id",@"perName":@"per_name"};
}
@end
@implementation Sign
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"Id":@"id",@"addTime":@"add_time",@"perId":@"per_id",@"perName":@"per_name",@"signAddress":@"sign_address"};
}
@end
