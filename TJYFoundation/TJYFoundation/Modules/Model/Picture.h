//
//  Picture.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/11.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject
/**
 *  图片地址
 */
@property (strong, nonatomic) NSString* u;
/**
 *  图片标题
 */
@property (strong, nonatomic) NSString* t;
/**
 *  图片摘要
 */
@property (copy, nonatomic) NSString* d;

/**
 *  图片宽度
 */
@property (copy, nonatomic) NSString* w;

/**
 *  图片高度
 */
@property (copy, nonatomic) NSString* h;

@end
