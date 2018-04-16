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
@end
