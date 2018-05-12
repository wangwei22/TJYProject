//
//  HomePageHeader.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/15.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#ifndef HomePageHeader_h
#define HomePageHeader_h
#define  PHP_ADURL                  @"api/index/getSilde"
#define  LOGIN_INFOURL              @"api/public/getD"
#define  REGIST_URL                 @"api/public/register"
#define  LOGIN_URL                  @"api/public/login"
#define  SIGN_CONFIG                @"api/Attendance/getClockConfig"
#define  SIGN_CLICK                 @"api/Attendance/clockInsert"
#define  USER_Sign_Info             @"api/Attendance/getSamedayClock"
#define  DAY_CLOCK_URL              @"api/Attendance/everydayClocks"
#define  DAY_CLOCK_DETAIL           @"api/Attendance/everydayClockDetail"
#define  MONTH_CLOCK_DETAIL_URL     @"api/Attendance/monthClockDetail"
#define  MONTH_CLOCK_URL            @"api/Attendance/monthClock"
#define  MONTH_MY_URL               @"api/Attendance/monthClockPer"

#define  ATTENDANCE_EXAMINE_ADD_URL  @"api/Attendance/signAdd"
#define  ATTENDANCE_SIGN_NEWS_URL    @"api/Attendance/signNewList"
#define  ATTENDANCE_SIGN_LIST_URL    @"api/Attendance/signList"
#define  CUSTOMER_LIST_URL           @"api/customer/cus_list"
#define  CUSTOMER_EDIT_URL           @"api/customer/cus_edit"
#define  CUSTOMER_ADD_URL            @"api/customer/add_cus"
#define  CUSTOMER_NATION_URL         @"api/public/getN"


/*  model */
#import "TJY_AdInfomation.h"
#import "TJY_DutyList.h"
#import "UserInfo.h"
#import "TJY_ConfigInfo.h"
#import "TJY_SignInfo.h"
#import "TJY_SignClockInfo.h"
#import "TJY_Clock.h"
#import "TJY_MySignInfo.h"
#import "TJY_VisitInfo.h"
#import "TJY_MyVisitInfo.h"
#import "TJY_Nation.h"
#endif /* HomePageHeader_h */
