//
//  TJY_SignClockInfo.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_SignClockInfo : NSObject
@property(nonatomic,copy)NSString *dkCount;
@property(nonatomic,copy)NSString *dkCountCd;
@property(nonatomic,copy)NSString *dkCountWq;
@property(nonatomic,copy)NSString *dkCountZt;
@property(nonatomic,copy)NSString *wdkCount;
@property(nonatomic,copy)NSString *ydCount;
@end

@interface MonthClockInfo : NSObject
@property(nonatomic,copy)NSString *kqCount;
@property(nonatomic,copy)NSString *cdCount;
@property(nonatomic,copy)NSString *ztCount;
@property(nonatomic,copy)NSString *wqCount;
@property(nonatomic,copy)NSString *kgkCount;
@property(nonatomic,copy)NSString *qjCount;
@end

@interface    BaseModel :NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;
@end
