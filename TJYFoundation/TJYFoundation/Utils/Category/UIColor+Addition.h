//
//  UIColor+Addition.h
//  HubeiMobileNews
//
//  Created by andy on 15/5/13.
//  Copyright (c) 2015年 cnhubei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)
+ (UIColor *)red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (NSArray *)convertColorToRGB:(UIColor *)color;
+ (UIColor *)colorWithHex:(NSInteger)hex;

+ (UIColor*)colorWithHexString:(NSString *)hexString;
@end
