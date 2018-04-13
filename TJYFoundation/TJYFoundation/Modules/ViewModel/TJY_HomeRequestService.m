//
//  TJY_HomeRequestService.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomeRequestService.h"

@implementation TJY_HomeRequestService
-(void)getListAdNews:(NSInteger)tag{
      NSDictionary  * dic = [NSDictionary  dictionaryWithObjectsAndKeys:@"1",@"id", nil];
      [self startHttpRequest:dic target:@"api/index/getSilde" tag:tag];
}
@end
