//
//  NSString+textCheck.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/13.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (textCheck)
+(BOOL)isBlankString:(NSString *)string;
+(BOOL)valiMobile:(NSString *)mobile;
- (BOOL) checkPassword;
@end
