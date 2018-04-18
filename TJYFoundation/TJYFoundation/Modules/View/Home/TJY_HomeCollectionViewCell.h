//
//  TJY_HomeCollectionViewCell.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/17.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJY_AdInfomation.h"
@interface TJY_HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (nonatomic,strong)TJY_AdInfomation *  model;
@end
