//
//  TJY_VisitSignTbarBarViewControllerConfig.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/2.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import  <CYLTabBarController/CYLTabBarController.h>
@interface TJY_VisitSignTbarBarViewControllerConfig : NSObject
@property(nonatomic,readonly,strong)CYLTabBarController  * tabBarController;
@property(nonatomic,copy)NSString  * context;
@end
