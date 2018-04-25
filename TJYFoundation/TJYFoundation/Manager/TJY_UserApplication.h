//
//  TJY_UserApplication.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/16.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface TJY_UserApplication : NSObject<CLLocationManagerDelegate, CLLocationManagerDelegate>
{
    //定位服务
    CLLocationManager *_locManager;
}
/**
 *  是否是登录状态
 */
@property (nonatomic,assign,readonly) BOOL isLogined;
@property(nonatomic,strong)UserInfo  * loginUser;


//经纬度
@property (nonatomic, assign) CLLocationDegrees gLatitude;
@property (nonatomic, assign) CLLocationDegrees gLongitude;
//城市名
@property (nonatomic, copy) NSString *gLocationCity;
//街道名
@property (nonatomic, copy) NSString *gStreet;
//位置信息
@property (nonatomic, retain) CLPlacemark *gPlmark;


+(instancetype)shareManager;

/**
 *  退出登录
 */
- (void)logout;

- (double)distanceBetweenCenterLatitude:(double)centerLatitude centerLongitude:(double)centerLongitude userLatitude:(double)userLatitude  userLongitude:(double)userLongitude;
@end
