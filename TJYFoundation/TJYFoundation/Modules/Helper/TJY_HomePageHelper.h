//
//  TJY_HomePageHelper.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/17.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TJY_HomePageHelper : NSObject
@property(strong, nonatomic, readonly) NSArray *data;
@property(strong, nonatomic) NSDictionary  *  dic;
@property(strong,nonatomic)NSMutableArray  * imgArray;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                            dataSource:(RACSignal *)source
                      selectionCommand:(RACCommand *)command
                          templateCell:(UINib *)nibCell;
@end
