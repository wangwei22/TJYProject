//
//  TJY_NationViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"
#import "TJY_Nation.h"
@interface TJY_NationViewController : TJY_BaseViewController
@property(nonatomic,copy)void  (^backValueBlock)(TJY_Nation *  model);
@end
