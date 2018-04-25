//
//  TJY_HomePageViewModel.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/15.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomePageViewModel.h"
#import "HomePageHeader.h"
#import "TJY_AdInfomation.h"
#import "TJY_DutyList.h"
#import "UserInfo.h"
#import "TJY_ConfigInfo.h"
#import "TJY_SignInfo.h"
@interface TJY_HomePageViewModel()
@property(nonatomic, strong) RACCommand *sourceCommand;
@property(nonatomic,strong)RACCommand *LoginInfoCommand;
@property(nonatomic,strong)RACCommand  * registCommand;
@property(nonatomic,strong)RACCommand  *LoginCommand;
@property(nonatomic,strong)RACCommand  *signConfigCommand;
@property(nonatomic,strong)RACCommand* signClickCommand;
@property(nonatomic,strong)RACCommand* userSignInfoCommand;
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
@end
