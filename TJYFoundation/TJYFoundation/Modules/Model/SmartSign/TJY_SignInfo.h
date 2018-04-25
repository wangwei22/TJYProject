//
//  TJY_SignInfo.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/23.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_SignInfo : NSObject
@property(nonatomic,copy)NSString  * address;
@property(nonatomic,copy)NSString  * clockDate;
@property(nonatomic,copy)NSString  * clockRange;
@property(nonatomic,copy)NSString  * clockTime;
@property(nonatomic,copy)NSString  * Id;
@property(nonatomic,copy)NSString  * isOutworker;
@property(nonatomic,copy)NSString  * lat;
@property(nonatomic,copy)NSString  * lng;
@property(nonatomic,copy)NSString  * outTime;
@property(nonatomic,copy)NSString  * outType;
@property(nonatomic,copy)NSString  * perId;
@property(nonatomic,copy)NSString  * reason;
@property(nonatomic,copy)NSString  * timeType;
@end

