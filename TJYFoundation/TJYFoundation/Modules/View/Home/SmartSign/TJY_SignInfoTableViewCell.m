//
//  TJY_SignInfoTableViewCell.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/26.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_SignInfoTableViewCell.h"


@implementation TJY_SignInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(TJY_Clock*)model{
    _model = model;
    self.titleLbl.text = model.perName;
    self.subTitle.text = model.divName;
    NSString  * isC,*isO,*isZ;
    NSMutableString  *  str = [NSMutableString  string] ;
    if ([model.isC isEqualToString:@"1"]) {
        isC = @"迟到";
        [str appendString:isC];
    }
    if ([model.isO isEqualToString:@"1"]) {
        isO = @"外勤";
        if ( str.length >0) {
            [str  appendFormat:@",%@",isO];
        }else{
            [str appendString:isO];
        }
    }
    if ([model.isZ isEqualToString:@"1"]) {
        isZ= @"早退";
        if ( str.length >0) {
           [str  appendFormat:@",%@",isZ];
        }else{
            [str appendString:isZ];
        }
    }
    self.detailTitle.text = str.length >0?str:@"正常";
}

- (void)setList:(ClockList *)list{
    _list = list;
    self.titleLbl.text = list.perName;
    self.subTitle.text = list.divName;
     self.detailTitle.text = @"未打卡";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
