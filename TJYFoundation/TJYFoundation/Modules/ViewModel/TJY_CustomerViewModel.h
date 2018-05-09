//
//  TJY_CustomerViewModel.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/8.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_CustomerViewModel : NSObject
@property(nonatomic,strong,readonly)RACCommand * customerListCommand;
@end
