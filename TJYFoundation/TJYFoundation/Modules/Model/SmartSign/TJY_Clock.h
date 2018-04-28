//
//  TJY_Clock.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/26.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_Clock : NSObject
@property(nonatomic,copy)NSString  *perId;
@property(nonatomic,copy)NSString  *outType;
@property(nonatomic,copy)NSString  *isOutworker;
@property(nonatomic,copy)NSString  *timeType;
@property(nonatomic,copy)NSString  *clockDate;
@property(nonatomic,copy)NSString  *divisionId;
@property(nonatomic,copy)NSString  *perName;
@property(nonatomic,copy)NSString  *divName;
@property(nonatomic,copy)NSString  *isC;
@property(nonatomic,copy)NSString  *isO;
@property(nonatomic,copy)NSString  *isZ;
@property(nonatomic,copy)NSString  *Id;
@end

@interface ClockList:NSObject
@property(nonatomic,copy)NSString  *Id;
@property(nonatomic,copy)NSString  *perName;
@property(nonatomic,copy)NSString  *divName;
@end

@interface ClockDetail:NSObject
@property(nonatomic,copy)NSString*clockCount;
@property(nonatomic,strong)NSArray *clock;
@property(nonatomic,copy)NSString*noClockCount;
@property(nonatomic,strong)NSArray*noClockList;
@end
