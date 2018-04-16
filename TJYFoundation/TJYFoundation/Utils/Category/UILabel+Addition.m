//
//  UILabel+Addition.m
//  HubeiMobileNews
//
//  Created by LGSC on 16/8/23.
//  Copyright © 2016年 cnhubei. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)


-(void)setLabelTextColor:(UIColor *)textColor colorAndTextArr:(NSArray *)array
{
    [self setTextColor:textColor];
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithString:self.text]];
    for (NSDictionary *dict in array) {
        NSString *middleStr = dict[@"text"];
        NSRange colorRange = NSMakeRange([[noteStr string] rangeOfString:middleStr].location, [[noteStr string] rangeOfString:middleStr].length);
        [noteStr addAttribute:NSForegroundColorAttributeName value:dict[@"color"] range:colorRange];
    }
    [self setAttributedText:noteStr];
    [self sizeToFit];
}
@end
