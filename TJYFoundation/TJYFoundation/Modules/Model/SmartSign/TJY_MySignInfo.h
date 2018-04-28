//
//  TJY_MySignInfo.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/27.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_MySignInfo : NSObject
@property(nonatomic,strong)NSDictionary  *cdClock;
@property(nonatomic,strong)NSDictionary  *cqClock;
@property(nonatomic,copy)NSString  *divName;
@property(nonatomic,strong)NSDictionary  *kgClock;
@property(nonatomic,copy)NSString  *perName;
@property(nonatomic,strong)NSDictionary  *wqClock;
@property(nonatomic,strong)NSDictionary  *xxClock;
@property(nonatomic,strong)NSDictionary  *ztClock;
@property(nonatomic,strong)NSDictionary  *qkClock;
@end
@interface  CdClock :NSObject
@property(nonatomic,copy)NSString  *lateTimeSum;
@property(nonatomic,copy)NSString  *resCount;
@property(nonatomic,strong)NSArray  *resList;
@end

@interface  ResList :NSObject
@property(nonatomic,copy)NSString  *clockDate;
@property(nonatomic,copy)NSString  *clockTime;
@property(nonatomic,copy)NSString  *Id;
@property(nonatomic,copy)NSString  *lateTime;
@property(nonatomic,copy)NSString  *perId;
@property(nonatomic,copy)NSString  *timeSum;
@property(nonatomic,copy)NSString  *week;
@property(nonatomic,copy)NSString  *address;
@end

