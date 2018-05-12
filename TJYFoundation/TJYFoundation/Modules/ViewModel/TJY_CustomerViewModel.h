//
//  TJY_CustomerViewModel.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/8.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_CustomerViewModel : NSObject
@property(nonatomic,copy)NSString  * name;
@property(nonatomic,copy)NSString  *telphone ;
@property(nonatomic,copy)NSString  * sex;
@property(nonatomic,copy)NSString  * status;
@property(nonatomic,copy)NSString  * nation;
@property(nonatomic,copy)NSString  * birthday;
@property(nonatomic,copy)NSString  * idCard;
@property(nonatomic,copy)NSString  *favourite ;
@property(nonatomic,copy)NSString  * address;
@property(nonatomic,copy)NSString  * marryStatus;
@property(nonatomic,copy)NSString  * workStatus;
@property(nonatomic,copy)NSString  * company;
@property(nonatomic,copy)NSString  * position;
@property(nonatomic,copy)NSString  * emcStatus;
@property(nonatomic,copy)NSString  * vipCard;
@property(nonatomic,copy)NSString  * introduce;
@property(nonatomic,copy)NSString  * sourceFrom;
@property(nonatomic,copy)NSString  * conect;
@property(nonatomic,copy)NSString  * buyStatus;

@property(nonatomic,strong,readonly)RACCommand * customerListCommand;
@property(nonatomic,strong,readonly)RACCommand * customerEditCommand;
@property(nonatomic,strong,readonly)RACCommand *nationCommand;
@property(nonatomic,strong,readonly)RACSignal *validateTFCommand;
@end
