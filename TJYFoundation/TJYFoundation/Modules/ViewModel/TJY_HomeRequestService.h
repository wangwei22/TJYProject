//
//  TJY_HomeRequestService.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_RequestServiceManager.h"

@interface TJY_HomeRequestService : TJY_RequestServiceManager
/**
 *  启动页广告
 *
 *  @param tag 请求标识
 */
-(void)getListAdNews:(NSInteger)tag;
@end
