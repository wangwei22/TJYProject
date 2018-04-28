//
//  TJY_SignInfoHelper.h
//  TJYFoundation
//
//  Created by wang_wei on 2018/4/27.
//  Copyright © 2018年 wangwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol  TJY_SignInfoHelperDelegate <NSObject>
@optional
-(void)pushViewControllersIndexPath:(NSIndexPath*)indexPath flag:(NSInteger)flag  titleString:(NSString*)text;
@end
@interface TJY_SignInfoHelper : NSObject
@property(strong, nonatomic) NSArray *dataArray;
@property(nonatomic,assign)NSInteger  flag;
@property(nonatomic,assign)id<TJY_SignInfoHelperDelegate>delegate;
@property(nonatomic,strong)RACSignal  *  changeCommand;
- (instancetype)initWithTableView:(UITableView *)tableView sourceSignal:(RACSignal *)source selectionCommand:(RACCommand *)selection customCellClass:(Class)clazz ;
@end
