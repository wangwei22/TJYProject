//
//  TJY_HomeCollectionViewCell.m
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/17.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import "TJY_HomeCollectionViewCell.h"

@implementation TJY_HomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(TJY_AdInfomation *)model{
    _model = model;
    self.imgView.image = [UIImage  imageNamed:_model.imageUrl];
    self.titleLbl.text = _model.title;
}
@end
