//
//  TJY_HomePageViewModel.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/15.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomePageViewModel.h"
#import "HomePageHeader.h"

@interface TJY_HomePageViewModel()
@property(nonatomic, strong) RACCommand *sourceCommand;
@property(nonatomic,strong)RACCommand *LoginInfoCommand;
@property(nonatomic,strong)RACCommand  * registCommand;
@property(nonatomic,strong)RACCommand  *LoginCommand;
@property(nonatomic,strong)RACCommand  *signConfigCommand;
@property(nonatomic,strong)RACCommand* signClickCommand;
@property(nonatomic,strong)RACCommand* userSignInfoCommand;
@property(nonatomic,strong)RACCommand* dayClockInfoCommand;
@property(nonatomic,strong)RACCommand* userDayClockInfoCommand;
@property(nonatomic,strong)RACCommand* monthClockInfoCommand;
@property(nonatomic,strong)RACCommand* myMonthClockInfoCommand;
@property(nonatomic,strong)RACCommand* monthClockDetailCommand;
@end
@implementation TJY_HomePageViewModel
-(RACCommand *)sourceCommand{
    if (!_sourceCommand) {
        _sourceCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary  * dic ) {
            return [[AFNetWorkUtils  racPOSTWthURL:PHP_ADURL params:dic] map:^id _Nullable(id  _Nullable value) {
                  NSUDSetUserStartAd([value objectForKey:@"result"]);
                return   value;
            }];
        }];
    }
    return  _sourceCommand;
}
-(RACCommand *)LoginInfoCommand{
    if (!_LoginInfoCommand) {
        _LoginInfoCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [ [AFNetWorkUtils  racPOSTWithURL:LOGIN_INFOURL params:nil class:[TJY_DutyList class] ] map:^id _Nullable(id  _Nullable value) {
                TJY_DutyList *  model = (TJY_DutyList * )value;
                 DutyDivision *sm =    [DutyDivision  mj_objectWithKeyValues:model.result];
                return  sm;
            }];
        }];
    }
    return  _LoginInfoCommand;
}
-(RACCommand *)registCommand{
    if (!_registCommand) {
        _registCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSDictionary * input) {
            return [[AFNetWorkUtils  racPOSTWthURL:REGIST_URL params:input] map:^id _Nullable(NSDictionary * value) {
                GMLog("valve:::%@",value);
                return  value;
            }];
        }];
    }
    return   _registCommand;
}
-(RACCommand *)LoginCommand{
    if (!_LoginCommand) {
        _LoginCommand  =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple * input) {
            return[ [AFNetWorkUtils  racPOSTWthURL:LOGIN_URL params:input.first] map:^id _Nullable(id  _Nullable value) {
                UserInfo  * user = [UserInfo  mj_objectWithKeyValues:[value objectForKey:@"result"]];
                return   user;
            }];
        }];
    }
    return  _LoginCommand;
}
-(RACCommand *)signConfigCommand{
    if (!_signConfigCommand) {
        _signConfigCommand = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull( id  _Nullable input) {
            return[ [AFNetWorkUtils  racPOSTWthURL:SIGN_CONFIG params:input] map:^id _Nullable(id  _Nullable value) {
                TJY_ConfigInfo *  model = [TJY_ConfigInfo  mj_objectWithKeyValues:[value  objectForKey:@"result"]];
                double r = [model.ranges doubleValue];
                double distance = [[TJY_UserApplication  shareManager] distanceBetweenCenterLatitude:[TJY_UserApplication shareManager].gLatitude centerLongitude:[TJY_UserApplication  shareManager].gLongitude userLatitude:[model.lat doubleValue]  userLongitude:[model.lng doubleValue]];
                if (distance  <= r) {
                    // 在范围内的提示
                    return [RACTuple  tupleWithObjects:model,@"出勤打卡", nil];
                }else {
                    // 不在范围内的提示
                    return   [RACTuple  tupleWithObjects:model,@"外勤打卡", nil];
                }
            }];
        }];
    }
    return   _signConfigCommand;
}
-(RACCommand *)signClickCommand{
    if (!_signClickCommand) {
        _signClickCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(NSString * input) {
            [MBProgressHUD  showActivityMessageInView:@"正在打卡"];
             UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            NSDateFormatter  *  formatter = [[NSDateFormatter  alloc] init];
            formatter.AMSymbol = @"上午";
            formatter.PMSymbol = @"下午";
            [formatter  setDateFormat:@"HH:mm:ss aaa"];
            NSString  *  timetamp = [formatter  stringFromDate:[NSDate  date]];
            NSString  * _flag = [NSString  string];
            if ([timetamp  rangeOfString:@"上午"].location !=NSNotFound) {
                _flag = @"1";
            }else{
                _flag = @"2";
            }
            NSDictionary *  dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.userId,@"user_id", user.token,@"token",_flag,@"time_type",[NSString  stringWithFormat:@"%f",[TJY_UserApplication shareManager].gLongitude],@"lng",[NSString  stringWithFormat:@"%f",[TJY_UserApplication  shareManager].gLatitude],@"lat",input,@"address",nil];
            return [[AFNetWorkUtils  racPOSTWthURL:SIGN_CLICK params:dic] map:^id _Nullable(id  _Nullable value) {
                [MBProgressHUD  showTipMessageInWindow:[value  objectForKey:@"msg"]];
                return   value;
            }];
        }];
    }
    return  _signClickCommand;
}
-(RACCommand *)userSignInfoCommand{
    if (!_userSignInfoCommand) {
        _userSignInfoCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
             [MBProgressHUD   showActivityMessageInWindow:@""];
            UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            NSDateFormatter  *  format = [[NSDateFormatter  alloc] init];
            [format  setDateFormat:@"yyyy.MM.dd"];
            NSString  * dateString = [format  stringFromDate:[NSDate  date]];
            NSDictionary  *  dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id", dateString,@"day",nil];
            return [[AFNetWorkUtils  racPOSTWthURL:USER_Sign_Info params:dic] map:^id _Nullable(id  _Nullable value) {
                TJY_SignInfo  *signAm = [TJY_SignInfo  mj_objectWithKeyValues:[[value  objectForKey:@"result"] objectForKey:@"clock_am"]];
                TJY_SignInfo  *signPm = [TJY_SignInfo  mj_objectWithKeyValues:[[value  objectForKey:@"result"] objectForKey:@"clock_pm"]];
                NSArray *  array = @[signAm,signPm];
                return   array;
            }];
        }];
    }
    return   _userSignInfoCommand;
}
-(RACCommand *)dayClockInfoCommand{
    if (!_dayClockInfoCommand) {
          UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
        _dayClockInfoCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           [MBProgressHUD   showActivityMessageInWindow:@""];
            NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id", input,@"day",nil];
            return [ [AFNetWorkUtils  racPOSTWthURL:DAY_CLOCK_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                TJY_SignClockInfo * info = [TJY_SignClockInfo  mj_objectWithKeyValues:[value  objectForKey:@"result"]];
                NSLog(@"%@",value);
                GMLog("%@----%@",DAY_CLOCK_URL,dic);
                return  info;
            }];
        }];
    }
    return  _dayClockInfoCommand;
}
-(RACCommand *)userDayClockInfoCommand{
    if (!_userDayClockInfoCommand) {
          UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
        _userDayClockInfoCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple  *  input) {
             [MBProgressHUD   showActivityMessageInWindow:@""];
           NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id", input.first,@"day",input.second,@"out_type",input.third,@"is_outworker",nil];
            return [[AFNetWorkUtils  racPOSTWthURL:DAY_CLOCK_DETAIL params:dic] map:^id _Nullable(id  _Nullable value) {
                ClockDetail   * model = [ClockDetail  mj_objectWithKeyValues:[value  objectForKey:@"result"]];
                GMLog("....%@ ----%@ ---- %@",value,dic,DAY_CLOCK_DETAIL);
                return   model;
            }] ;
        }];
    }
    return  _userDayClockInfoCommand;
}
-(RACCommand *)monthClockInfoCommand{
    if (!_monthClockInfoCommand) {
          UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
        _monthClockInfoCommand = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull( RACTuple *  input) {
            [MBProgressHUD   showActivityMessageInWindow:@""];
            NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id", input.first,@"month",nil];
            return [ [AFNetWorkUtils  racPOSTWthURL:MONTH_CLOCK_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                MonthClockInfo  *  info = [MonthClockInfo  mj_objectWithKeyValues:[value  objectForKey:@"result"]];
                  GMLog("....%@ ----%@ ---- %@",value,dic,MONTH_CLOCK_URL);
                NSArray  *  array = @[info.cdCount,info.ztCount,info.wqCount,info.kgkCount,info.qjCount];
                NSArray * titleArray = @[@"迟到",@"早退",@"外勤",@"旷工",@"请假"];
                NSMutableArray  * mutArray = [NSMutableArray  array];
                [array  enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BaseModel *model = [BaseModel  new];
                    model.title = titleArray[idx];
                    model.detail = obj;
                    [mutArray  addObject:model];
                }];
                RACTuple  *tupe = [RACTuple  tupleWithObjects:mutArray,info.kqCount, nil];
                return   tupe;
            }];
        }];
    }
    return  _monthClockInfoCommand;
}
-(RACCommand *)myMonthClockInfoCommand{
    if (!_myMonthClockInfoCommand) {
        _myMonthClockInfoCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(RACTuple * input) {
            [MBProgressHUD   showActivityMessageInWindow:@""];
            UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            NSDateFormatter  *  format = [[NSDateFormatter  alloc] init];
            [format  setDateFormat:@"yyyy.MM"];
            NSString  * dateString = [format  stringFromDate:[NSDate  date]];
            NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id",[input.first length] >0?input.first:user.userId,@"per_id",[input.second  length]>0?input.second:dateString,@"month",nil];
            return  [[AFNetWorkUtils  racPOSTWthURL:MONTH_MY_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                TJY_MySignInfo * info = [TJY_MySignInfo  mj_objectWithKeyValues:[value  objectForKey:@"result"]];
                CdClock * cdModel  = [CdClock  mj_objectWithKeyValues:info.cdClock];
                CdClock * cqModel  = [CdClock mj_objectWithKeyValues:info.cqClock];
                CdClock * kgModel  = [CdClock mj_objectWithKeyValues:info.kgClock];
                CdClock *qkModel  =  [CdClock mj_objectWithKeyValues:info.qkClock];
                CdClock *wqModel  = [CdClock  mj_objectWithKeyValues:info.wqClock];
                CdClock *xxModel  =  [CdClock mj_objectWithKeyValues:info.xxClock];
                CdClock *ztModel   =   [CdClock mj_objectWithKeyValues:info.ztClock];
                GMLog("....%@",value);
                NSArray *  array = @[cqModel,xxModel,cdModel, ztModel,qkModel,kgModel,wqModel];
                NSArray *  title = @[@"出勤天数",@"休息天数",@"迟到",@"早退",@"缺卡", @"旷工",@"外勤"];
                RACTuple  *  tupe = [RACTuple  tupleWithObjects:array,@"",title,nil];
                return  tupe;
            }];
        }];
    }
    return  _myMonthClockInfoCommand;
}
-(RACCommand *)monthClockDetailCommand{
    if (!_monthClockDetailCommand) {
        _monthClockDetailCommand   = [[RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            [MBProgressHUD   showActivityMessageInWindow:@""];
            UserInfo  *  user = [TJY_UserApplication  shareManager].loginUser;
            NSDateFormatter  *  format = [[NSDateFormatter  alloc] init];
            [format  setDateFormat:@"yyyy.MM"];
            NSString  * dateString = [format  stringFromDate:[NSDate  date]];
            NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:user.token,@"token",user.userId,@"user_id",user.userId,@"per_id",dateString,@"month",input,@"type",nil];
            return [ [AFNetWorkUtils  racPOSTWthURL:MONTH_CLOCK_DETAIL_URL params:dic] map:^id _Nullable(id  _Nullable value) {
                NSArray  *  array = [TJY_Clock  mj_objectArrayWithKeyValuesArray:[value  objectForKey:@"result"]];
                GMLog("......%@",value);
                return   array;
            }];
        }];
    }
    return  _monthClockDetailCommand;
}
@end









