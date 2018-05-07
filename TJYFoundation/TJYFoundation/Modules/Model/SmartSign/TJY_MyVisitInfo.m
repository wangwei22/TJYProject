//
//  TJY_MyVisitInfo.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MyVisitInfo.h"

@implementation TJY_MyVisitInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"signSum":@"sign_sum",@"signList":@"sign_list"};
}
+(NSDictionary *)mj_objectClassInArray{
    return  @{@"signList":[ListInfo  class]};
}
@end
@implementation ListInfo
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"addD":@"add_d",@"addM":@"add_m",@"addTime":@"add_time",@"addY":@"add_y",@"cusId":@"cus_id",@"cusName":@"cus_name",@"Id":@"id",@"isNew":@"is_new",@"perId":@"per_id",@"signAddress":@"sign_address"};
}
+(NSDictionary *)mj_objectClassInArray{
    return   @{@"images":[Pictures  class]};
}
@end

@implementation  Pictures
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return  @{@"imageUrl":@"image"};
}
@end
