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
@interface TJY_HomePageViewModel()
@property(nonatomic, strong) RACCommand *sourceCommand;
@property(nonatomic,strong)RACCommand *LoginInfoCommand;
@property(nonatomic,strong)RACCommand  * registCommand;
@property(nonatomic,strong)RACCommand  *LoginCommand;
@property(nonatomic,strong)RACCommand  *signConfigCommand;
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
                return   model;
            }];
        }];
    }
    return   _signConfigCommand;
}
@end
