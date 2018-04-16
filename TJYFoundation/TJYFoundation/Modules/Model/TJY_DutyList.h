//
//  TJY_DutyList.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/15.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_DutyList : NSObject
@property(nonatomic,copy)NSString  *msg;
@property(nonatomic,strong)NSDictionary  *result;
@property(nonatomic,copy)NSString  *status;
@end

@interface  DutyDivision:NSObject
@property(nonatomic,strong)NSArray *division;
@property(nonatomic,strong)NSArray *duties;
@end
@interface InfoList : NSObject
@property(nonatomic,copy)NSString *divName;
@property(nonatomic,copy)NSString *dutyName;
@property(nonatomic,copy)NSString * Id;
@end
