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
@interface TJY_HomePageViewModel()
@property(nonatomic, strong) RACCommand *sourceCommand;
@property(nonatomic,strong)RACCommand *LoginInfoCommand;
@property(nonatomic,strong)RACCommand  * registCommand;
@end
@implementation TJY_HomePageViewModel
-(RACCommand *)sourceCommand{
    if (!_sourceCommand) {
        _sourceCommand =[ [RACCommand  alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
             NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:@"1",@"id", nil];
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
                return  value;
            }];
        }];
    }
    return   _registCommand;
}
@end
