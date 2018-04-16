//
//  TJY_DutyList.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/15.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_DutyList.h"

@implementation TJY_DutyList

@end
@implementation DutyDivision
+(NSDictionary *)mj_objectClassInArray{
    return @{@"division":@"InfoList",@"duties":@"InfoList"};
}
@end

@implementation InfoList
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id",@"divName":@"div_name",@"dutyName":@"duties_name"};
}

@end

