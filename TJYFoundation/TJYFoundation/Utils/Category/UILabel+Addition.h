//
//  UILabel+Addition.h
//  HubeiMobileNews
//
//  Created by LGSC on 16/8/23.
//  Copyright © 2016年 cnhubei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Addition)
/**
 //设置label的text中不同文字不同颜色
 *  @param textColor      label整体颜色值
 *  @param array          需要特殊设置的 一段文字和颜色(array里面包含的是字典,字典的数据结构包含两个字段“text”“color”,需要特殊设置文字颜色的 文字内容以及颜色)
*/
- (void)setLabelTextColor:(UIColor *)textColor colorAndTextArr:(NSArray *)array;
@end
