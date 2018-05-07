//
//  TJY_MyVisitTableViewCell.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/5/4.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJY_MyVisitInfo.h"
@interface TJY_MyVisitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property(nonatomic,strong)ListInfo  * model;
@end
