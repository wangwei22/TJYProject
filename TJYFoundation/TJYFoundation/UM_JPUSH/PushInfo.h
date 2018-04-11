//
//  PushInfo.h
//  ZZKong
//
//  Created by wang_wei on 2017/10/17.
//  Copyright © 2017年 zzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushInfo : NSObject
/**
 *  消息类型
 */
@property(strong,nonatomic) NSString* t;

/**
 *  新闻标识
 */
@property(strong,nonatomic) NSString* i;

/**
 *  新闻标题
 */
@property(strong,nonatomic) NSString* titleStr;
@end
