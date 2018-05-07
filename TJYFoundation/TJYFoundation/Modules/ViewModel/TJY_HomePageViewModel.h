//
//  TJY_HomePageViewModel.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/15.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_HomePageViewModel : NSObject
@property(nonatomic,strong,readonly)RACCommand * sourceCommand;
@property(nonatomic,strong,readonly)RACCommand *LoginInfoCommand;
@property(nonatomic,strong,readonly)RACCommand  * registCommand;
@property(nonatomic,strong,readonly)RACCommand  *LoginCommand;
@property(nonatomic,strong,readonly)RACCommand  *signConfigCommand;
@property(nonatomic,strong,readonly)RACCommand* signClickCommand;
@property(nonatomic,strong,readonly)RACCommand* userSignInfoCommand;
@property(nonatomic,strong,readonly)RACCommand* dayClockInfoCommand;
@property(nonatomic,strong,readonly)RACCommand* userDayClockInfoCommand;
@property(nonatomic,strong,readonly)RACCommand* monthClockInfoCommand;
@property(nonatomic,strong,readonly)RACCommand* myMonthClockInfoCommand;
@property(nonatomic,strong,readonly)RACCommand* monthClockDetailCommand;
@property(nonatomic,strong,readonly)RACCommand* attendanceCommand;
@property(nonatomic,strong,readonly)RACCommand* attendanceNewListCommand;
@property(nonatomic,strong,readonly)RACCommand* attendanceSignListCommand;
@end
