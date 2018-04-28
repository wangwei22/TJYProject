//
//  TJY_SignInfoTableViewCell.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/26.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJY_Clock.h"
@interface TJY_SignInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subDetailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property(nonatomic,strong) TJY_Clock *  model;
@property(nonatomic,strong) ClockList * list;

@end
