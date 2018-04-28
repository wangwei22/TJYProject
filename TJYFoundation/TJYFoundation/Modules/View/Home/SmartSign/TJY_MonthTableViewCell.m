//
//  TJY_MonthTableViewCell.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/28.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_MonthTableViewCell.h"

@implementation TJY_MonthTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TJY_Clock *)model{
    _model =  model;
    self.titleLabel.text = model.perName?model.perName:@"";
    self.subTitleLabel.text = model.divName?model.divName:@"";
//    self.detailTitleLabel.text = model
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
