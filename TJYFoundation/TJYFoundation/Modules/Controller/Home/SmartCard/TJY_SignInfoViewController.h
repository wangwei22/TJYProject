//
//  TJY_SignInfoViewController.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/25.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_BaseViewController.h"
#import "TJY_SignClockInfo.h"
@interface TJY_SignInfoViewController : TJY_BaseViewController
@property(nonatomic,strong)TJY_SignClockInfo *  infoModel;
@property(nonatomic,copy)NSString  * dayStr;
@end
