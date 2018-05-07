//
//  TJY_MyVisitTableViewCell.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MyVisitTableViewCell.h"

@implementation TJY_MyVisitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ListInfo *)model{
    _model = model;
    self.timeLbl.text = [self  dateWithTimeIntervalString:model.addTime];
    self.address.text =  model.signAddress;
    self.titleLbl.text = @"";
}
-(NSString *)dateWithTimeIntervalString:(NSString *)string{
    
    NSString * timeStampString = string;
    NSTimeInterval _interval=[timeStampString doubleValue] / 1.0; // 毫秒 1000。0  秒 1.0
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    [objDateformat setDateFormat:@"HH:mm"];
    return [objDateformat stringFromDate: date];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
