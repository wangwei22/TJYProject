//
//  TJY_MonthTableViewCell.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/28.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJY_Clock.h"
@interface TJY_MonthTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailSubLabel;
@property(nonatomic,strong)TJY_Clock  *  model;
@end
