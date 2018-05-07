//
//  TJY_VisitTableViewCell.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJY_VisitInfo.h"
@interface TJY_VisitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property(nonatomic,strong) NoSign  *  model;
@property(nonatomic,strong) Sign  * signModel;

@end
