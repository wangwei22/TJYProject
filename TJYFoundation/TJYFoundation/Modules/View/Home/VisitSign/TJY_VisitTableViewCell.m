//
//  TJY_VisitTableViewCell.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_VisitTableViewCell.h"

@implementation TJY_VisitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(NoSign *)model{
    _model =  model;
    self.titleLbl.text = model.perName;
    self.detailLbl.text = @"";
    self.address.text = @"";
}
-(void)setSignModel:(Sign *)signModel{
    _signModel  = signModel ;
    self.titleLbl.text = signModel.perName;
    self.address.text =  signModel.signAddress;
    self.detailLbl.text =  signModel.addTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
